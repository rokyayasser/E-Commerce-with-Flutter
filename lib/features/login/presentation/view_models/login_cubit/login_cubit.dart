import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'login_state.dart';



class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      var auth = FirebaseAuth.instance;
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'User Not Found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'Wrong password'));
      } else {
        emit(LoginFailure(errMessage: e.message ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Something went wrong'));
    }
  }

  bool obsecureText = true;

  void changeObsecureText() {
    obsecureText = !obsecureText;
    emit(ChangeSecureText());
  }
}