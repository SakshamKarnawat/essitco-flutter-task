part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);

  @override
  List<Object> get props => [error];
}

class AuthAuthenticated extends AuthState {
  final String email;

  const AuthAuthenticated(this.email);

  @override
  List<Object> get props => [email];
}
