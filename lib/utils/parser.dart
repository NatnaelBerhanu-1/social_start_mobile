import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class BaseParser {
  static Map<String, dynamic> messageToJson(Message message) {
    // this.authorId,
    // this.id,
    // this.metadata,
    // this.status,
    // this.timestamp,
    // this.type,
    return {
      'authorId': message.message.authorId,
      'id': message.message.id,
      'metadata': message.message.metadata,
      'status': message.message.status,
      'timestamp': message.message.timestamp,
      'type': message.message.type
    };
  }
}
