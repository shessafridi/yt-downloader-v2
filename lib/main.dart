import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yt_downloader_v2/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          cardTheme: const CardTheme(elevation: 0.0),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          }),
          textTheme:
              GoogleFonts.rubikTextTheme().apply(bodyColor: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
