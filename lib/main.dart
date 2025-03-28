import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'notes_screan.dart';
import 'package:notes_app/sql_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlHelper.getDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : NotesScrean() ,
    );
  }
}
