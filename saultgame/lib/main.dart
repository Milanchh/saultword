import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sault Word Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      home: const SplashScreen(),  // Start the app with the SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SaultWordGame()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Logo using Text and Icon
            Icon(
              Icons.games,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              "Sault Word Game",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 15, color: Colors.black54)],
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class SaultWordGame extends StatefulWidget {
  const SaultWordGame({super.key});

  @override
  State<SaultWordGame> createState() => _SaultWordGameState();
}

class _SaultWordGameState extends State<SaultWordGame> {
  static const List<String> words = ['FLUTTER', 'DART', 'WIDGET', 'STATE'];
  static const List<String> images = [
    'assets/flutter.png',
    'assets/dart.png',
    'assets/widget.png',
    'assets/state.png',
  ];
  static const List<String> hints = [
    'A framework for building apps.',
    'A programming language for Flutter.',
    'UI components in Flutter.',
    'A geographic component.',
  ];

  late String word;
  late String displayedWord;
  late String wordImage;
  late String wordHint;
  int wrongGuesses = 0;
  final List<String> guessedLetters = [];

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final randomIndex = Random().nextInt(words.length);
    word = words[randomIndex];
    wordImage = images[randomIndex];
    wordHint = hints[randomIndex];
    displayedWord = '_' * word.length;
    wrongGuesses = 0;
    guessedLetters.clear();
    setState(() {});
  }

  void _guessLetter(String letter) {
    if (guessedLetters.contains(letter)) return;

    guessedLetters.add(letter);
    if (word.contains(letter)) {
      for (int i = 0; i < word.length; i++) {
        if (word[i] == letter) {
          displayedWord = displayedWord.replaceRange(i, i + 1, letter);
        }
      }
    } else {
      wrongGuesses++;
    }

    if (wrongGuesses == 6 || displayedWord == word) {
      _showResultDialog();
    }

    setState(() {});
  }

  void _showResultDialog() {
    final isWin = displayedWord == word;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: isWin ? Colors.green[100] : Colors.red[100],
        title: Text(
          isWin ? "🎉 You Won!" : "☹️ Game Over",
          style: TextStyle(color: isWin ? Colors.green : Colors.red),
        ),
        content: Text(
          isWin
              ? "Amazing! You guessed the word!"
              : "Oops! The correct word was '$word'. Try again!",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startNewGame();
            },
            child: const Text(
              "Play Again",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sault Word Game"),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(wordImage, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(word.length, (index) {
                final letter = displayedWord[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 50,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: letter == '_' ? Colors.white70 : Colors.green[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    letter == '_' ? '' : letter,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: letter == '_' ? Colors.grey : Colors.black,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Hint: $wordHint",
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Wrong Guesses: $wrongGuesses/6",
              style: const TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(26, (index) {
                  final letter = String.fromCharCode(65 + index);
                  final isGuessed = guessedLetters.contains(letter);
                  return ElevatedButton(
                    onPressed: isGuessed ? null : () => _guessLetter(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isGuessed ? Colors.grey : Colors.purpleAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    ),
                    child: Text(letter),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
