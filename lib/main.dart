import 'package:flutter/material.dart';
import 'package:hello_wold_app/src/screens/net/net_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      // home: const CounterScreen()
      home: const CounterFuntionsScreen()
    );
  }
  
}
