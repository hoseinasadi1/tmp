import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lostandfound/controller/post_controller.dart';
import 'package:lostandfound/model/post_model.dart';

class ShowMap extends StatefulWidget {
  ShowMap({Key? key, required this.postModel}) : super(key: key);

  PostModel postModel;

  @override
  State<ShowMap> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<ShowMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> marker = [];
  BitmapDescriptor? customIcon;
  late final CameraPosition? kGooglePlex;

  @override
  void initState() {
    kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.postModel.lat!),
          double.parse(widget.postModel.lng!)),
      zoom: 14.4746,
    );
    //setCustomMarker();

    //marker.addAll(lsit);

    marker = [
      Marker(
          icon: widget.postModel.objectType == 'Found'
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          markerId: MarkerId('1'),
          onTap: ()=>{print("yesssssssss")},
          position: LatLng(double.parse(widget.postModel.lat!),
              double.parse(widget.postModel.lng!)),
          //infoWindow: InfoWindow(title: widget.postModel.postTitle!)
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      markers: Set<Marker>.of(marker),
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex!,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ));
  }
}
