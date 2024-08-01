import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'pages/home_page.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  // open a box
  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      initial: AdaptiveThemeMode.system, // This will follow the system theme
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
