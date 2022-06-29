import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class TestGoogleMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestGoogleMap();
}

class _TestGoogleMap extends State<TestGoogleMap> {
  late GoogleMapController _mapController;
  var _location;
  Marker _marker = Marker(markerId: MarkerId('Selected Location'));

  LatLng _mapCenter = const LatLng(0, 0);

  var _isSearchbarTapped = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      heightFactor: 0.3,
                      widthFactor: 2.5,
                      child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _mapCenter,
                            zoom: 17.0,
                          ),
                          markers: {_marker},
                          myLocationEnabled: true,
                          gestureRecognizers: Set()
                            ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer()))
                            ..add(Factory<ScaleGestureRecognizer>(
                                () => ScaleGestureRecognizer()))
                            ..add(Factory<TapGestureRecognizer>(
                                () => TapGestureRecognizer()))
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer()))))),
            ),
            Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: Column(children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          child: Icon(Icons.cancel,
                              size: MediaQuery.of(context).size.width * 0.09,
                              color: Colors.grey[600]),
                          onTap: () => Navigator.pop(context))),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03)),
                  GestureDetector(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                        child: Row(children: [
                          Icon(Icons.search,
                              size: MediaQuery.of(context).size.width * 0.06,
                              color: Colors.grey[600]),
                          Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.01)),
                          Text('식당, 카페를 검색해보세요.',
                              style: TextStyle(
                                  color: _isSearchbarTapped
                                      ? Colors.grey[200]
                                      : Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04))
                        ])),
                    onTapDown: (details) {
                      setState(() {
                        _isSearchbarTapped = true;
                      });
                    },
                    onTapUp: (details) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {
                          _isSearchbarTapped = false;
                        });
                        //Navigator.push(
                        //    context,
                        //    PageRouteBuilder(
                        //      pageBuilder: (context, animation1, animation2) =>
                        //          TestGoogleMapSearch(),
                        //      transitionDuration: Duration.zero,
                        //      reverseTransitionDuration: Duration.zero,
                        //    ));
                      });
                    },
                    onTapCancel: () {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {
                          _isSearchbarTapped = false;
                        });
                      });
                    },
                  ),
                ])),
          ])),
    ));
  }
}
