import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //-23.701617847651825, -46.69866983421911
  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              -23.701617847651825,
              -46.69866983421911
          ),
          zoom: 16
        ),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
