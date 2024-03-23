import 'dart:async';

import 'package:authentication/firebase_options.dart';
import 'package:authentication/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //runApp(const LoginPage());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      //home: CheckUser(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(19.122273,72.917255),zoom: 14,);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline={};

  List<LatLng> latlng = [
    LatLng(19.122273,72.917255),
    LatLng(19.045450783843958, 72.841676266985),
  ];

   TextEditingController source = TextEditingController();
  TextEditingController destination = TextEditingController();
  String s = '';
  String d = '';
  @override
  void initState() {
    super.initState();
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
      _polyline.add(
        Polyline(polylineId: PolylineId("1"),
            points: latlng,
          color: Colors.red,
          width: 3
        ),
      );
    }

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
                    builder: (BuildContext context) => LoginPage(),
                  ),
                );
              }, icon: Icon(Icons.arrow_circle_left_outlined),
            ),
            actions: [
              Center(

            child: ElevatedButton(
                onPressed: (){
                  showDialog(context: context, builder: (context)=>
                      AlertDialog(
                        title: Text('Enter source and destination'),
                        actions: [

                          ElevatedButton(
                              onPressed: (){
                                setState(() {

                                });

                                //Navigator.pop(context);
                              },
                              child: Text('Go!'))
                        ],
                      ),
                  );
                },
                child: Text("Choose where to go")),
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
              polylines: _polyline,
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
            ),
          )
        ],
      ),
    );
  }
}
