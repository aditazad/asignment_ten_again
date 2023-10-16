import 'package:flutter/material.dart';
import 'add_items.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  void _showOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options'),
          content: Text('Choose an option'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditBottomSheet(index);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(int index) {
    TextEditingController editFirstController =
    TextEditingController(text: items[index].split(' - ')[0]);
    TextEditingController editSecondController =
    TextEditingController(text: items[index].split(' - ')[1]);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editFirstController,
                    decoration: InputDecoration(
                      hintText: 'Enter the first item',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: editSecondController,
                    decoration: InputDecoration(
                      hintText: 'Enter the second item',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        items[index] =
                        '${editFirstController.text} - ${editSecondController.text}';
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Edit'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      editFirstController.dispose();
      editSecondController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddItems(
              firstController: firstController,
              secondController: secondController,
              onAdd: (String item) {
                setState(() {
                  items.add(item);
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showOptionsDialog(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(12),
                      child: ListTile(
                        leading: Text('${index + 1}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        title: Text(items[index], style: TextStyle(fontSize: 16)),
                        trailing: Icon(Icons.arrow_forward),
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
}
