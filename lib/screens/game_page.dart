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
              width: 800,
              height: 400,
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
            top: 60,
            left: 120,
            child: Column(
              children: [
                Text(
                  'Pote atual',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$ 600',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Informações do seu pote (topo direito)
          Positioned(
            top: 60,
            right: 120,
            child: Column(
              children: [
                Text(
                  'Seu pote',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$ 450',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Jogador Xavier (topo esquerdo da mesa)
          Positioned(
            top: 150,
            left: 80,
            child: _buildPlayer('Xavier', '\$ 500'),
          ),
          
          // Cartas do Xavier
          Positioned(
            top: 180,
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
            top: 250,
            left: 220,
            child: _buildBet('\$ 10'),
          ),
          
          // Botão dealer (perto do Xavier)
          Positioned(
            top: 260,
            left: 280,
            child: _buildDealerButton(),
          ),
          
          // Jogador Enzo (topo direito da mesa)
          Positioned(
            top: 150,
            right: 80,
            child: _buildPlayer('Enzo', '\$ 350'),
          ),
          
          // Cartas do Enzo
          Positioned(
            top: 180,
            right: 200,
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
            top: 280,
            child: _buildPlayer('Romanhole', '\$ 500'),
          ),
          
          // Cartas do Romanhole (chip)
          Positioned(
            left: 120,
            top: 300,
            child: Column(
              children: [
                _buildCard(isBack: true, isChip: true),
                SizedBox(height: 5),
                _buildCard(isBack: true, isChip: true),
              ],
            ),
          ),
          
          // Aposta do Romanhole
          Positioned(
            left: 170,
            top: 330,
            child: _buildBet('\$ 5'),
          ),
          
          // Jogador Bruno (direita da mesa)
          Positioned(
            right: 20,
            top: 280,
            child: _buildPlayer('Bruno', '\$ 150'),
          ),
          
          // Cartas do Bruno (chip)
          Positioned(
            right: 120,
            top: 300,
            child: Column(
              children: [
                _buildCard(isBack: true, isChip: true),
                SizedBox(height: 5),
                _buildCard(isBack: true, isChip: true),
              ],
            ),
          ),
          
          // Cartas comunitárias (centro da mesa)
          Positioned(
            top: 280,
            left: 280,
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
            top: 360,
            left: 380,
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
            bottom: 180,
            left: MediaQuery.of(context).size.width / 2 - 120,
            child: Row(
              children: [
                _buildCard(suit: '♠', value: 'J', color: Colors.black),
                SizedBox(width: 10),
                _buildCard(suit: '♦', value: 'A', color: Colors.red),
              ],
            ),
          ),
          
          // Botões de ação (parte inferior)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Desistir'),
                _buildActionButton('Passar'),
                _buildActionButton('Apostar'),
                _buildActionButton('Pagar'),
                _buildActionButton('Aumentar'),
                _buildActionButton('All-In'),
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
  
  Widget _buildCard({bool isBack = false, String? suit, String? value, Color? color, bool isChip = false}) {
    if (isChip) {
      return Container(
        width: 50,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(
            image: AssetImage('assets/chips.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    
    return Container(
      width: 60,
      height: 85,
      decoration: BoxDecoration(
        color: isBack ? Colors.red.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: isBack 
        ? Center(
            child: Container(
              width: 40,
              height: 60,
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
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    value!,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
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
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.rotate(
                    angle: 3.14159,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
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
  
  Widget _buildDealerButton() {
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
  }
    Widget _buildActionButton(String text) {
    return SizedBox(
      width: 120,
      height: 60,
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
