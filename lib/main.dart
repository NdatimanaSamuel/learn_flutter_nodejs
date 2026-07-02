import 'package:flutter/material.dart';
import 'package:learn_flutter_nodejs/pages/add_user.dart';
import 'package:learn_flutter_nodejs/pages/edit_user.dart';
import 'package:learn_flutter_nodejs/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyHomePage(),
        '/add-user':(context)=>AddUserPage(),
    
      },
    );
  }
}
