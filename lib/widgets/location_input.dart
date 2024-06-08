import 'dart:convert';

import 'package:camera/models/place.dart';
import 'package:camera/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../consts.dart';
class LocationInput extends StatefulWidget {
  const LocationInput({super.key,required this.onSelectLocation});
  final void Function(PlaceLocation location) onSelectLocation;
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage{
    if(_pickedLocation == null){
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=17&size=600x300&maptype=roadmap &markers=color:blue%7Clabel:A%7C$lat,$lng&key=$api_key';
  }

  void _getCurrentLocation() async {

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if(lat == null || lng == null){
      return;
    }
    _savePlace(lat, lng);
  }
  void _savePlace(double lat,double lng) async{
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyBZwnt2gpb8HDSnGd_aSaOZKh39SSQPMDc');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final address = data['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isGettingLocation = false;
    });
    widget.onSelectLocation(_pickedLocation!);

  }
  void _selectOnMap() async{
    final pickedLocation = await Navigator.push<LatLng>(context, MaterialPageRoute(builder: (ctx) => const MapScreen()));
    if(pickedLocation==null){
      return;
    }
  _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text('No location chosen',textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),);
    if(_isGettingLocation){
      previewContent = const CircularProgressIndicator();
    }

    if(_pickedLocation !=null){
      previewContent = Image.network(locationImage,fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.8))),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Get on Map'),
              onPressed: _selectOnMap,
            )
          ],
        )
      ],
    );
  }
}
