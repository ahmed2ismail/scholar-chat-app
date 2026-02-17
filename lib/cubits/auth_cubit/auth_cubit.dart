import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // login page functions
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailureState(errMessage: 'No user found for that email.'));
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
  }

  // signup page functions
  Future<void> signupUser({
    required String email,
    required String password,
  }) async {
    emit(SignupLoadingState());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignupSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          SignupFailureState(errMessage: 'The password provided is too weak.'),
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
}