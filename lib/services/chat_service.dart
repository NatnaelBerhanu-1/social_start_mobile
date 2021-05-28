import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:social_start/utils/parser.dart';

import 'base_service.dart';

class ChatService extends BaseService {
  Stream<QuerySnapshot> getMessages({String authorId, String receiverId}) {
    //I make it stream to listen to the changes all the time
    //to get specific message between two users, we will use their unique ids
    Stream<QuerySnapshot> snapshot = fireStore
        .collection("messages")
        .where('authorId', isEqualTo: authorId)
        .where('receiverId', isEqualTo: receiverId)
        .snapshots();
    return snapshot;
  }

  Future<void> sendMessage(Message message) async {
    //Assuming there is a document called messages that contains all the messages
    return fireStore
        .collection("messages")
        .doc(message.message.id)
        .set(BaseParser.messageToJson(message));
  }

  Future<String> sendFile({File file}) async {
    String fileDirectory = '';
    //TODO add file directory for later use
    String fileName = DateTime.now().toString();
    TaskSnapshot uploadedFile = await firebaseStorage
        .ref("$fileDirectory/$fileName${file.toString().split('/').last}")
        .putFile(file);

    return await uploadedFile.ref.getDownloadURL();
  }
}
