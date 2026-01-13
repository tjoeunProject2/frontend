import 'package:flutter/material.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flower App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
