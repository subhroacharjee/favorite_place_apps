import 'package:favorite_place_apps/src/screens/place_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  background: const Color.fromARGB(225, 56, 49, 66),
);

final theme = ThemeData(useMaterial3: true).copyWith(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme()
      .copyWith(
        titleSmall: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.w400,
        ),
      )
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const PlaceListScreen(),
    );
  }
}
