import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import '../model/provider_model.dart';
import '../screens/login_page.dart';
import '../screens/loading_Page.dart';
import '../screens/register_page.dart';
import '../model/auth_model.dart';
import '../screens/screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Shopping app',
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'spoqa',
        ),
        routes: {
          '/loading': (context) => LoadingPage(),
          '/index': (context) => screenPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
        },
        initialRoute: '/loading',
      )
    );
  }
}