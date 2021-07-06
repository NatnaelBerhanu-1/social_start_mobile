import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:open_file/open_file.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/services/chat_service.dart';
import 'package:social_start/utils/utility.dart';
import 'package:uuid/uuid.dart';
import 'package:social_start/models/chat.dart' as lChat;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final lChat.Chat chat;
  final _currentUser = AuthController().getCurrentUser().uid;
  ChatPage({@required this.chat, @required this.receiverId,@required this.chatId});
  static final String pageName = "chat";
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  var _user;
  UserController _userController = UserController();

  @override
  void initState() {
    _user = types.User(id: widget._currentUser);
    chatId = widget.chatId;
    super.initState();
  }

  // void _handleAtachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         height: 144,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleImageSelection();
  //               },
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Photo'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleFileSelection();
  //               },
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('File'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );
  //
  //   if (result != null) {
  //     final message = types.FileMessage(
  //       authorId: _user.id,
  //       fileName: result.files.single.name ?? '',
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path ?? ''),
  //       size: result.files.single.size ?? 0,
  //       timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
  //       uri: result.files.single.path ?? '',
  //     );
  //
  //     _addMessage(message: message);
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().getImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );
  //
  //   if (result != null) {
  //     final bytes = await result.readAsBytes();
  //     final image = await decodeImageFromList(bytes);
  //     final imageName = result.path.split('/').last;
  //
  //     final message = types.ImageMessage(
  //       authorId: _user.id,
  //       height: image.height.toDouble(),
  //       id: const Uuid().v4(),
  //       imageName: imageName,
  //       size: bytes.length,
  //       timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
  //       uri: result.path,
  //       width: image.width.toDouble(),
  //     );
  //
  //     _addMessage(message: message);
  //   } else {
  //     // User canceled the picker
  //   }
  // }
  String chatId;

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    //TODO crate the firebase suitable document and write into the database
    final textMessage = types.TextMessage(
      authorId: _user.id,
      id: const Uuid().v4(),
      text: message.text,
      timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    );
    //TODO get the chatId from somewhere
    //TODO get the receiver id from the clicked event
    String receiverId = widget.receiverId;
    if(chatId == ""){
      var chId = await _userController.createChat(widget.chat);
      setState(() {
        chatId = chId;
      });
    }

    ChatService.sendMessage(
        message: textMessage, chatId: chatId, receiverId: receiverId);
  }

  @override
  Widget build(BuildContext context) {
    print("chatId: ${widget.chatId}");
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("messages")
              .where("chat_id", isEqualTo: chatId)
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            List<types.Message> sentMessages = [];
            if (snapshot.hasData) {
              snapshot.data.docs.forEach((doc) {
                print('Current sender_id => ${doc['sender_id']}');

                Timestamp timestamp = doc['timestamp'] as Timestamp;
                var dateTime = timestamp.toDate().millisecondsSinceEpoch / 1000;

                var message = {
                  'authorId': doc['sender_id'],
                  'text': doc['content'],
                  'timestamp': dateTime.floor(),
                  'type': 'text',
                  'status':
                      'Status.delivered', //TODO change the messages type based on the message status
                };
                sentMessages.insert(0, types.Message.fromJson(message));
              });
            }

            return snapshot.hasData
                ? Chat(
                    messages: sentMessages,
                    onMessageTap: _handleMessageTap,
                    onPreviewDataFetched: _handlePreviewDataFetched,
                    onSendPressed: _handleSendPressed,
                    user: _user,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
