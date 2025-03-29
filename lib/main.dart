import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'notes_screan.dart';
import 'package:notes_app/sql_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails){
  //   return MaterialApp(
  //     debugShowCheckedModeBanner : false ,
  //     home :Scaffold(
  //       backgroundColor: Colors.black,
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.error_outline_outlined,color: Colors.red,size: 180,),
  //             SizedBox(height : 20.h),
  //             Text(
  //               KReleaseMode?
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // };
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
