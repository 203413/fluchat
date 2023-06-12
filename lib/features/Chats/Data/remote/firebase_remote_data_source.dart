import 'package:proyecto_c2/features/AuthUsers/Domain/entities/engage_user_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/group_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/my_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/text_messsage_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<void> getCreateGroup(GroupEntity groupEntity);
  Future<void> joinGroup(GroupEntity groupEntity);
  Future<void> updateGroup(GroupEntity groupEntity);
  Stream<List<GroupEntity>> getGroups();

  Future<String> getCurrentUId();

  // Future<String> createOneToOneChatChannel(EngageUserEntity engageUserEntity);

  // Future<String> getChannelId(EngageUserEntity engageUserEntity);

  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId);

  Stream<List<TextMessageEntity>> getMessages(String channelId);

  // Future<void> addToMyChat(MyChatEntity myChatEntity);

  Future<void> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectUserList);

  // Stream<List<MyChatEntity>> getMyChat(String uid);
}
