import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF18713A), // verde de mesa de poker
      body: Stack(
        children: [
          // Mesa de poker oval central
          Center(
            child: Container(
              width: 750,
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    Color(0xFFB85450), // vermelho escuro no centro
                    Color(0xFF8B4513), // marrom nas bordas
                  ],
                ),
                borderRadius: BorderRadius.circular(200),
                border: Border.all(color: Color(0xFF654321), width: 8),
              ),
            ),
          ),
          
          // Informações do pote atual (topo esquerdo)
          Positioned(
            top: 10,
            left: 120,
            child: Column(
              children: [
                Text(
                  'Pote atual',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$ 600',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Informações do seu pote (topo direito)
          Positioned(
            top: 10,
            right: 120,
            child: Column(
              children: [
                Text(
                  'Seu pote',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$ 450',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Jogador Xavier (topo esquerdo da mesa)
          Positioned(
            top: 80,
            left: 80,
            child: _buildPlayer('Xavier', '\$ 500'),
          ),
          
          // Cartas do Xavier
          Positioned(
            top: 70,
            left: 200,
            child: Row(
              children: [
                _buildCard(isBack: true),
                SizedBox(width: 5),
                _buildCard(isBack: true),
              ],
            ),
          ),
          
          // Aposta do Xavier
          Positioned(
            top: 150,
            left: 220,
            child: _buildBet('\$ 10'),
          ),
          
          // Botão dealer (perto do Xavier)
         /*  Positioned(
            top: 260,
            left: 280,
            child: _buildDealerButton(),
          ),
           */
          // Jogador Enzo (topo direito da mesa)
          Positioned(
            top: 80,
            right: 80,
            child: _buildPlayer('Enzo', '\$ 350'),
          ),
          
          // Cartas do Enzo
          Positioned(
            top: 70,
            right: 150,
            child: Row(
              children: [
                _buildCard(isBack: true),
                SizedBox(width: 5),
                _buildCard(isBack: true),
              ],
            ),
          ),
          
          // Jogador Romanhole (esquerda da mesa)
          Positioned(
            left: 20,
            top: 180,
            child: _buildPlayer('Roman', '\$ 500'),
          ),
          
          // Cartas do Romanhole (chip)
          Positioned(
            left: 120,
            top: 160,
            child: Column(
              children: [
                _buildCard(isBack: true, isChip: true),
                _buildCard(isBack: true, isChip: true),
              ],
            ),
          ),
          
          // Aposta do Romanhole
          Positioned(
            left: 185,
            top: 180,
            child: _buildBet('\$ 5'),
          ),
          
          // Jogador Bruno (direita da mesa)
          Positioned(
            right: 20,
            top: 180,
            child: _buildPlayer('Bruno', '\$ 150'),
          ),
          
          // Cartas do Bruno (chip)
          Positioned(
            right: 120,
            top: 160,
            child: Column(
              children: [
                _buildCard(isBack: true, isChip: true),
                _buildCard(isBack: true, isChip: true),
              ],
            ),
          ),
          
          // Cartas comunitárias (centro da mesa)
          Positioned(
            top: 160,
            left: 320,
            child: Row(
              children: [
                _buildCard(isBack: true),
                SizedBox(width: 8),
                _buildCard(isBack: true),
                SizedBox(width: 8),
                _buildCard(isBack: true),
                SizedBox(width: 8),
                _buildCard(isBack: true),
                SizedBox(width: 8),
                _buildCard(isBack: true),
              ],
            ),
          ),
          
          // Botão BTN (centro da mesa)
          Positioned(
            top: 260,
            left: 310,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'BTN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Suas cartas (parte inferior)
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Row(
              children: [
                _buildCard(suit: '♠', value: 'J', color: Colors.black, isMyCard: true),
                SizedBox(width: 10),
                _buildCard(suit: '♦', value: 'A', color: Colors.red, isMyCard: true),
              ],
            ),
          ),
          
          // Botões de ação (parte inferior)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Grupo de botões da esquerda
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildActionButton('Desistir'),
                    _buildActionButton('Passar'),
                    _buildActionButton('Apostar'),
                  ],
                  
                ),
                Spacer(),
                // Grupo de botões da direita
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton('Pagar'),
                    _buildActionButton('Aumentar'),
                    _buildActionButton('All-In'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlayer(String name, String money) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          money,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Gotham',
          ),
        ),
      ],
    );
  }
  
  Widget _buildCard({bool isBack = false, String? suit, String? value, Color? color, bool isChip = false, bool isMyCard = false}) {
    Widget card = Container(
      width: isMyCard ? 100 : 50,
      height: isMyCard ? 140 : 70,
      decoration: BoxDecoration(
        color: isBack ? Colors.red.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: isBack 
        ? Center(
            child: Container(
              width: isMyCard ? 56 : 40,
              height: isMyCard ? 84 : 60,
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.all(isMyCard ? 6 : 4),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    value!,
                    style: TextStyle(
                      color: color,
                      fontSize: isMyCard ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    suit!,
                    style: TextStyle(
                      color: color,
                      fontSize: isMyCard ? 42 : 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isMyCard ? 6 : 4),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.rotate(
                    angle: 3.14159,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: isMyCard ? 28 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    if (isChip) {
      return Transform.rotate(
        angle: 1.5708, // 90 degrees in radians
        child: card,
      );
    }

    return card;
  }
  
  Widget _buildBet(String amount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        amount,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Gotham',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /* Widget _buildDealerButton() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          'D',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  } */
    Widget _buildActionButton(String text) {
    return SizedBox(
      width: 120,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          shape: CircleBorder(),
          elevation: 5,
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
