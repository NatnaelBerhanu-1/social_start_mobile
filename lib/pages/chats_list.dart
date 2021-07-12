import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_start/controllers/auth_controller.dart';
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
          CustomAppBar(showBackArrow: false, title: "Chats"),
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
                              'sender': false,
                              'chat_id': doc.id,
                            });
                          });

                          print('Combined $combinedChats');

                          if(combinedChats.isEmpty){
                            return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset("assets/images/no_message.png", height: 150,),
                                Text("No chats\nstart chatting by following others.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black38),),
                              ],
                            ));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                              itemCount: combinedChats.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.all(5),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.withOpacity(0.3),
                                    radius: 40,
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.black.withOpacity(0.5),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    combinedChats[index]['user1_name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Some Text sent!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  onTap: () {
                                    print(
                                        'sender => ${combinedChats[index]['sender']}');
                                    print(
                                        'chat id => ${combinedChats[index]['chat_id']}');
                                    var receiverId = combinedChats[index]['sender']
                                        ? combinedChats[index]['user2_id']
                                        : combinedChats[index]['user2_id'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => ChatPage(
                                                  chatId: combinedChats[index]
                                                      ['chat_id'],
                                                  receiverId: receiverId,
                                                )));
                                  },
                                );
                              });
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: SpinKitFadingCircle(
                              color: kPrimaryColor,
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
