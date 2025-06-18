import 'package:flutter/material.dart';

class LobbyPage extends StatelessWidget {
  final String roomCode;
  final List<String> players;
  final VoidCallback? onStart;

  const LobbyPage({
    super.key,
    required this.roomCode,
    required this.players,
    this.onStart,
  });

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
                              for (int i = 0; i < players.length; i++)
                                Text(
                                  '${i + 1}. ${players[i]}',
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
                          roomCode,
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
                      onPressed: onStart,
                      child: const Text(
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