import 'package:flutter/material.dart';

void main() {
  runApp(MyClothesApp());
}

class MyClothesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wardrobe',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClothesListScreen(),
    );
  }
}

class Clothes {
  String name;
  String type;

  Clothes({
    required this.name,
    required this.type,
  });
}

class ClothesListScreen extends StatefulWidget {
  @override
  _ClothesListScreenState createState() => _ClothesListScreenState();
}



class _ClothesListScreenState extends State<ClothesListScreen> {
  TextEditingController nameController = TextEditingController();
  String selectedType = '';


  List<Clothes> clothes = [
    Clothes(name: 'Blue Skirt', type: 'Skirt'),
    Clothes(name: 'Summer Dress', type: 'Dress'),
    Clothes(name: 'Black Pants', type: 'Pants'),
  ]; // Initial clothes list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wardrobe'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: clothes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              clothes[index].name,
              style: TextStyle(color: Colors.blue),
            ),
            subtitle: Text(
              'Type: ${clothes[index].type}',
              style: TextStyle(color: Colors.black),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    _editClothes(context, index);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteClothes(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.red,
            onPressed: () {
              _addClothes(
                  context); // Pass the BuildContext to access the Scaffold
            },
            tooltip: 'Add Clothes',
            child: Text('Add new', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  void _addClothes(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    String selectedType = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Center(
              child: Text(
                'Add Clothes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Select Type:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            for (String type in [
                              'Skirt',
                              'Dress',
                              'Pants',
                              'T-Shirt',
                              'Sweater',
                              'Shirt',
                              'Underwear' /* Add other types here */
                            ])
                              RadioListTile<String>(
                                title: Text(type),
                                value: type,
                                groupValue: selectedType,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedType = value!;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      selectedType.isNotEmpty) {
                    Clothes newClothes = Clothes(
                        name: nameController.text, type: selectedType);
                    setState(() {
                      clothes.add(newClothes);
                    });
                    nameController.clear();
                    selectedType = '';
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    // Handle validation or show an error message if name or type is empty
                  }
                },
                child: Text('Add', style: TextStyle(color: Colors.red),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editClothes(BuildContext context, int index) {
    TextEditingController editedNameController = TextEditingController();
    String editedSelectedType = clothes[index].type;

    editedNameController.text = clothes[index].name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Center(
              child: Text(
                'Edit Clothes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // You can change the title text color
                ),
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: editedNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Select Type:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            for (String type in [
                              'Skirt',
                              'Dress',
                              'Pants',
                              'T-Shirt',
                              'Sweater',
                              'Shirt',
                              'Underwear' /* Add other types here */
                            ])
                              RadioListTile<String>(
                                title: Text(type),
                                value: type,
                                groupValue: editedSelectedType,
                                onChanged: (String? value) {
                                  setState(() {
                                    editedSelectedType = value!;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (editedNameController.text.isNotEmpty &&
                      editedSelectedType.isNotEmpty) {
                    setState(() {
                      clothes[index].name = editedNameController.text;
                      clothes[index].type = editedSelectedType;
                    });
                    editedNameController.clear();
                    editedSelectedType = '';
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    // Handle validation or show an error message if name or type is empty
                  }
                },
                child: Text('Save', style: TextStyle(color: Colors.red),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Change the button color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteClothes(int index) {
    setState(() {
      clothes.removeAt(index);
    });
  }
}