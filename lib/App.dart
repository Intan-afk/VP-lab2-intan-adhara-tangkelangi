import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/login_page.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      debugShowCheckedModeBanner: true,
      // Dimatikan agar tampilan sama dengan screenshot codelab
      theme: ThemeData(useMaterial3: false),
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => const HomePage(),
      },
    );
  }
}