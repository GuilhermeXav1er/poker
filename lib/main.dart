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

//To enter in the lobbypage, need to pass the params.
/* runApp(MaterialApp(
    home: LobbyPage(roomCode: '123456', players: ['Enzo', 'Gabriel', 'Bruno', 'Rafael', 'Guilherme'], onStart: () {}),
  )); */