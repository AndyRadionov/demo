import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading and Writing Files',
      home: StorageDemo(
        fileStorage: CounterFileStorage(),
        prefStorage: CounterSharedPrefStorage(),
      ),
    );
  }
}

class CounterSharedPrefStorage {
  //Loading counter value on start
  Future<int> readCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter') ?? 0;
  }

  //Incrementing counter after click
  Future<int> incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
      var _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
      return _counter;
    }
}

class CounterFileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class StorageDemo extends StatefulWidget {
  const StorageDemo(
      {Key? key, required this.fileStorage, required this.prefStorage})
      : super(key: key);

  final CounterFileStorage fileStorage;
  final CounterSharedPrefStorage prefStorage;

  @override
  _StorageDemoState createState() => _StorageDemoState();
}

class _StorageDemoState extends State<StorageDemo> {
  int _filesCounter = 0;
  int _prefsCounter = 0;

  @override
  void initState() {
    super.initState();
    widget.fileStorage.readCounter().then((int value) {
      setState(() {
        _filesCounter = value;
      });
    });
    widget.prefStorage.readCounter().then((int value) {
      setState(() {
        _prefsCounter = value;
      });
    });
  }

  Future<File> _incrementFilesCounter() {
    setState(() {
      _filesCounter++;
    });
    // Write the variable as a string to the file.
    return widget.fileStorage.writeCounter(_filesCounter);
  }

  void _incrementPrefsCounter() {
    widget.prefStorage.incrementCounter().then((int value) {
      setState(() {
        _prefsCounter = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reading and Writing Counters'),
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.topCenter,
                margin:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 0.0),
                child: Text(
                  'Files counter button tapped $_filesCounter time${_filesCounter == 1 ? '' : 's'}.',
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: _incrementFilesCounter,
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                )),
            Container(
                alignment: Alignment.topCenter,
                margin:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 0.0),
                child: Text(
                  'SharedPref counter button tapped $_prefsCounter time${_prefsCounter == 1 ? '' : 's'}.',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: _incrementPrefsCounter,
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                )),
          ],
        ));
  }
}
