import 'package:flutter/material.dart';
import 'package:insomnia/insomina.dart';
import 'package:insomnia/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Insomnia());
  }
}
