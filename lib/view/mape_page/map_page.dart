import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lostandfound/controller/post_controller.dart';

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // GetcurrentLocationController getcurrentLocationController =
  //     Get.put(GetcurrentLocationController());

  Completer<GoogleMapController> _controller = Completer();
  // List<Marker> marker = [];
  BitmapDescriptor? customIcon;
  late final CameraPosition? kGooglePlex;
  // List<Marker> lsit = [
  //   const Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(28.2977402, 70.0962805),
  //       infoWindow: InfoWindow(title: 'My Position')),
  // ];

  // void setCustomMarker() async {
  //   customIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 1), 'images/location_1.jpg');
  // }

  @override
  void initState() {
    kGooglePlex = const CameraPosition(
      target: LatLng(32.777736, 35.021626),
      zoom: 14.4746,
    );
    //setCustomMarker();

    //marker.addAll(lsit);

    // marker = [
    //   Marker(
    //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    //       markerId: MarkerId('1'),
    //       position: LatLng(28.290215300829235, 70.13812322169542),
    //       infoWindow: InfoWindow(title: 'My Position')),
    //   Marker(
    //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //       markerId: MarkerId(
    //         '2',
    //       ),
    //       position: LatLng(28.297741928087504, 70.09636290371418),
    //       infoWindow: InfoWindow(title: 'Buyer Location')),
    // ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PostController>(
          init: Get.put(PostController()),
          builder: (con) {
            return GoogleMap(
              markers: Set<Marker>.of(con.getMarker),
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }),
    );
  }
}
