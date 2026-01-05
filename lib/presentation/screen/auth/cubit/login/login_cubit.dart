import 'package:crud_demo/presentation/widget/toast/common_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    if (email.isEmpty || pass.isEmpty) {
      CommonToast.commonToast(
        context: context,
        text: 'All fields are required',
      );
      return;
    }
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: pass.trim(),
      );
      await HydratedBloc.storage.write('isLogin', true);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      String message = e.message!.contains('interrupted connection')
          ? 'No internet connection. please try again'
          : 'Login failed ${e.message}';
      if (e.code == 'user-not-found') {
        message = 'No user found for this email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      emit(LoginFailed(error: message));
    }
  }
}
