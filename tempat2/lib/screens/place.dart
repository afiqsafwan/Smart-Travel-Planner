// place_page.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({Key? key}) : super(key: key);

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('malaysia'); //call data kat malaysia

  String selectedState = 'all'; //dropdown defuld 'all'

  Widget listItem({
    // get data
    required String placeName,
    required String name,
    required String state,
    required String alamat,
    required String fee,
    required String im1,
    required String info,
    required double klat,
    required double klong,
    required String waktu,
    required dynamic tel,
  }) {
    ////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
    ///create card
    return Card(
      margin: const EdgeInsets.all(10),
      color: const Color.fromARGB(
          255, 145, 204, 252), // Set the card color to blue
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            //...................................................................name
            Text(
              '$name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            //...................................................................state
            Text(
              'State: $state',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            //...................................................................adress
            RichText(
              text: TextSpan(
                text: 'Address: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: alamat,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................fee
            RichText(
              text: TextSpan(
                text: 'Fee: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: fee,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................image
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: Image.network(
                          im1,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Image.network(
                im1,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................info
            RichText(
              text: TextSpan(
                text: 'Info: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: info,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................cordinate
            RichText(
              text: TextSpan(
                text: 'Latitude: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: klat.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: 'Longitude: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: klong.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................time
            RichText(
              text: TextSpan(
                text: 'Opening Hours: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: waktu,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................tel
            RichText(
              text: TextSpan(
                text: 'Telephone: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: tel.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            //...................................................................button
            ElevatedButton(
              // button
              onPressed: () {
                // gi kat preveous page and send 3 value
                Navigator.pop(context, {
                  'name': name,
                  'latitude': klat,
                  'longitude': klong,
                });
              },
              child: const Text('Pick'),
            ),
          ],
        ),
      ),
    );
    ////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: Column(
        children: [
          /////////////////////////////////////////////////////////////////// Dropdown button

          Container(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              dropdownColor: Color.fromARGB(255, 0, 43, 78), //background
              underline: Container(
                height: 1,
                color: Color.fromARGB(255, 145, 204, 252), //line color
              ),
              style: const TextStyle(
                color: Color.fromARGB(255, 145, 204, 252), //text color
              ),
              value: selectedState,
              onChanged: (String? newValue) {
                setState(() {
                  selectedState = newValue!;
                });
              },
              items: [
                'all',
                'johor',
                'kedah',
                'kelantan',
                'melaka',
                'negeri sembilan',
                'pahang',
                'perak',
                'perlis',
                'pulau pinang',
                'sabah',
                'sarawak',
                'selangor',
                'terengganu',
                'wilayah persekutuan kuala lumpur',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          //////////////////////////////////////////////////////////////////////////////////
          Expanded(
            child: Container(
              height: double.infinity,
              child: FirebaseAnimatedList(
                query: reference,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  dynamic placeData = snapshot.value;
                  if (placeData is Map<dynamic, dynamic> &&
                      placeData.isNotEmpty) {
                    List<Widget> cards = [];

                    // Iterate through each entry in placeData
                    placeData.forEach((key, value) {
                      if (selectedState == 'all' ||
                          selectedState == value['p']) {
                        //p = daerah/state
                        cards.add(listItem(
                          //call listItem to create card
                          placeName: key,
                          name: value['Pname'] ?? '',
                          state: value['p'] ?? '',
                          alamat: value['alamat'] ?? '',
                          fee: value['fee'] ?? '',
                          im1: value['im1'] ?? '',
                          info: value['info'] ?? '',
                          klat: value['klat'] ?? 0.0,
                          klong: value['klong'] ?? 0.0,
                          waktu: value['waktu'] ?? '',
                          tel: value['tel'] ?? 0,
                        ));
                      }
                    });

                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: cards,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
