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
          SnackBar(
            content: const Text('K cannot be greater than both N and M'),
            backgroundColor: Colors.red[400],
          ),
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
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text('Tic Tac Toe Setup'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width > 500 ? 500 : size.width),
            child: Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Players', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      _buildInputField('Player 1 Name', _player1),
                      _buildInputField('Player 2 Name', _player2),
                      const SizedBox(height: 16),
                      const Text('Game Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      _buildInputField('Rows (N)', _n, keyboardType: TextInputType.number),
                      _buildInputField('Columns (M)', _m, keyboardType: TextInputType.number),
                      _buildInputField('Winning Line (K)', _k, keyboardType: TextInputType.number),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _startGame,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Game'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
