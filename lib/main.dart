import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_demo/core/constant/app_color.dart';
import 'package:crud_demo/firebase_option.dart';
import 'package:crud_demo/presentation/screen/auth/cubit/login/login_cubit.dart';
import 'package:crud_demo/presentation/screen/auth/cubit/signup/signup_cubit.dart';
import 'package:crud_demo/presentation/screen/auth/screen/login_screen.dart';
import 'package:crud_demo/presentation/screen/home/cubit/home/home_cubit.dart';
import 'package:crud_demo/presentation/screen/home/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<SignupCubit>(create: (context) => SignupCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          focusColor: primaryColor,
          dividerColor: primaryColor,
          cardColor: whiteColor,
          primaryColor: primaryColor,
          appBarTheme: AppBarTheme(backgroundColor: primaryColor),
          colorScheme: ColorScheme.fromSeed(seedColor: whiteColor),
        ),
        home: HydratedBloc.storage.read('isLogin') == true
            ? HomeScreen()
            : LoginScreen(),
      ),
    );
  }
}
