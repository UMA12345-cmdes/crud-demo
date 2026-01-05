import 'package:crud_demo/presentation/widget/toast/common_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  Future<void> signupUser({
    required String email,
    required String fullname,
    required String pass,
    required BuildContext context,
  }) async {
    if (email.isEmpty || pass.isEmpty || fullname.isEmpty) {
      CommonToast.commonToast(
        context: context,
        text: 'All fields are required',
      );
      return;
    }
    emit(SignupLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: pass.trim(),
      );
      await HydratedBloc.storage.write('isLogin', true);
      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      String message = e.message!.contains('interrupted connection')
          ? 'No internet connection. please try again'
          : 'Signup failed ${e.message}';

      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      emit(SignupFailed(error: message));
    }
  }
}
