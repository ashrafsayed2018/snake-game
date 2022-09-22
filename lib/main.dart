import 'package:flutter/material.dart';
import 'package:snake_game/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDqzfGnTInAtrjSYcs3driWt5Grs2TvUpk",
        authDomain: "snake-game-df2b7.firebaseapp.com",
        projectId: "snake-game-df2b7",
        storageBucket: "snake-game-df2b7.appspot.com",
        messagingSenderId: "421050950945",
        appId: "1:421050950945:web:ef4191e493057901b64a60"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
