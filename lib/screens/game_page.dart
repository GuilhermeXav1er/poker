import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/room_service.dart';

class GamePage extends StatefulWidget {
  final String? roomId;
  final String? playerId;
  final String? playerName;

  const GamePage({
    super.key,
    this.roomId,
    this.playerId,
    this.playerName,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final RoomService _roomService = RoomService();
  late StreamSubscription _stateSubscription;

  // Estado do jogo
  List<Map<String, dynamic>> _players = [];
  String? _roomId;
  Map<String, dynamic>? _gameData;

  @override
  void initState() {
    super.initState();
    print('GamePage initialized with:');
    print('Room ID: \\${widget.roomId}');
    print('Player ID: \\${widget.playerId}');
    print('Player Name: \\${widget.playerName}');

    if (widget.roomId != null && widget.playerId != null) {
      _roomService.connectToWebSocket(widget.roomId!, widget.playerId!);
    }

    // Escuta eventos do estado do jogo
    _stateSubscription = _roomService.stateStream.listen((state) {
      print('DEBUG: state recebido do WebSocket:');
      print(state);
      setState(() {
        _roomId = state['room_id'] ?? widget.roomId;
        // Se for evento de game, players estão em state['game']['players']
        if (state['game'] != null && state['game'] is Map && state['game']['players'] != null) {
          final gamePlayers = state['game']['players'];
          if (gamePlayers is List) {
            _players = gamePlayers.whereType<Map<String, dynamic>>().toList();
          } else {
            _players = [];
          }
        } else if (state['players'] != null && state['players'] is List) {
          // fallback para lista de nomes (lobby)
          _players = [];
        } else {
          _players = [];
        }
        _gameData = state['game'] is Map<String, dynamic> ? state['game'] : null;
        print('DEBUG: _players = \\${_players}');
        print('DEBUG: _gameData = \\${_gameData}');
      });
    });
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    _roomService.disconnectWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: _players = \\${_players}');
    print('DEBUG: widget.playerId = \\${widget.playerId}');
    // Busca o jogador atual
    final myPlayer = _players.firstWhere(
      (p) => p['id'] == widget.playerId,
      orElse: () => <String, dynamic>{},
    );
    print('DEBUG: myPlayer = \\${myPlayer}');
    // Pot geral
    final pot = _gameData != null && _gameData!['pot'] != null ? _gameData!['pot'].toString() : '0';
    // Pot do jogador
    final myChips = myPlayer['chips']?.toString() ?? '0';
    // Cartas do jogador
    final myHand = (myPlayer['hand'] is List) ? myPlayer['hand'] : [];
    print('DEBUG: myHand = \\${myHand}');
    // Cartas comunitárias
    final communityCards = _gameData != null && _gameData!['community_cards'] != null && _gameData!['community_cards'] is List ? List.from(_gameData!['community_cards']) : [];
    print('DEBUG: communityCards = \\${communityCards}');

    // Se não encontrou o jogador, mostra mensagem amigável
    if (myPlayer.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF18713A),
        body: const Center(
          child: Text(
            'Aguardando informações do jogador...\nVerifique se você entrou corretamente na sala.',
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF18713A),
      body: Stack(
        children: [
          // Mesa de poker oval central
          Center(
            child: Container(
              width: 750,
              height: 300,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    Color(0xFFB85450),
                    Color(0xFF8B4513),
                  ],
                ),
                borderRadius: BorderRadius.circular(200),
                border: Border.all(color: const Color(0xFF654321), width: 8),
              ),
            ),
          ),
          // Pot geral
          Positioned(
            top: 10,
            left: 120,
            child: Column(
              children: [
                const Text(
                  'Pote atual',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$pot',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Pot do jogador
          Positioned(
            top: 10,
            right: 120,
            child: Column(
              children: [
                const Text(
                  'Seu pote',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$myChips',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Renderiza jogadores ao redor da mesa
          ..._buildPlayersAroundTable(_players, myPlayer),
          // Cartas comunitárias (centro da mesa)
          Positioned(
            top: 160,
            left: 320,
            child: Row(
              children: [
                for (var card in communityCards)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildCard(
                      suit: card['suit'] ?? '',
                      value: card['rank'] ?? '',
                      color: _getCardColor(card['suit']),
                    ),
                  ),
              ],
            ),
          ),
          // Suas cartas (parte inferior)
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Row(
              children: [
                for (var card in myHand)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildCard(
                      suit: card['suit'] ?? '',
                      value: card['rank'] ?? '',
                      color: _getCardColor(card['suit']),
                      isMyCard: true,
                    ),
                  ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildActionButton('Desistir'),
                    _buildActionButton('Passar'),
                    _buildActionButton('Apostar'),
                  ],
                ),
                const Spacer(),
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

  // Renderiza os jogadores ao redor da mesa
  List<Widget> _buildPlayersAroundTable(List<Map<String, dynamic>> players, Map<String, dynamic> myPlayer) {
    // Exemplo simples: distribui os jogadores em posições fixas (melhore conforme necessário)
    final positions = [
      const Offset(80, 80), // topo esquerdo
      const Offset(80, 300), // esquerda
      const Offset(600, 80), // topo direito
      const Offset(600, 300), // direita
    ];
    List<Widget> widgets = [];
    for (int i = 0; i < players.length; i++) {
      final p = players[i];
      final pos = positions[i % positions.length];
      widgets.add(
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: _buildPlayer(p['name'] ?? '', '${p['chips'] ?? 0}', isMe: p['id'] == myPlayer['id']),
        ),
      );
      // Aposta do jogador
      widgets.add(
        Positioned(
          left: pos.dx + 60,
          top: pos.dy + 40,
          child: _buildBet('${p['current_bet'] ?? 0}'),
        ),
      );
    }
    return widgets;
  }

  Widget _buildPlayer(String name, String money, {bool isMe = false}) {
    return Column(
      children: [
        Text(
          name + (isMe ? ' (você)' : ''),
          style: TextStyle(
            color: isMe ? Colors.yellow : Colors.white,
            fontSize: 18,
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          money,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Gotham',
          ),
        ),
      ],
    );
  }

  Color _getCardColor(String? suit) {
    if (suit == null) return Colors.black;
    if (suit == '♥' || suit == '♦') return Colors.red;
    return Colors.black;
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
