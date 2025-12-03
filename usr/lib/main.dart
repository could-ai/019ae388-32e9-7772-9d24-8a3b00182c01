import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أبطال القفز',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  double playerX = 0;
  double playerY = 1;
  int score = 0;
  int coins = 100;
  List<Offset> platforms = [];
  List<Offset> coinsList = [];
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generatePlatforms();
    _generateCoins();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _generatePlatforms() {
    for (int i = 0; i < 10; i++) {
      platforms.add(Offset(_random.nextDouble() * 300, i * 100.0));
    }
  }

  void _generateCoins() {
    for (int i = 0; i < 20; i++) {
      coinsList.add(Offset(_random.nextDouble() * 300, _random.nextDouble() * 800));
    }
  }

  void _movePlayer(DragUpdateDetails details) {
    setState(() {
      playerX += details.delta.dx;
      playerY -= details.delta.dy;
      // Clamp player position within screen bounds
      playerX = playerX.clamp(-150, 150);
      playerY = playerY.clamp(0, 700);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أبطال القفز'),
        actions: [
          IconButton(
            icon: const Icon(Icons.store),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StoreScreen()),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: _movePlayer,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlueAccent, Colors.blue],
            ),
          ),
          child: Stack(
            children: [
              // Platforms
              ...platforms.map((platform) => Positioned(
                left: platform.dx,
                bottom: platform.dy,
                child: Container(
                  width: 80,
                  height: 20,
                  color: Colors.green,
                ),
              )),
              // Coins
              ...coinsList.map((coin) => Positioned(
                left: coin.dx,
                bottom: coin.dy,
                child: const Icon(Icons.monetization_on, color: Colors.amber),
              )),
              // Player
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    left: 150 + playerX,
                    bottom: playerY,
                    child: Transform.rotate(
                      angle: _controller.value * 2 * pi,
                      child: const Icon(Icons.person, size: 50, color: Colors.red),
                    ),
                  );
                },
              ),
              // Score and Coins
              Positioned(
                top: 20,
                left: 20,
                child: Text('Score: $score', style: const TextStyle(fontSize: 24, color: Colors.white)),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Text('Coins: $coins', style: const TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتجر'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildStoreItem(context, 'باندا', 50),
          _buildStoreItem(context, 'أرنب', 75),
          _buildStoreItem(context, 'درع', 100),
          _buildStoreItem(context, 'قفزة مزدوجة', 125),
        ],
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, String itemName, int price) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(itemName, style: const TextStyle(fontSize: 20)),
          Text('السعر: $price'),
          ElevatedButton(
            onPressed: () {
              // Add purchase logic here
            },
            child: const Text('شراء'),
          ),
        ],
      ),
    );
  }
}
