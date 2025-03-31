import 'package:flutter/material.dart';
import 'package:to_do_app/controller/home_screen_controller.dart';
import 'package:to_do_app/view/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //A concrete binding for applications based on the Widgets framework.ss
  await HomeScreenController.createDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
