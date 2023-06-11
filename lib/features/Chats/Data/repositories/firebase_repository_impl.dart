import 'package:proyecto_c2/features/AuthUsers/Domain/entities/engage_user_entity.dart';
import 'package:proyecto_c2/features/Chats/Data/remote/firebase_remote_data_source.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/group_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/my_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/text_messsage_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});
  @override
  Future<String> getCurrentUId() async =>
      await remoteDataSource.getCurrentUId();

  // @override
  // Future<String> createOneToOneChatChannel(
  //         EngageUserEntity engageUserEntity) async =>
  //     remoteDataSource.createOneToOneChatChannel(engageUserEntity);

  @override
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    return await remoteDataSource.sendTextMessage(textMessageEntity, channelId);
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    return remoteDataSource.getMessages(channelId);
  }

  @override
  Future<String> getChannelId(EngageUserEntity engageUserEntity) async {
    return remoteDataSource.getChannelId(engageUserEntity);
  }

  // @override
  // Future<void> addToMyChat(MyChatEntity myChatEntity) async {
  //   return await remoteDataSource.addToMyChat(myChatEntity);
  // }

  // @override
  // Stream<List<MyChatEntity>> getMyChat(String uid) {
  //   return remoteDataSource.getMyChat(uid);
  // }

  @override
  Future<void> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectUserList) {
    return remoteDataSource.createNewGroup(myChatEntity, selectUserList);
  }

  @override
  Future<void> getCreateNewGroupChatRoom(
      MyChatEntity myChatEntity, List<String> selectUserList) {
    return remoteDataSource.createNewGroup(myChatEntity, selectUserList);
  }

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async =>
      remoteDataSource.getCreateGroup(groupEntity);

  @override
  Stream<List<GroupEntity>> getGroups() => remoteDataSource.getGroups();

  @override
  Future<void> joinGroup(GroupEntity groupEntity) async =>
      remoteDataSource.joinGroup(groupEntity);

  @override
  Future<void> updateGroup(GroupEntity groupEntity) async =>
      remoteDataSource.updateGroup(groupEntity);
}
