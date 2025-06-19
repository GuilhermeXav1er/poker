import 'package:flutter/material.dart';
import '../services/room_service.dart';
import 'lobby_page.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _creatorNameController = TextEditingController();
  final TextEditingController _maxPlayersController = TextEditingController();
  final RoomService _roomService = RoomService();
  bool _isLoading = false;

  @override
  void dispose() {
    _creatorNameController.dispose();
    _maxPlayersController.dispose();
    _roomService.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (_creatorNameController.text.trim().isEmpty) {
      print('Error: Creator name cannot be empty');
      return;
    }

    int maxPlayers = 6; // Default to 6 players
    if (_maxPlayersController.text.trim().isNotEmpty) {
      try {
        maxPlayers = int.parse(_maxPlayersController.text.trim());
        if (maxPlayers < 2 || maxPlayers > 10) {
          print('Error: Max players must be between 2 and 10');
          return;
        }
      } catch (e) {
        print('Error: Max players must be a valid number');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Creating room with creator: ${_creatorNameController.text}');
      
      final playerName = _creatorNameController.text.trim();
      final response = await _roomService.createRoom(
        creatorName: playerName,
        maxPlayers: maxPlayers,
      );

      print('Room created successfully!');
      print('Room ID: ${response.roomId}');
      print('Player ID: ${response.playerId}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => LobbyPage(
        roomCode: response.roomId, 
        players: [playerName], 
        playerId: response.playerId,
      )));

      // Get WebSocket URL for real-time communication
      final wsUrl = _roomService.getWebSocketUrl(response.roomId);
      print('WebSocket URL: $wsUrl');
      
    } catch (e) {
      print('Error creating room: $e');
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
          // Seta para voltar
          Positioned(
            left: 20,
            top: 40,
            child: Transform.rotate(
              angle: 0, // Rotação em radianos (aproximadamente 11.5 graus)
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 50),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
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
                          'Nome do criador',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Gotham',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _creatorNameController,
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
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantidade máxima de jogadores',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Gotham',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _maxPlayersController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: '2-10 (padrão: 6)',
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
                    onPressed: _isLoading ? null : _createRoom,
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
                            'Criar!',
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
