import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/auth_models.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final request = LoginRequest(
      email: email,
      password: password,
    );

    final result = await repository.login(request);

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (authEntity) => emit(LoginSuccess(authEntity)),
    );
  }
}

