import 'package:flutter/material.dart';
 import 'game_page.dart';

class PlayerSetupPage extends StatefulWidget {
  const PlayerSetupPage({super.key});

  @override
  State<PlayerSetupPage> createState() => _PlayerSetupPageState();
}

class _PlayerSetupPageState extends State<PlayerSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _player1 = TextEditingController();
  final _player2 = TextEditingController();
  final _n = TextEditingController(text: '3');
  final _m = TextEditingController(text: '3');
  final _k = TextEditingController(text: '3');

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      int n = int.parse(_n.text);
      int m = int.parse(_m.text);
      int k = int.parse(_k.text);

      if (k > n && k > m) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('K cannot be greater than both N and M')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GamePage(
            player1: _player1.text,
            player2: _player2.text,
            n: n,
            m: m,
            k: k,
          ),
        ),
      );
    }
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Tic Tac Toe: Setup Page'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Player Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildInputField('Player 1 Name', _player1),
                  _buildInputField('Player 2 Name', _player2),
                  const SizedBox(height: 16),
                  const Text('Board Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildInputField('Number of Rows (N)', _n, keyboardType: TextInputType.number),
                  _buildInputField('Number of Columns (M)', _m, keyboardType: TextInputType.number),
                  _buildInputField('Winning Line Length (K)', _k, keyboardType: TextInputType.number),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _startGame,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
                      side: const BorderSide(color: Colors.indigo),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}