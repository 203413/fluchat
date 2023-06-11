import 'package:proyecto_c2/features/AuthUsers/Domain/repositories/firebase_repository.dart';

class SignOutUseCase {
  final AuthFirebaseRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async {
    return repository.signOut();
  }
}
