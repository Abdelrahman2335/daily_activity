import 'package:daily_activity/app/core/constants/app_colors.dart';
import 'package:daily_activity/app/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TODO App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: GoogleFonts.poppins().fontFamily,
        useMaterial3: true,

      ),
      home: WelcomePage(),
    );
  }
}


