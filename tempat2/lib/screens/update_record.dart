////nak sama dgn insert_data.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tempat2/screens/place.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key, required this.NamesKey}) : super(key: key);

  final String NamesKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final uTitleController = TextEditingController();
  final uNoteController = TextEditingController();
  final name = TextEditingController();
  DateTime selectedDate = DateTime.now();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Notes');
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.child(widget.NamesKey).get();

    Map note = snapshot.value as Map;

    uTitleController.text = note['title'];
    uNoteController.text = note['note'];
  }

  Future<void> _selectDate(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Plan'),
      ),
      body: SingleChildScrollView(
        // can scroll
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ////////////////////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: uTitleController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'Enter Your Title',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                /////////////////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 30,
                ),
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

                          Map<String, String> notes = {
                            'title': uTitleController.text,
                            'description': name.text,
                            'note': uNoteController.text,
                            'date':
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                            'latitude': result['latitude'].toString(),
                            'longitude': result['longitude'].toString(),
                          };

                          dbRef
                              .child(widget.NamesKey)
                              .update(notes)
                              .then((value) => {Navigator.pop(context)});
                        }
                      },
                      child: const Text('Find'),
                    ),
                  ],
                ),
                ///////////////////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: uNoteController,
                  keyboardType: TextInputType
                      .multiline, // Set the keyboardType to multiline
                  maxLines: null, // Set maxLines to null for unlimited lines
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Note',
                    hintText: 'Enter Your Note',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                ///////////////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 30,
                ),
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
                ///////////////////////////////////////////////////////////////////////////////
                MaterialButton(
                  onPressed: () {
                    Map<String, String> notes = {
                      'title': uTitleController.text,
                      'description': name.text,
                      'note': uNoteController.text,
                      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                    };

                    dbRef
                        .child(widget.NamesKey)
                        .update(notes)
                        .then((value) => {Navigator.pop(context)});
                  },
                  child: const Text('Update Data'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
