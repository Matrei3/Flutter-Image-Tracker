import 'package:camera/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key,this.location = const PlaceLocation(latitude: 47.18333330, longitude: 23.05000000, address: ''),this.isSelecting = true});
  final PlaceLocation location;
  final isSelecting;
  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
  
}

class _MapScreenState extends State<MapScreen>{
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'), actions: [
        if(widget.isSelecting)
          IconButton(onPressed: (){
            Navigator.pop(context,_pickedLocation);
          } , icon: const Icon(Icons.save))
      ],) ,
      body: GoogleMap(
        onTap: !widget.isSelecting ? null : (position){
          setState(() {
            _pickedLocation = position;
          });
        },
        markers: (_pickedLocation==null && widget.isSelecting) ? {} : {
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation ?? LatLng(widget.location.latitude,widget.location.longitude)
          )
        },
        initialCameraPosition: CameraPosition(target: LatLng(widget.location.latitude,widget.location.longitude),zoom: 16),
      ),
    );
  }

}