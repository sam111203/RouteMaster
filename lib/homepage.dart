import 'dart:async';

import 'package:authentication/prehomepage.dart';
import 'package:authentication/test.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'loginpage.dart';
Position? _currentLocation;
late bool servicePermission = false;
late LocationPermission permission;
TextEditingController startlat  = TextEditingController();
TextEditingController startlong  = TextEditingController();
double startlatitude =0.0;
double startlongitude = 0.0;
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(19.122273,72.917255),zoom: 14,);

  final Set<Marker> _markers = {};
  //final Set<Polyline> _polyline={};

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service Disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  late List<LatLng> latlng = [];
  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((position) {
      setState(() {
        _currentLocation = position;
        startlatitude = _currentLocation!.latitude ;
        startlongitude = _currentLocation!.longitude;
        _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        );
        latlng = [
          LatLng(startlatitude!, startlongitude!),
          LatLng(19.045450783843958, 72.841676266985),
        ];
        _markers.clear();
        for(int i=0;i<latlng.length;i++){
          if(i==0){
            _markers.add(
                Marker(markerId: MarkerId(i.toString()),
                  position: latlng[i],
                  infoWindow: InfoWindow(
                      title: 'My Start point',
                      snippet: 'Source'
                  ),
                  icon: BitmapDescriptor.defaultMarker,
                )
            );
          }
          else if(i==latlng.length-1){
            _markers.add(
                Marker(markerId: MarkerId(i.toString()),
                  position: latlng[i],
                  infoWindow: InfoWindow(
                      title: 'My End point',
                      snippet: 'Destination'
                  ),
                  icon: BitmapDescriptor.defaultMarker,
                )
            );
          }
          setState(() {

          });
          /*_polyline.add(
            Polyline(polylineId: PolylineId("1"),
                points: latlng,
                color: Colors.red,
                width: 3
            ),
          );*/
        }
      });
    });



  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                );
              }, icon: Icon(Icons.arrow_circle_left_outlined),
            ),
            actions: [
              Center(

                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Transit1(),
                        ),
                      );
                    },
                    child: Text("Choose best transit options")),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              markers: _markers,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              // polylines: _polyline,
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
            ),
          )
        ],
      ),
    );
  }
}
