import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failures.dart';
import '../../../data/models/auth_models.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository repository;

  RegisterCubit({required this.repository}) : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());

    final request = RegisterRequest(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    final result = await repository.register(request);

    result.fold((failure) {
      // Check if it's a validation failure with array of errors
      if (failure is ValidationFailure) {
        // Try to parse validation errors if they're in array format
        final errors = _parseValidationErrors(failure.message);
        emit(RegisterError(failure.message, validationErrors: errors));
      } else {
        emit(RegisterError(failure.message));
      }
    }, (response) => emit(RegisterSuccess(response.message)));
  }

  List<String>? _parseValidationErrors(String message) {
    // If message contains array-like structure, parse it
    // This is a simple implementation - adjust based on your API response format
    try {
      // Assuming validation errors might come as JSON array string
      if (message.startsWith('[') && message.endsWith(']')) {
        // This would need proper JSON parsing in real implementation
        return [message];
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }
}
