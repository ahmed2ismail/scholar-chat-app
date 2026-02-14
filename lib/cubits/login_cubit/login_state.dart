part of 'login_cubit.dart';

@immutable
sealed class LoginState {}
// sealed class دي معناها ان ال LoginState دي مش هتتعمل منها instance غير ال subclasses اللي جواها يعني مفيش حد يقدر يعمل instance من ال LoginState نفسها لانها abstract class بس في نفس الوقت مش abstract class عشان نقدر نعمل instance من ال subclasses اللي جواها زي ال LoginInitial
// الفرق بين ال sealed class و ال abstract class ان ال sealed class بتمنع اي حد يعمل instance منها غير ال subclasses اللي جواها اما ال abstract class ممكن اي حد يعمل instance منها بس مش هتكون مفيدة لانه مش هتحتوي علي اي implementation

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {}

final class LoginFailureState extends LoginState {
  final String errMessage;

  LoginFailureState({required this.errMessage});
}
