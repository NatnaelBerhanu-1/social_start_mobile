import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class BaseParser {
  static Map<String, dynamic> messageToJson(types.Message message) {
    // 'authorId': authorId,
    // 'id': id,
    // 'metadata': metadata,
    // 'status': status,
    // 'text': text,
    // 'timestamp': timestamp,
    // 'type': 'text',
    return message.toJson();
  }

  static types.Message messageFromSnapshot(Map<String, dynamic> json) {
    return types.Message.fromJson(json);
  }
}
