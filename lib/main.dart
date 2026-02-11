
import 'package:apocrypha_uploader/main_page.dart';
import 'package:flutter/material.dart';
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage()
    );
  }
}

void main() {
  runApp(const MainApp());
}