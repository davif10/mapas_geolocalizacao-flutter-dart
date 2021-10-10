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
  Set<Polygon> _polygons ={};
  Set<Polyline> _polylines ={};


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
    
    Set<Polygon> listaPolygons ={};
    Polygon polygon = Polygon(
        polygonId: PolygonId("polygon1"),
      fillColor: Colors.green,
      strokeColor: Colors.red,
      strokeWidth: 10,
      points: [
        LatLng(-23.701617847651825, -46.69866983421911),
        LatLng(-23.706150624867185, -46.688411752494154),
        LatLng(-23.706360904523923, -46.70196160567839)
      ],
      consumeTapEvents: true,
      onTap: (){
          print("Clicado na área.");
      },
      zIndex: 0 //Define prioridade de exibição
    );
    listaPolygons.add(polygon);

    Set<Polyline> listaPolylines ={};
    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline"),
      color: Colors.amber,
      width: 15,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.bevel,
      consumeTapEvents: true,
      points: [
        LatLng(-23.707070872325318, -46.68928769901425),
        LatLng(-23.711399309581363, -46.69870649898201),
        LatLng(-23.707896921057046, -46.705093961029114)
      ],
      onTap: (){
          print("Clicado na linha!");
      }
    );
    listaPolylines.add(polyline);
    setState(() {
      _marcadores = marcadoresLocal;
      _polygons = listaPolygons;
      _polylines = listaPolylines;
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
        polygons: _polygons,
        polylines: _polylines,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
