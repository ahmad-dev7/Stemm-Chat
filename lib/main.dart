import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/controllers/auth_controller.dart';
import 'package:stemm_chat/controllers/chat_controller.dart';
import 'package:stemm_chat/theme/theme_info.dart';
import 'package:stemm_chat/views/auth_view.dart';
import 'package:stemm_chat/views/create_profile_view.dart';
import 'package:stemm_chat/views/users_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  authController = Get.put(AuthController());
  chatController = Get.put(ChatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeInfo().themeData,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          if (snapshot.data!.displayName == null ||
              snapshot.data!.photoURL == null) {
            Get.snackbar(
              'Complete profile',
              "Please complete your profile to continue",
            );
            return CreateProfileView();
          }
          return const UsersView();
        } else {
          return AuthView();
        }
      },
    );
  }
}
