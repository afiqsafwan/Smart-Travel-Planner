import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tempat2/screens/fetch_data.dart';
import 'package:tempat2/screens/insert_data.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyBK-zOL7mpSjnyD82dvUgj2CTKzLGVSaX4',
            appId: '1:486281621145:android:16f5cece9d7dd03c639208',
            messagingSenderId: '486281621145',
            projectId: 'travel-planner-f512e',
            databaseURL:
                'https://travel-planner-f512e-default-rtdb.asia-southeast1.firebasedatabase.app',
          ),
        )
      : Firebase.initializeApp();

  runApp(const MyApp());
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Color.fromARGB(255, 0, 43, 78), // all page background
      ),
      home: const MyHomePage(),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

////////////////////////////////////////////////////////////////////////////////////////////////
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Planner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InsertData()),
                );
              },
              child: const Text('New Destination Plans'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FetchData()),
                );
              },
              child: const Text('Destination plans'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                _showAddDialog(context);
              },
              child: const Text('Logout'),
              color: Colors.green,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> _showAddDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Title'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the entered title here
                String enteredTitle = titleController.text;
                // You can perform any action with the entered title
                print('Entered Title: $enteredTitle');
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
