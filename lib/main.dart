import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  void _onInitializationComplete() {
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 63, 17, 177)),
        useMaterial3: true,
      ),
      home: AnimatedSwitcher(
        duration: const Duration(seconds: 2),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _isInitialized
            ? StreamBuilder(
                key: const ValueKey('AuthChecker'),
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return SplashScreen(onInitializationComplete: () {});
                  // }
                  if (snapshot.hasData) {
                    return const ChatScreen();
                  } else {
                    return const AuthScreen();
                  }
                },
              )
            : SplashScreen(
                key: const ValueKey('SplashScreen'),
                onInitializationComplete: _onInitializationComplete,
              ),
      ),
    );
  }
}
