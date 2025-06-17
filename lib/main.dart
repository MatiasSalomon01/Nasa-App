import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nasa_app/home/adop/adop.dart';
import 'package:nasa_app/home/home.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ADOPProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        // home: ADOPScreen(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        routes: {"/adop": (context) => ADOPScreen()},
      ),
    );
  }
}
