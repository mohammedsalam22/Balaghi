import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String? expiresAt;

  const AuthEntity({required this.accessToken, this.expiresAt});

  @override
  List<Object?> get props => [accessToken, expiresAt];
}
