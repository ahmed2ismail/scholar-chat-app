import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

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
}
