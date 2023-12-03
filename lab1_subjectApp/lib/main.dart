import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '183248'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> subjects = [];
  String textField = "";


  void _addSubject(String subject) {
    setState(() {
      subjects.add(subject);
    });
  }

  void _removeSubject(String subject){
    setState(() {
      subjects.remove(subject);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20,),
            const Text('Subjects:', style: TextStyle(fontSize: 25),),
            Expanded(child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.deepPurple.shade50,
                    title: Text(subjects[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed:(){
                        _removeSubject(subjects[index]);
                      },
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 350,
        child: FloatingActionButton(
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Add Subject'),
                    content: TextField(
                      onChanged: (value){
                        textField = value;
                      },
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
                          _addSubject(textField);
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
            );
          },
          tooltip: 'Increment',
          child: Text('Add subject'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
