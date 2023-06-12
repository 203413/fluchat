import 'package:proyecto_c2/features/Chats/Domain/entities/group_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/my_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/text_messsage_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<void> getCreateGroup(GroupEntity groupEntity);
  Future<void> joinGroup(GroupEntity groupEntity);
  Future<void> updateGroup(GroupEntity groupEntity);
  Stream<List<GroupEntity>> getGroups();

  Future<String> getCurrentUId();

  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId);

  Stream<List<TextMessageEntity>> getMessages(String channelId);
}
