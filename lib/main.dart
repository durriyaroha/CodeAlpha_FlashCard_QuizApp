import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: FlashcardListScreen(),
    );
  }
}

class Flashcard {
  String question;
  String answer;

  Flashcard(this.question, this.answer);
}

class FlashcardListScreen extends StatefulWidget {
  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  final List<Flashcard> flashcards = [];

  void _addFlashcard(String question, String answer) {
    setState(() {
      flashcards.add(Flashcard(question, answer));
    });
  }

  void _startQuiz() {
    if (flashcards.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuizScreen(flashcards: flashcards)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add some flashcards first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  elevation: 4,
                  child: ListTile(
                    title: Text(flashcards[index].question),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.indigo),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _startQuiz,
              child: const Text('Start Quiz'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.yellow,
                backgroundColor: Colors.black, // Text color
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'This app is designed by Durriya Roha',
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AddFlashcardDialog(
            onAddFlashcard: _addFlashcard,
          ),
        ),
        child: const Icon(Icons.add, color: Colors.yellow),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class AddFlashcardDialog extends StatefulWidget {
  final Function(String, String) onAddFlashcard;

  AddFlashcardDialog({required this.onAddFlashcard});

  @override
  _AddFlashcardDialogState createState() => _AddFlashcardDialogState();
}

class _AddFlashcardDialogState extends State<AddFlashcardDialog> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Flashcard'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: questionController,
            decoration: const InputDecoration(labelText: 'Question'),
          ),
          TextField(
            controller: answerController,
            decoration: const InputDecoration(labelText: 'Answer'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onAddFlashcard(
                questionController.text, answerController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class QuizScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  QuizScreen({required this.flashcards});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;
  bool showAnswer = false;

  void _nextQuestion(bool correct) {
    if (correct) {
      score++;
    }
    setState(() {
      currentIndex++;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= widget.flashcards.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Finished'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your score: $score / ${widget.flashcards.length}',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back to Flashcards'),
              ),
            ],
          ),
        ),
      );
    }

    Flashcard currentFlashcard = widget.flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentFlashcard.question,
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            if (showAnswer)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  currentFlashcard.answer,
                  style: const TextStyle(fontSize: 20.0, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showAnswer = !showAnswer;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Background color set to black
              ),
              child: Text(
                showAnswer ? 'Hide Answer' : 'Show Answer',
                style:
                    TextStyle(color: Colors.yellow), // Text color set to yellow
              ),
            ),
            if (showAnswer) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _nextQuestion(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Correct',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _nextQuestion(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Incorrect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
