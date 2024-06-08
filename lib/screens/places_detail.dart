import 'package:camera/consts.dart';
import 'package:camera/screens/map.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';

class PlaceDetailScreen extends StatelessWidget{
  const PlaceDetailScreen({super.key,required this.place});
  final Place place;
  String get locationImage{
    final lat = place.placeLocation.latitude;
    final lng = place.placeLocation.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=17&size=600x300&maptype=roadmap &markers=color:blue%7Clabel:A%7C$lat,$lng&key=$api_key';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title),),
      body: Stack(
        children: [
          Image.file(place.image,fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
          Positioned(bottom: 0,left: 0,right: 0,child: Column(
            children: [
              GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => MapScreen(location: place.placeLocation,isSelecting: false,)));
              }, child: CircleAvatar(radius: 70,backgroundImage: NetworkImage(locationImage),)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter, colors: [Colors.transparent,Colors.black54])
                ),
                alignment: Alignment.center,
                child: Text(textAlign: TextAlign.center, place.placeLocation.address, style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),)),
            ],
          ),)
        ],
      )
    );
  }

}