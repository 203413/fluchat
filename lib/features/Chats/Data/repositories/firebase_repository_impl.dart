import 'package:proyecto_c2/features/Chats/Data/datasources/firebase_remote_data_source.dart';
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
