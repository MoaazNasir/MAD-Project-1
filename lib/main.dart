import 'package:eventfinder/event_model.dart';
import 'package:eventfinder/event_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/event_service.dart';
import 'models/event_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Event Finder Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    EventService eventService = EventService();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Event Finder!',
            ),
            ElevatedButton(
              onPressed: () async {
                Event event = Event(
                  id: '1',
                  name: 'Sample Event',
                  description: 'This is a sample event',
                  date: DateTime.now(),
                  location: 'Sample Location',
                );
                await eventService.addEvent(event);
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
