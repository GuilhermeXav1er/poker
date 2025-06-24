import 'package:flutter/material.dart';
import 'package:poker/screens/create_room_page.dart';
import 'package:poker/screens/game_page.dart';
import 'package:poker/screens/lobby_page.dart';
import '../services/room_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _roomCodeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final RoomService _roomService = RoomService();
  bool _isLoading = false;

  @override
  void dispose() {
    _roomCodeController.dispose();
    _usernameController.dispose();
    _roomService.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    if (_roomCodeController.text.trim().isEmpty) {
      print('Error: Room code cannot be empty');
      return;
    }

    if (_usernameController.text.trim().isEmpty) {
      print('Error: Username cannot be empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Joining room with code: \\${_roomCodeController.text}');
      print('Username: \\${_usernameController.text}');
      final playerName = _usernameController.text.trim();
      final response = await _roomService.joinRoomAndConnect(
        roomId: _roomCodeController.text.trim(),
        playerName: playerName,
      );

      print('Joined room successfully!');
      print('Success: \\${response.success}');
      print('Message: \\${response.message}');
      print('Player ID: \\${response.playerId}');

      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LobbyPage(
              roomCode: _roomCodeController.text.trim(),
              players: [playerName],
              playerId: response.playerId,
            ),
          ),
        );
      } else {
        print('Failed to join room: \\${response.message}');
        // You could show a snackbar or dialog here to inform the user
      }
    } catch (e) {
      print('Error joining room: $e');
      // You could show a snackbar or dialog here to inform the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF18713A), // verde de mesa de poker
      body: Stack(
        children: [
          // Imagem de fundo das cartas
          Positioned(
            left: 100,
            top: 40,
            child: Transform.rotate(
              angle: -1.2, // Rotação em radianos (aproximadamente 11.5 graus)
              child: Image.asset('assets/cards.png', width: 275),
            ),
          ),
          // Fichas à direita
          Positioned(
            right: 70,
            bottom: 40,
            child: Image.asset('assets/chips.png', width: 245),
          ),
          // Botão circular "Criar um Novo Jogo!"
          Positioned(
            bottom: 30,
            left: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(40),
                shadowColor: Colors.black,
                elevation: 20,

              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRoomPage()),
                );
              },
              child: Text(
                'Criar um\nNovo Jogo!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Container do formulário central
          Center(
            child: Container(
              width: 420,
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código da sala',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Gotham',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _roomCodeController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Digite o código da sala',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome de usuário',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Gotham',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Digite seu nome',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      fixedSize: Size(400, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _joinRoom,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Entrar!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Gotham',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 335,
            left: 420,
            child: Image.asset('assets/chips_center.png', width: 75),
          ),
        ],
      ),
    );
  }
}
