import 'package:bloc/bloc.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;

  // super(AuthInitial()) = screen starts with nothing happening
  AuthCubit(this._repo) : super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading()); // tell UI: show spinner

    try {
      final user = await _repo.login(email: email, password: password);
      emit(AuthSuccess(user)); // tell UI: navigate away, here's the user

    } on AuthException catch (e) {
      emit(AuthError(e.message)); // e.message not e.toString() — no "Exception:" prefix
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await _repo.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(AuthSuccess(user));

    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }
  void rehydrate(User user) {
  emit(AuthSuccess(user)); // restore state from local storage
}

  Future<void> logout() async {
    emit(const AuthLoading());
    await _repo.logout(); // never throws — repo handles it silently
    emit(const AuthLoggedOut()); // tell UI: go to login screen
  }
}