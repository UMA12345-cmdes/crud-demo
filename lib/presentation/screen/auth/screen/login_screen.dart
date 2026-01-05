import 'package:crud_demo/core/constant/app_color.dart';
import 'package:crud_demo/presentation/screen/auth/cubit/login/login_cubit.dart';
import 'package:crud_demo/presentation/screen/auth/screen/signup_screen.dart';
import 'package:crud_demo/presentation/screen/home/screen/home_screen.dart';
import 'package:crud_demo/presentation/widget/button/common_button.dart';
import 'package:crud_demo/presentation/widget/textfield/textfield.dart';
import 'package:crud_demo/presentation/widget/toast/common_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obsure = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              Center(child: CircularProgressIndicator());
            }
            if (state is LoginFailed) {
              CommonToast.commonToast(context: context, text: state.error);
            }
            if (state is LoginSuccess) {
              HydratedBloc.storage.write('isLogin', true);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            }
          },
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
                        controller: email,
                        hintText: 'Please enter email address...',
                        prefixIcon: Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      CommonTextField(
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
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              signupLable(),
              SizedBox(height: 20),
              CommonButton(
                text: 'Submit',
                onPressed: () async {
                  await context.read<LoginCubit>().loginUser(
                    email: email.text.trim(),
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

  signupLable() {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(color: Colors.black, fontSize: 14),
        children: [
          TextSpan(
            text: "SignUp",
            style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
          ),
        ],
      ),
    );
  }
}
