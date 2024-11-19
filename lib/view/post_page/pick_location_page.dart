import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lostandfound/controller/post_controller.dart';
import 'package:lostandfound/view/widgets/primary_button.dart';

// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as webGM;

class MapPicker extends StatefulWidget {
  static const DEFAULT_ZOOM = 14.4746;
  static const KINSHASA_LOCATION = LatLng(32.777736, 35.021626);

  double initZoom;
  LatLng initCoordinates;

  LatLng? value;

  MapPicker(
      {Key? key,
      this.initZoom = DEFAULT_ZOOM,
      this.initCoordinates = KINSHASA_LOCATION})
      : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  PostController postController = Get.put(PostController());
  final Completer<GoogleMapController> _controller = Completer();
  String location = 'Null, Press Button';
  String address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    postController.pickOrLostLocation.value = address;

    print(' ===================== address $address');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              // width: 400,
              height: 500,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var maxWidth = constraints.biggest.width;
                  var maxHeight = constraints.biggest.height;

                  return Stack(
                    children: <Widget>[
                      SizedBox(
                        height: maxHeight,
                        width: maxWidth,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: widget.initCoordinates,
                            zoom: widget.initZoom,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onCameraMove: (CameraPosition newPosition) {
                            print('sdf ${newPosition.target.toJson()}');
                            widget.value = newPosition.target;
                            postController.lat = newPosition.target.latitude;
                            postController.lng = newPosition.target.longitude;
                            print(
                                'acutal  lat is  ${newPosition.target.latitude}');
                          },
                          onCameraIdle: () {
                            print('exact lat is  ${postController.lat}');
                            getAddressFromLatLong(
                                postController.lat, postController.lng);
                          },
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: false,
                          zoomGesturesEnabled: true,
                          padding: const EdgeInsets.all(0),
                          buildingsEnabled: true,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          compassEnabled: true,
                          indoorViewEnabled: false,
                          mapToolbarEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          trafficEnabled: false,
                        ),
                      ),
                      Positioned(
                        bottom: maxHeight / 2,
                        right: (maxWidth - 30) / 2,
                        child: const Icon(
                          Icons.person_pin_circle,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 30,
                        child: Container(
                          color: Colors.white,
                          child: IconButton(
                            onPressed: () async {
                              var position = await _getGeoLocationPosition();
                              final GoogleMapController controller =
                                  await _controller.future;
                              getAddressFromLatLong(
                                  position.latitude, position.longitude);
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(position.latitude,
                                          position.longitude),
                                      zoom: widget.initZoom)));
                            },
                            icon: const Icon(Icons.my_location),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // ElevatedButton(onPressed: () {}, child: Text('Confirm'))
            PrimaryButtion(
              buttonText: 'Confirm',
              onPressed: () {
                Get.back();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
