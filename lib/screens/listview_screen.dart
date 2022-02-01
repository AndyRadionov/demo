import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: ListStatefulWidget()),
    );
  }
}

class ListStatefulWidget extends StatefulWidget {
  const ListStatefulWidget({Key? key}) : super(key: key);

  @override
  State<ListStatefulWidget> createState() => _ListStatefulWidgetState();
}

class _ListStatefulWidgetState extends State<ListStatefulWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Item $index'),
          selected: index == _selectedIndex,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      },
    );
  }
}
