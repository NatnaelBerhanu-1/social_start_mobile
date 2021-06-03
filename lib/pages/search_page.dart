import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_start/utils/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchEditingController =
      TextEditingController();
  var _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: TextField(
              controller: _searchEditingController,
              onChanged: (value) async {
                if (value.trim() == '') {
                  setState(() {
                    _users = [];
                    return;
                  });
                } else {
                  var searchResult = await FirebaseFirestore.instance
                      .collection('users')
                      .where('first_name', isGreaterThanOrEqualTo: value)
                      .where('first_name', isLessThan: value + 'z')
                      .get();
                  setState(() {
                    _users = [...searchResult.docs];
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: 'Search...',
                  enabledBorder: _inputBorderStyle(),
                  border: _inputBorderStyle(),
                  focusedBorder: _inputBorderStyle()),
            ),
          ),
          Expanded(
            child: Container(
              child: _users.length > 0
                  ? ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Divorced',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.white70,
                              child: CachedNetworkImage(
                                width: kScreenWidth(context),
                                fit: BoxFit.contain,
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/hotelslisting.appspot.com/o/user_profiles%2Fc80c94f1-c5c2-4e58-acf0-2d661fd23e74.jpg?alt=media&token=cf627b71-ab3c-4934-9cda-866794a9183c',
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
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

_inputBorderStyle() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0),
      borderRadius: BorderRadius.circular(5));
}
