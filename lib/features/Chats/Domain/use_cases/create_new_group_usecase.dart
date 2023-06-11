import 'package:proyecto_c2/features/Chats/Domain/entities/my_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/repositories/firebase_repository.dart';

class CreateNewGroupUseCase {
  final FirebaseRepository repository;

  CreateNewGroupUseCase({required this.repository});

  Future<void> call(
      MyChatEntity myChatEntity, List<String> selectUserList) async {
    return repository.createNewGroup(myChatEntity, selectUserList);
  }
}
