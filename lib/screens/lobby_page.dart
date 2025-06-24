import 'package:flutter/material.dart';
import 'dart:async';
import '../services/room_service.dart';
import 'game_page.dart';

class LobbyPage extends StatefulWidget {
  final String roomCode;
  final List<String> players;
  final String? playerId; // Adicionando playerId para identificar o criador

  const LobbyPage({
    super.key,
    required this.roomCode,
    required this.players,
    this.playerId,
  });

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final RoomService _roomService = RoomService();
  bool _isLoading = false;
  late StreamSubscription _stateSubscription;
  List<String> _playerNames = [];

  @override
  void initState() {
    super.initState();

    // Connect to WebSocket when entering the lobby
    if (widget.playerId != null) {
      _roomService.connectToWebSocket(widget.roomCode, widget.playerId!);
    }

    // Listen to state changes
    _stateSubscription = _roomService.stateStream.listen((state) {
      if (state.containsKey('players')) {
        final playersRaw = state['players'];
        List<String> nomes = [];
        if (playersRaw is List) {
          for (var p in playersRaw) {
            if (p is String) {
              nomes.add(p);
            } else if (p is Map && p['name'] != null) {
              nomes.add(p['name'].toString());
            }
          }
        }
        setState(() {
          _playerNames = nomes;
        });
      }
    });
  }

  @override
  void dispose() {
    // Disconnect from WebSocket and cancel subscription when leaving the lobby
    _stateSubscription.cancel();
    _roomService.disconnectWebSocket();
    _roomService.dispose();
    super.dispose();
  }

  Future<void> _startGame() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting game in room: ${widget.roomCode}');
      
      await _roomService.startGame(widget.roomCode);

      print('Game started successfully!');
      
      // Navegar para a página do jogo
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => GamePage(
            roomId: widget.roomCode,
            playerId: widget.playerId ?? '', //TODO: não sei se precisa desse playerId mesmo, pq não sao todos usuarios que iniciam o jogo
          ),
        ),
      );
      
    } catch (e) {
      print('Error starting game: $e');
      // Mostrar erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao iniciar o jogo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18713A), // verde de mesa de poker
      body: Stack(
        children: [
          // Seta para voltar
          Positioned(
            left: 20,
            top: 40,
            child: Transform.rotate(
              angle: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 50),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Imagem de fundo das cartas
          Positioned(
            left: 100,
            top: 40,
            child: Transform.rotate(
              angle: -1.2,
              child: Image.asset('assets/cards.png', width: 180),
            ),
          ),
          // Fichas à direita
          Positioned(
            right: 70,
            bottom: 40,
            child: Image.asset('assets/chips.png', width: 110),
          ),
          // Ficha central sobre o card
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 210,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Image.asset('assets/chips_center.png', width: 100),
          ),
          // Card central
          Center(
            child: Container(
              width: 420,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jogadores na sala',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Gotham',
                        ),
                      ),
                      const Text(
                        'Código da sala',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Gotham',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lista de jogadores
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < _playerNames.length; i++)
                                Text(
                                  '${i + 1}. ${_playerNames[i]}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Gotham',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Código da sala
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                        child: Text(
                          widget.roomCode,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _startGame,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Iniciar!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Gotham',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}