part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// login page events
final class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}

// signup page events
final class SignupUserEvent extends AuthEvent {
  final String email;
  final String password;

  SignupUserEvent({required this.email, required this.password});
}
