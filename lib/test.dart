import 'package:authentication/prehomepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
int selectedIndex = 0;
String apiKey1 = 'AIzaSyDm-MaPLtStPAEPLi-nQ2_DAgh24BRGH14';
String radius = "1000"; //in metre
List<dynamic> busStations = [];
List<dynamic> trainStations = [];
String tS = '';
String bS = '';

class Transit1 extends StatefulWidget {
  const Transit1({super.key});

  @override
  State<Transit1> createState() => _Transit1State();
}


class _Transit1State extends State<Transit1> {

  void _handleRadioValueChange(int? value) {
    setState(() {
      selectedIndex = value!;
    });
    if(selectedIndex==1)
      getNearbyBusStations();
    else if(selectedIndex==2)
      getNearbyTrainStations();
    else if(selectedIndex==3) {
      //getTransitOptions();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Route Options'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:10),
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: selectedIndex,
                    onChanged: _handleRadioValueChange,
                  ),
                  Text('Bus',style: TextStyle(fontSize: 17),),
                  Radio(
                    value: 2,
                    groupValue: selectedIndex,
                    onChanged: _handleRadioValueChange,
                  ),
                  Text('Train',style: TextStyle(fontSize: 17),),
                  Radio(
                    value: 3,
                    groupValue: selectedIndex,
                    onChanged: _handleRadioValueChange,
                  ),
                  Text('Transit',style: TextStyle(fontSize: 17),),
                ],
              ),
            ),
            if(selectedIndex==1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blue[50],
                child: ListTile(
                  leading: const Icon(Icons.directions_bus_sharp),
                  title: Text(
                    '$bS',
                  ),
                  subtitle: Text('Bus Number:', style: TextStyle(fontStyle: FontStyle.italic),),
                  selected: true,
                  onTap: () {

                  },
                ),
              ),
            ),
            if(selectedIndex==2)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue[50],
                  child: ListTile(
                    leading: const Icon(Icons.train_outlined),
                    title: Text(
                      '$tS',
                    ),
                    subtitle: Text('Get down at _____' + ' station'),
                    selected: true,
                    onTap: () {

                    },
                  ),
                ),
              ),
            if(selectedIndex==3)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue[50],
                  child: ListTile(
                    leading: const Icon(Icons.directions),
                    title: const Text(
                      'Transit',
                    ),
                    subtitle: const Text('A >>>>> B && B >>>>> C'),
                    selected: true,
                    onTap: () {

                    },
                  ),
                ),
              ),
          ],
        ),

      ),
    );
  }
  void getNearbyTrainStations() async{
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$sourcelat,$sourcelong&radius=2000&type=train_station&key=$apiKey1');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      trainStations = jsonDecode(response.body.toString())['results'];
      setState(() {
        tS = trainStations[0] ['name'];
        // print(tS);
      });
    } else {
      bS= 'No nearby Train Stations';
      print('Failed to get nearest train station: ${response.statusCode}');
    }
  }
  void getNearbyBusStations() async{
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$sourcelat,$sourcelong&radius=2000&type=bus_station&key=$apiKey1');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      busStations = jsonDecode(response.body.toString())['results'];
      setState(() {
        bS = busStations[0] ['name'];
        //print(bS);
      });
    } else {
      bS= 'No nearby Bus Stations';
      print('Failed to get nearest bus station: ${response.statusCode}');
    }
  }
}
