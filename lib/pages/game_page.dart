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
        title: Text(result),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restart();
              },
              child: const Text('Restart')),
          TextButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text('Home')),
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
      appBar: AppBar(title: Text('${widget.player1} vs ${widget.player2}')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            gameOver ? result : '${isPlayer1 ? widget.player1 : widget.player2}\'s turn',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: widget.n * widget.m,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.m),
              itemBuilder: (_, index) {
                int row = index ~/ widget.m;
                int col = index % widget.m;
                return GestureDetector(
                  onTap: () => _handleTap(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
