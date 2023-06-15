import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'footer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botik Xperience',
      theme: ThemeData.from(colorScheme: ColorScheme.dark(
        primary: Color(0xFF7289DA), // Discord mavi rengi
        background: Color(0xFF36393F), // Discord arka plan rengi
        surface: Color(0xFF2F3136), // Discord yüzey rengi
        onPrimary: Color(0xFFFFFFFF), // Beyaz metin rengi
        onBackground: Color(0xFFFFFFFF), // Beyaz metin rengi
        onSurface: Color(0xFFFFFFFF), // Beyaz metin rengi
      )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7289DA),
        title: const Text(
          'Botik Xperience',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Are you waiting for a mirror to look your beauty? If you are not, just tap footer',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
