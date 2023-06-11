import 'package:proyecto_c2/features/AuthUsers/Domain/entities/engage_user_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/repositories/firebase_repository.dart';

class GetChannelIdUseCase {
  final FirebaseRepository repository;

  GetChannelIdUseCase({required this.repository});

  Future<String> call(EngageUserEntity engageUserEntity) async {
    return repository.getChannelId(engageUserEntity);
  }
}
 // TODO