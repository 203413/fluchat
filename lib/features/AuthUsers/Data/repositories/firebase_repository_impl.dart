import 'package:proyecto_c2/features/AuthUsers/Data/remote/firebase_remote_data_source.dart';
import 'package:proyecto_c2/features/AuthUsers/Domain/entities/user_entity.dart';
import 'package:proyecto_c2/features/AuthUsers/Domain/repositories/firebase_repository.dart';

class AuthFirebaseRepositoryImpl implements AuthFirebaseRepository {
  final AuthFirebaseRemoteDataSource remoteDataSource;

  AuthFirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      await remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUId() async =>
      await remoteDataSource.getCurrentUId();

  @override
  Future<bool> isSignIn() async => await remoteDataSource.isSignIn();

  // @override
  // Future<void> signInWithPhoneNumber(String pinCode) async =>
  //     await remoteDataSource.signInWithPhoneNumber(pinCode);

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();

  // @override
  // Future<void> verifyPhoneNumber(String phoneNumber) async {
  //   await remoteDataSource.verifyPhoneNumber(phoneNumber);
  // }

  @override
  Stream<List<UserEntity>> getAllUsers() => remoteDataSource.getAllUsers();

  @override
  Future<void> googleAuth() async => remoteDataSource.googleAuth();

  // @override
  // Future<void> forgotPassword(String email) async =>
  //     remoteDataSource.forgotPassword(email);

  @override
  Future<void> signIn(UserEntity user) async => remoteDataSource.signIn(user);

  @override
  Future<void> signUp(UserEntity user) async => remoteDataSource.signUp(user);

  @override
  Future<void> getUpdateUser(UserEntity user) async =>
      remoteDataSource.getUpdateUser(user);
}
