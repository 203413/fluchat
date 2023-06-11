import 'package:proyecto_c2/features/AuthUsers/Domain/repositories/firebase_repository.dart';

class IsSignInUseCase {
  final AuthFirebaseRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() async {
    return repository.isSignIn();
  }
}
