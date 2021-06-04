import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_start/services/user_service.dart';
import 'package:social_start/utils/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchEditingController =
      TextEditingController();
  final _userService = UserService();
  var _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            elevation: 1,
            shadowColor: Colors.grey.withOpacity(0.4),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
                Expanded(
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                    ),
                    child: TextField(
                      controller: _searchEditingController,
                      onChanged: (value) async {
                        if (value.trim() == '') {
                          setState(() {
                            _users = [];
                            return;
                          });
                        } else {
                          var searchResult =
                              await _userService.searchUser(value: value);
                          setState(() {
                            _users = [...searchResult.docs];
                          });
                        }
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.close,
                            size: 20,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                          hintText: 'Search...',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: _users.length > 0
                  ? ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              title: Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1.01,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Divorced',
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
                                        '1000 Followers',
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
                                    imageUrl:
                                        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                    )),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      })
                  : _searchEditingController.value.text != ''
                      ? Center(
                          child: Text(
                          'No user found!',
                          style: TextStyle(color: Colors.grey),
                        ))
                      : Center(
                          child: Text(
                            'Search Users...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
            ),
          ),
        ],
      )),
    );
  }
}
