import 'package:proyecto_c2/features/AuthUsers/Domain/repositories/firebase_repository.dart';

class GoogleSignInUseCase {
  final AuthFirebaseRepository repository;

  GoogleSignInUseCase({required this.repository});

  Future<void> call() {
    return repository.googleAuth();
  }
}
