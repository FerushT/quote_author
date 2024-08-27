import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote App',
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String? _quote;
  String? _author;
  bool _isLoading = false;
  String _selectedCategory = "Inspiration";

  // Liste der verfügbaren Kategorien
  final List<String> _categories = [
    "inspiration",
    "love",
    "success",
    "happiness",
    "age",
    "alone",
    "amazing",
    "anger",
    "architecture",
    "art",
    "attitude",
    "beauty",
    "best",
    "birthday",
    "business",
    "car",
    "change",
    "communication",
    "computers",
    "cool",
    "courage",
    "dad",
    "dating",
    "death",
    "design",
    "dreams",
    "education",
    "environmental",
    "equality",
    "experience",
    "failure",
    "faith",
    "family",
    "famous",
    "fear",
    "fitness",
    "food",
    "forgiveness",
    "freedom",
    "friendship",
    "funny",
    "future",
    "god",
    "good",
    "government",
    "graduation",
    "great",
    "happiness",
    "health",
    "history",
    "home",
    "hope",
    "humor",
    "imagination",
    "inspirational",
    "intelligence",
    "jealousy",
    "knowledge",
    "leadership",
    "learning",
    "legal",
    "life",
    "love",
    "marriage",
    "medical",
    "men",
    "mom",
    "money",
    "morning",
    "movies",
    "success"
  ];

  @override
  void initState() {
    super.initState();

    // Hiermit wird sichergestellt, dass die Kategorien sortiert werden und mit einem Großbuchstaben beginnen.
    _categories.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    _categories.replaceRange(
      0,
      _categories.length,
      _categories
          .map((category) => category[0].toUpperCase() + category.substring(1))
          .toList(),
    );
  }

  // Abrufen eines Zitats basierend auf der ausgewählten Kategorie.
  Future<void> fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://api.api-ninjas.com/v1/quotes?category=${_selectedCategory.toLowerCase()}'), // API-URL mit der ausgewählten Kategorie
      headers: {
        "X-Api-Key": "ZTLb439IovAQNvdy6isi05Ch6j3Pd3eLxthAH3tI"
      }, // API-Schlüssel im Header
    );

    // Wenn die Antwort mit 200 erfolgreich ist, wird mit jsonDecode die Antwort dekodiert.
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _quote =
            data[0]['quote']; // Hier wird das Zitat aus den Daten extrahiert.
        _author =
            data[0]['author']; // Hier wird der Autor aus den Daten extrahiert.
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception(
          "Zitat konnte nicht geladen werden"); // Wird angezeigt, wenn eine Fehlermeldung kommt.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zufällige Zitate"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Hinweistext über der Auswahl der Kategorie
              const Text(
                "Bitte Kategorie auswählen",
                style: TextStyle(
                  fontSize: 18, // Schriftgröße des Hinweistextes
                  fontWeight: FontWeight.bold, // Fettgedruckter Hinweistext
                ),
              ),
              const SizedBox(
                  height:
                      20), // Abstand zwischen Hinweistext und DropdownButton

              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                    fetchQuote(); // Hiermit wird ein neues Zitat abgerufen, wenn die Kategorie gewählt wurde.
                  });
                },
                items: _categories
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child:
                        Text(category), // Anzeige der Kategorie im Dropdownmenü
                  );
                }).toList(),
                iconSize: 30,
                iconEnabledColor: const Color.fromARGB(255, 0, 0, 0),
                dropdownColor: Colors.lightBlueAccent,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading && _quote != null && _author != null)
                Column(
                  children: [
                    Text(
                      _quote!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 23.0, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "- $_author",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed:
                    fetchQuote, // Abrufen eines neuen Zitats beim Drücken
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlueAccent),
                  foregroundColor: MaterialStateProperty.all(
                      Colors.black), // Textfarbe auf Schwarz setzen
                ),
                child: const Text("Für zufällige Zitate hier drücken"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
