import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/services/base_service.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/custom_appbar.dart';

class ChatList extends StatelessWidget {
  final _currentUser = AuthController().getCurrentUser().uid;
  final fireStore = BaseService().fireStore;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // CustomAppBar(showBackArrow: false, title: "Chats"),
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .where("user1_id", isEqualTo: _currentUser)
                    .snapshots(),
                builder: (context, asFirstUser) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chats")
                          .where("user2_id", isEqualTo: _currentUser)
                          .snapshots(),
                      builder: (context, asSecondUser) {
                        var combinedChats = [];
                        if (asFirstUser.hasData && asSecondUser.hasData) {
                          print('As first user => ');
                          asFirstUser.data.docs.forEach((doc) {
                            combinedChats.add({
                              'user1_id': doc['user1_id'],
                              'user2_id': doc['user2_id'],
                              'user1_name': doc['user1_name'],
                              'user2_name': doc['user2_name'],
                              'user1_profile_url': doc['user1_profile_url'],
                              'user2_profile_url': doc['user2_profile_url'],
                              'last_message': doc['last_message'],
                              'last_message_by': doc['last_message_by'],
                              'sender': true,
                              'chat_id': doc.id,
                            });
                            print('ID => ' + doc.id);
                          });

                          print('As second user => ');
                          asSecondUser.data.docs.forEach((doc) {
                            combinedChats.add({
                              'user1_id': doc['user1_id'],
                              'user2_id': doc['user2_id'],
                              'user1_name': doc['user1_name'],
                              'user2_name': doc['user2_name'],
                              'user1_profile_url': doc['user1_profile_url'],
                              'user2_profile_url': doc['user2_profile_url'],
                              'last_message': doc['last_message'],
                              'last_message_by': doc['last_message_by'],
                              'sender': false,
                              'chat_id': doc.id,
                            });
                          });

                          print('Combined $combinedChats');

                          if (combinedChats.isEmpty) {
                            return Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Image.asset("assets/images/no_message.png", height: 150,),
                                Text(
                                  "No chats\nstart chatting by following others.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ));
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: combinedChats.length,
                              itemBuilder: (context, index) {
                                print(combinedChats[index].toString());
                                return ListTile(
                                  contentPadding: EdgeInsets.all(5),
                                  leading: Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: CachedNetworkImage(
                                          imageUrl: _currentUser != combinedChats[index]['user1_id'] ? combinedChats[index]
                                              ['user1_profile_url'] : combinedChats[index]
                                          ['user2_profile_url'],
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  title: Text(
                                    _currentUser != combinedChats[index]['user1_id'] ? combinedChats[index]
                                    ['user1_name'] : combinedChats[index]
                                    ['user2_name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                      color: Theme.of(context).textTheme.bodyText2.color
                                    ),
                                  ),
                                  subtitle: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        combinedChats[index]['last_message_by'] !=
                                                null
                                            ? combinedChats[index]
                                                ['last_message_by'] == _currentUser ? "You: "
                                            : "":"",
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1.1,
                                          color: kAccentColor
                                        ),
                                      ),
                                      Text(
                                        combinedChats[index]['last_message'] !=
                                                ""
                                            ? combinedChats[index]
                                                ['last_message']
                                            : "No messages yet",
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1.1,
                                            color: Theme.of(context).textTheme.bodyText2.color
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(
                                        'sender => ${combinedChats[index]['sender']}');
                                    print(
                                        'chat id => ${combinedChats[index]['chat_id']}');
                                    var receiverId = _currentUser == combinedChats[index]['user1_id'] ? combinedChats[index]['user2_id']:combinedChats[index]['user1_id'];
                                    print(receiverId);
                                    print(_currentUser);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => ChatPage(
                                                  chatId: combinedChats[index]
                                                      ['chat_id'],
                                                  receiverId: receiverId,
                                              chat: Chat.fromJson({
                                                'user1_id': combinedChats[index]['user1_id'],
                                                'user2_id': combinedChats[index]['user2_id'],
                                                'user1_name': combinedChats[index]['user1_name'],
                                                'user2_name': combinedChats[index]['user2_name'],
                                                'user1_profile_url': combinedChats[index]['user1_profile_url'],
                                                'user2_profile_url': combinedChats[index]['user2_profile_url'],
                                                'last_message': combinedChats[index]['last_message'],
                                                'last_message_by': combinedChats[index]['last_message_by'],
                                              }),
                                                )));
                                  },
                                );
                              });
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                              child: SpinKitFadingCircle(
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          )),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
