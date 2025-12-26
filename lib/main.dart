import 'package:flutter/material.dart';

void main() {
  runApp(const ButtonsOfLogicApp());
}

class ButtonsOfLogicApp extends StatelessWidget {
  const ButtonsOfLogicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buttons of Logic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LogicPage(),
    );
  }
}

class LogicPage extends StatefulWidget {
  const LogicPage({super.key});

  @override
  State<LogicPage> createState() => _LogicPageState();
}

class _LogicPageState extends State<LogicPage> {
  int value = 0;
  List<int> history = [];
  int zeroStreak = 0;
  bool isLocked = false;

  void increment() {
    if (isLocked) return;
    setState(() {
      value++;
      _updateHistory(value);
      _checkZeroStreak();
    });
  }

  void decrement() {
    if (isLocked) return;
    setState(() {
      value--;
      _updateHistory(value);
      _checkZeroStreak();
    });
  }

  void reset() {
    setState(() {
      value = 0;
      zeroStreak = 0;
      isLocked = false;
      _updateHistory(value);
    });
  }

  void _updateHistory(int newValue) {
    history.insert(0, newValue);
    if (history.length > 5) {
      history.removeLast();
    }
  }

  void _checkZeroStreak() {
    if (value == 0) {
      zeroStreak++;
    } else {
      zeroStreak = 0;
    }

    if (zeroStreak == 3) {
      isLocked = true;
      _showZeroDialog();
    }
  }

  void _showZeroDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('⚠️ Peringatan'),
        content: const Text(
          'Nilai 0 tercapai 3 kali berturut-turut',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  bool get isEven => value % 2 == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons of Logic'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD NILAI
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        isEven ? 'Genap' : 'Ganjil',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor:
                          isEven ? Colors.green : Colors.blue,
                    ),
                    if (isLocked) ...[
                      const SizedBox(height: 10),
                      const Text(
                        '🔒 Tombol terkunci',
                        style: TextStyle(color: Colors.red),
                      )
                    ]
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TOMBOL AKSI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  icon: Icons.remove,
                  label: '-1',
                  onPressed: isLocked ? null : decrement,
                ),
                _actionButton(
                  icon: Icons.add,
                  label: '+1',
                  onPressed: isLocked ? null : increment,
                ),
                _actionButton(
                  icon: Icons.restart_alt,
                  label: 'Reset',
                  color: Colors.orange,
                  onPressed: reset,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // RIWAYAT
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat (5 Terakhir)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text('Belum ada riwayat'),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (_, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(
                              'Nilai: ${history[index]}',
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

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
