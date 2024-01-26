import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tempat2/screens/place.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final titleController = TextEditingController(); // title
  final noteController = TextEditingController(); // note
  final name = TextEditingController(); //name
  final lat = TextEditingController();
  final long = TextEditingController();
  DateTime selectedDate = DateTime.now(); //date

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child(
        'Notes'); ////////////////////////////create or send to 'Notes' database
  }

  Future<void> _selectDate(BuildContext context) async {
    /////untuk date
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create plan'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                /////////////////////////////////////////////////////////////////title
                const SizedBox(
                  // gap
                  height: 80,
                ),
                TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'Enter Your Title',
                    filled: true, // Set to true to enable filling
                    fillColor: Colors.white, // Set the fill color to white
                  ),
                ),
                const SizedBox(
                  //gap
                  height: 30,
                ),
                /////////////////////////////////////////////////////////////////Place to go & button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: name,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Place to go',
                          hintText: 'Place',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlacePage()),
                        );

                        if (result != null) {
                          name.text = result['name'];
                          //?...??'' for null check
                          lat.text = result['latitude']?.toString() ?? '';
                          long.text = result['longitude']?.toString() ?? '';
                        }
                      },
                      child: const Text('Find'),
                    ),
                  ],
                ),
                /////////////////////////////////////////////////////////////////note
                const SizedBox(
                  //gap
                  height: 30,
                ),
                TextField(
                  controller: noteController,
                  keyboardType: TextInputType
                      .multiline, // Set keyboardType jadi multiline
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Note',
                    hintText: 'Enter Your Note',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  //gap
                  height: 30,
                ),
                ////////////////////////////////////////////////////////////////date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(selectedDate),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                ////////////////////////////////////////////////////////////////button
                const SizedBox(
                  //gap
                  height: 30,
                ),
                MaterialButton(
                  onPressed: () {
                    Map<String, String> notes = {
                      'title': titleController.text,
                      'description': name.text,
                      'note': noteController.text,
                      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                      'latitude': lat.text,
                      'longitude': long.text,
                    };

                    dbRef.push().set(notes);
                  },
                  child: const Text('Finish'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                ),
                /////////////////////////////////////////////////////////////////
              ],
            ),
          ),
        ),
      ),
    );
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
}
