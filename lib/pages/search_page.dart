import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/services/user_service.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/viewmodels/post_viewmodel.dart';

class SearchPage extends StatefulWidget {
  static final String pageName = "searchPage";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchEditingController =
      TextEditingController();
  final _userService = UserService();
  List<User> _users = [];
  String _searchText = "";
  Future<List<User>> _leaderBoard;

  @override
  void initState() {
    _leaderBoard = _userService.getLeaderBoards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: kScreenHeight(context),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                color: Theme.of(context).backgroundColor,
                margin: EdgeInsets.zero,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                shadowColor: Colors.grey.withOpacity(0.4),
                child: Row(
                  children: [
                    // IconButton(
                    //     icon: Icon(
                    //       Icons.arrow_back_outlined,
                    //       color: Colors.grey,
                    //     ),
                    //     onPressed: () {}),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: TextField(
                          controller: _searchEditingController,
                          autofocus: true,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color),
                          onChanged: (value) async {
                            setState(() {
                              _searchText = value;
                            });
                            if (value.trim() == '') {
                              setState(() {
                                _users = [];
                                return;
                              });
                            } else {
                              var searchResult =
                                  await _userService.searchUser(value: value);
                              setState(() {
                                List<User> users = [];
                                searchResult.docs.forEach((e) {
                                  var user = User.fromJson(e.data());
                                  user.uid = e.id;
                                  users.add(user);
                                });
                                _users = users;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: _searchText.length > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchEditingController.clear();
                                        setState(() {
                                          _searchText = "";
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColorLight,
                                size: 20,
                              ),
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColorLight),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    // IconButton(
                    //     icon: Icon(
                    //       Icons.tune,
                    //       color: Colors.grey,
                    //     ),
                    //     onPressed: () {}),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text("Leaderboard"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: FutureBuilder(
                    future: _leaderBoard,
                    builder: (context, AsyncSnapshot<List<User>> snapshot) {
                      print(snapshot);
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            ...snapshot.data.map((e) {
                              return _searchListItem(e);
                            }).toList()
                          ],
                        );
                      } else if (snapshot.hasError) {
                        Center(
                            child:
                                Text("Error while fetching leaderboard data."));
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Search Results"),
              ),
              Expanded(
                child: Container(
                  child: _users.length > 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _users.length,
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                _searchListItem(_users[index]),
                                Divider(),
                              ],
                            );
                          })
                      : _searchEditingController.value.text != ''
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                'No user found!',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Search Users...',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  _searchListItem(User _user) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, ProfilePage.pageName,
            arguments: _user.uid);
      },
      title: Text(
        '${_user.firstName} ${_user.lastName}',
        style: TextStyle(
            fontSize: 16,
            letterSpacing: 1.01,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText2.color),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            _user.relationShipStatus == null
                ? '------'
                : '${_user.relationShipStatus}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Text(
                '${_user.bio}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 3,
              ),
            ],
          ),
        ],
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          width: 40,
          color: Colors.white70,
          child: CachedNetworkImage(
            width: kScreenWidth(context),
            fit: BoxFit.cover,
            imageUrl: '${_user.profileUrl}',
            placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
              strokeWidth: 1.0,
            )),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
