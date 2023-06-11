import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/like_model.dart';
import 'package:shopping_app/model/my_provider_model.dart';
import 'firebase_options.dart';
import '../model/provider_model.dart';
import '../model/auth_model.dart';
import '../model/query_model.dart';
import '../screens/loading_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => QueryProvider()),
        ChangeNotifierProvider(create: (_) => LikeProvider()),
        ChangeNotifierProvider(create: (_) => MyItemProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Shopping app',
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'spoqa',
        ),
        home: LoadingPage(),
      )
    );
  }
}