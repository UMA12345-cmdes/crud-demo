import 'package:crud_demo/core/constant/app_color.dart';
import 'package:crud_demo/presentation/screen/auth/cubit/signup/signup_cubit.dart';
import 'package:crud_demo/presentation/screen/auth/screen/login_screen.dart';
import 'package:crud_demo/presentation/screen/home/screen/home_screen.dart';
import 'package:crud_demo/presentation/widget/button/common_button.dart';
import 'package:crud_demo/presentation/widget/textfield/textfield.dart';
import 'package:crud_demo/presentation/widget/toast/common_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController name = TextEditingController();
  bool obsure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Sign Up')),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupLoading) {
            Center(child: CircularProgressIndicator());
          }
          if (state is SignupFailed) {
            CommonToast.commonToast(context: context, text: state.error);
          }
          if (state is SignupSuccess) {
            HydratedBloc.storage.write('isLogin', true);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [
              Card(
                color: whiteColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 30,
                  ),
                  child: Column(
                    spacing: 25,
                    children: [
                      CommonTextField(
                        controller: name,
                        hintText: 'Please enter name...',
                        prefixIcon: Icon(Icons.person),
                        keyboardType: TextInputType.name,
                      ),
                      CommonTextField(
                        controller: email,
                        hintText: 'Please enter email address...',
                        prefixIcon: Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      passwordWidget(),
                    ],
                  ),
                ),
              ),
              Spacer(),
              loginLable(),
              SizedBox(height: 20),
              CommonButton(
                text: 'Submit',
                onPressed: () async {
                  await context.read<SignupCubit>().signupUser(
                    email: email.text.trim(),
                    fullname: name.text.trim(),
                    pass: pass.text.trim(),
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordWidget() {
    return CommonTextField(
      controller: pass,
      hintText: 'Please enter password...',
      prefixIcon: Icon(Icons.lock),
      keyboardType: TextInputType.visiblePassword,

      obscureText: !obsure,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            obsure = !obsure;
          });
        },
        child: Visibility(
          visible: obsure == false,
          replacement: Icon(Icons.visibility),
          child: Icon(Icons.visibility_off),
        ),
      ),
    );
  }

  loginLable() {
    return RichText(
      text: TextSpan(
        text: "Account already register? ",
        style: TextStyle(color: Colors.black, fontSize: 14),
        children: [
          TextSpan(
            text: "Login",
            style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
          ),
        ],
      ),
    );
  }
}
