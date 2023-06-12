import 'package:proyecto_c2/features/AuthUsers/Domain/entities/user_entity.dart';

abstract class AuthFirebaseRepository {
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> googleAuth();
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<void> getUpdateUser(UserEntity user);
  Future<String> getCurrentUId();
  Stream<List<UserEntity>> getAllUsers();
}
