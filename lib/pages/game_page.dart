import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String player1;
  final String player2;
  final int n, m, k;

  const GamePage({
    super.key,
    required this.player1,
    required this.player2,
    required this.n,
    required this.m,
    required this.k,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<String>> board;
  late bool isPlayer1;
  bool gameOver = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    board = List.generate(widget.n, (_) => List.filled(widget.m, ''));
    isPlayer1 = true;
  }

  void _handleTap(int row, int col) {
    if (board[row][col] != '' || gameOver) return;

    setState(() {
      board[row][col] = isPlayer1 ? 'X' : 'O';
      if (_checkWin(row, col)) {
        result = '${isPlayer1 ? widget.player1 : widget.player2} wins!';
        gameOver = true;
        _showResultDialog();
      } else if (_isDraw()) {
        result = 'Draw!';
        gameOver = true;
        _showResultDialog();
      } else {
        isPlayer1 = !isPlayer1;
      }
    });
  }

  bool _checkWin(int row, int col) {
    String current = board[row][col];
    int k = widget.k;

    List<List<int>> directions = [
      [0, 1], [1, 0], [1, 1], [1, -1]
    ];

    for (var dir in directions) {
      int count = 1;
      int r = row + dir[0], c = col + dir[1];
      while (_isValid(r, c) && board[r][c] == current) {
        count++; r += dir[0]; c += dir[1];
      }
      r = row - dir[0]; c = col - dir[1];
      while (_isValid(r, c) && board[r][c] == current) {
        count++; r -= dir[0]; c -= dir[1];
      }
      if (count >= k) return true;
    }
    return false;
  }

  bool _isValid(int r, int c) => r >= 0 && c >= 0 && r < widget.n && c < widget.m;
  bool _isDraw() => board.every((row) => row.every((cell) => cell != ''));

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              result == 'Draw!' ? Icons.handshake : Icons.emoji_events,
              color: result == 'Draw!' ? Colors.orange : Colors.green,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(result, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restart();
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      board = List.generate(widget.n, (_) => List.filled(widget.m, ''));
      isPlayer1 = true;
      gameOver = false;
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.player1} vs ${widget.player2}'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              gameOver ? result : '${isPlayer1 ? widget.player1 : widget.player2}\'s Turn',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.n * widget.m,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.m,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (_, index) {
                  int row = index ~/ widget.m;
                  int col = index % widget.m;
                  return GestureDetector(
                    onTap: () => _handleTap(row, col),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.indigo.shade100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: board[row][col] == 'X' ? Colors.red : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
