// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController currentQuote = TextEditingController();
  String currentQuoteText = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchNextQuote(),
      builder: (constext, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          currentQuoteText = snapshot.data!;
          return Scaffold(
            // backgroundColor: Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              title: const Text(
                "Daily Zen Quotes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "times new roman",
                  // fontStyle: FontStyle.italic,
                ),
              ),
              // backgroundColor: const Color.fromARGB(255, 67, 174, 67)
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentQuoteText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontFamily: "cursive",
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                  width: 1000,
                ),
                ElevatedButton(
                  onPressed: () async {
                    String quote = await fetchNextQuote();
                    print(quote);
                    currentQuote.text = quote;
                    setState(() {
                      currentQuoteText = quote;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Next"),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            // backgroundColor: const Color.fromARGB(255, 157, 238, 157),
            appBar: AppBar(
              title: const Text(
                "Daily Zen Quotes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "times new roman",
                  // fontStyle: FontStyle.italic,
                ),
              ),
              // backgroundColor: const Color.fromARGB(255, 67, 174, 67)
            ),
            body: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 1000),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}

Future<String> fetchNextQuote() async {
  try {
    final res = await http.get(Uri.parse('https://zenquotes.io/api/random'));
    if (res.statusCode != 200) return "Internet Connection Lost!";
    String resBody = res.body;
    final quote = (json.decode(resBody))[0]['q'];
    return quote;
  } catch (e) {
    return "Internet Connection Lost!";
  }
}
