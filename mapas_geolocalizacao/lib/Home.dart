import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //-23.701617847651825, -46.69866983421911
  //-23.706150624867185, -46.688411752494154 estacao
  //-23.706360904523923, -46.70196160567839 hospital
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores ={};

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(-23.706150624867185, -46.688411752494154),
              zoom: 15,
              tilt: 30,
              bearing: 30
          )
      )
    );
  }

  _carregarMarcadores(){
    Set<Marker> marcadoresLocal ={};
    Marker marcadorEstacao = Marker(
      markerId: MarkerId("marcador-estacao"),
      position: LatLng(-23.706150624867185, -46.688411752494154),
      infoWindow: InfoWindow(
        title: "Estação Autódromo"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueMagenta
      ),
      rotation: 45,
      onTap: (){
        print("Estação clicado");
      }
    );

    Marker marcadorHospital = Marker(
        markerId: MarkerId("marcador-hospital"),
        position: LatLng(-23.706360904523923, -46.70196160567839),
        infoWindow: InfoWindow(
            title: "Hospital Maternidade Interlagos"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue
        ),
        onTap: (){
          print("Hospital clicado");
        }
    );

    marcadoresLocal.add(marcadorEstacao);
    marcadoresLocal.add(marcadorHospital);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  @override
  void initState() {
    _carregarMarcadores();
    super.initState();
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
              -23.706150624867185, -46.688411752494154
          ),
          zoom: 15
        ),
        onMapCreated: _onMapCreated,
        markers: _marcadores,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
