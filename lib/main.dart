import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker/screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
