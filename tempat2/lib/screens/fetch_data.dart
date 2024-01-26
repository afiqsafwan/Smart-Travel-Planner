import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tempat2/screens/update_record.dart';
import 'package:tempat2/screens/map_page.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Notes');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Notes');

  Widget listItem({required Map note}) {
    final titleText = 'Title: ${note['title']}';
    final placeText = 'Place: ${note['description']}';
    final noteText = '${note['note']}';
    final dateText = 'Date: ${note['date']}';
//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////create container/card
    return Container(
      margin: const EdgeInsets.all(10), // pad outside
      padding: const EdgeInsets.all(10), //pad inside
      height: 190,
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 78, 172, 250), // Set the card color to blue
        borderRadius: BorderRadius.circular(5), // bucu melenkung
      ),
      child: SingleChildScrollView(
        //can sroll
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //...................................................................title
            Text(
              titleText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            //...................................................................place
            Text(
              placeText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            //...................................................................date
            Text(
              dateText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            //...................................................................note
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius: BorderRadius.circular(5), // bucu melenkung
              ),
              child: Text(
                "Note:\n ${noteText}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            ///////////////////////////////////////////////////////////////////////////////////////
            /////edit, delete, map
            //...................................................................edit
            Row(
              mainAxisAlignment: MainAxisAlignment.end, //
              crossAxisAlignment: CrossAxisAlignment.center, //
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //send to UpdateRecord
                        builder: (_) => UpdateRecord(NamesKey: note['key']),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                //...............................................................delete
                GestureDetector(
                  onTap: () {
                    // delete card
                    reference.child(note['key']).remove();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                //...............................................................map
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // send lat and long to MapPage
                        builder: (_) => MapPage(
                          destinationLatitude: double.parse(note['latitude']),
                          destinationLongitude: double.parse(note['longitude']),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.map,
                        color: Color.fromARGB(255, 36, 128, 39),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Map',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 36, 128, 39)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ////
            //////////////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destination Plans'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map note = snapshot.value as Map;
            note['key'] = snapshot.key;

            return listItem(note: note); //container/card
          },
        ),
      ),
    );
  }
}
