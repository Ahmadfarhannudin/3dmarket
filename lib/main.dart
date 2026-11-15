import 'package:flutter/material.dart';
import 'package:_3dmarket/app/theme.dart';
import 'package:_3dmarket/app/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3DMARKET',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.onboarding,
      onGenerateRoute: AppRouter.onGenerate,
    );
  }
}
