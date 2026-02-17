import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginUserEvent) {
        // Handle login logic here
        emit(LoginLoadingState());
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          emit(LoginSuccessState());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(
              LoginFailureState(errMessage: 'No user found for that email.'),
            );
          } else if (e.code == 'wrong-password') {
            emit(
              LoginFailureState(
                errMessage: 'Wrong password provided for that user.',
              ),
            );
          } else {
            emit(
              LoginFailureState(
                errMessage: 'Something went wrong, please try again later.',
              ),
            );
          }
        } catch (e) {
          emit(LoginFailureState(errMessage: e.toString()));
        }
      } else if (event is SignupUserEvent) {
        // Handle signup logic here
        emit(SignupLoadingState());
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          emit(SignupSuccessState());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            emit(
              SignupFailureState(
                errMessage: 'The password provided is too weak.',
              ),
            );
          } else if (e.code == 'email-already-in-use') {
            emit(
              SignupFailureState(
                errMessage: 'The account already exists for that email.',
              ),
            );
          } else {
            emit(
              SignupFailureState(
                errMessage: 'Something went wrong, please try again later.',
              ),
            );
          }
        } catch (e) {
          emit(SignupFailureState(errMessage: e.toString()));
        }
      }
    });
  }
}