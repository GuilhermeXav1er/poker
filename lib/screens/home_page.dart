import 'package:flutter/material.dart';
import 'package:poker/screens/create_room_page.dart';
import 'package:poker/screens/game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GamePage()),
                      );
                    },
                    child: Text(
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
