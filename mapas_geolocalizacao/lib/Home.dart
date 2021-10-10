import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng(-23.706150624867185, -46.688411752494154),
      zoom: 18,
      tilt: 30,
      bearing: 30);
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
          _posicaoCamera
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

  _recuperarLocalizacaoAtual() async{
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
          tilt: 30,
          bearing: 30);
      _movimentarCamera();
    });

    //print("Localização atual: ${position}");
  }

  _adicionarListenerLocalizacao(){
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );
    geolocator.getPositionStream(locationOptions).listen((position) {
      Marker marcadorUsuario = Marker(
          markerId: MarkerId("marcador-usuário"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
              title: "Meu Local"
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta
          ),
          rotation: 45,
          onTap: (){
            print("Meu Local");
          }
      );
      setState(() {
        _marcadores.add(marcadorUsuario);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18,
            tilt: 30,
            bearing: 30);
        _movimentarCamera();
      });
    });
  }

  _recuperarLocalParaEndereco() async{
    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromAddress("Av. Paulista, 1372");
    print("Total: ${listaEnderecos.length}");
    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];
      String resultado;
      resultado = "\n administrativeArea ${endereco.administrativeArea}"
          "\n subAdministrativeArea ${endereco.subAdministrativeArea}"
          "\n locality ${endereco.locality}"
          "\n subLocality ${endereco.subLocality}"
          "\n thoroughfare ${endereco.thoroughfare}"
          "\n subThoroughfare ${endereco.subThoroughfare}"
          "\n postalCode ${endereco.postalCode}"
          "\n country ${endereco.country}"
          "\n isoCountryCode ${endereco.isoCountryCode}"
          "\n position ${endereco.position}";

      print("Resultado: ${resultado}");
    }
  }

  _recuperarLocalParaLatLong() async{
    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromCoordinates(-23.562515598559266, -46.654716073262186);

    print("Total: ${listaEnderecos.length}");
    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];
      String resultado;
      resultado = "\n administrativeArea ${endereco.administrativeArea}"
          "\n subAdministrativeArea ${endereco.subAdministrativeArea}"
          "\n locality ${endereco.locality}"
          "\n subLocality ${endereco.subLocality}"
          "\n thoroughfare ${endereco.thoroughfare}"
          "\n subThoroughfare ${endereco.subThoroughfare}"
          "\n postalCode ${endereco.postalCode}"
          "\n country ${endereco.country}"
          "\n isoCountryCode ${endereco.isoCountryCode}"
          "\n position ${endereco.position}";

      print("Resultado: ${resultado}");
    }
  }

  @override
  void initState() {
    //_carregarMarcadores();
    //_recuperarLocalizacaoAtual();
    //_adicionarListenerLocalizacao();
    // _recuperarLocalParaEndereco();
    _recuperarLocalParaLatLong();
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
          zoom: 18
        ),
        onMapCreated: _onMapCreated,
        markers: _marcadores,
        //polygons: _polygons,
        //polylines: _polylines,
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
