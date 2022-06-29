import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/preference/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/propose_provider.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import './test_google_map.dart';
import './proposal_check.dart';
import 'package:bobjari_proj/routes/routes.dart';

class LocationCheckView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationCheckView();
}

class _LocationCheckView extends State<LocationCheckView> {
  late GoogleMapController _mapController;
  Marker _marker = Marker(markerId: MarkerId('Selected Location'));

  LatLng _mapCenter = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  List<LocationModel> _availableLocation = [];
  List<int> _checkList = [];
  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _initializeData() async {
    setState(() {
      Provider.of<Propose>(context, listen: false)
          .mentorDetails
          .details!
          .preference!
          .location!
          .forEach((el) {
        _availableLocation.add(el);
      });
      _checkList = Provider.of<Propose>(context, listen: false).locationCheck;
    });
  }

  void _goBack() {
    Provider.of<Propose>(context, listen: false).location = _checkList;
    Navigator.pop(context);
  }

  void _goNext() {
    Provider.of<Propose>(context, listen: false).location = _checkList;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProposalCheckView();
    }));
  }

  void _onSelect(int selIdx) {
    if (_checkList.contains(selIdx)) {
      setState(() {
        _checkList.remove(selIdx);
      });
    } else {
      _mapCenter = LatLng(
          double.parse(_availableLocation[selIdx].geolocation.y),
          double.parse(_availableLocation[selIdx].geolocation.x));
      _marker = Marker(
        markerId: MarkerId(_availableLocation[selIdx].placeName),
        position: _mapCenter,
        infoWindow: InfoWindow(
          title: _availableLocation[selIdx].placeName,
          snippet: _availableLocation[selIdx].addressName,
        ),
      );
      _openMapCheck(selIdx);
    }
  }

  void _onPressCancel() {
    Provider.of<Propose>(context, listen: false).flush();
    Navigator.popUntil(context, ModalRoute.withName(Routes.MENTOR_DETAILS));
  }

  void _openMapCheck(int selIdx) {
    var _location = _availableLocation[selIdx];
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (BuildContext context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
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
                                          ..add(Factory<
                                                  VerticalDragGestureRecognizer>(
                                              () =>
                                                  VerticalDragGestureRecognizer()))))),
                          ),
                          Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.05),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  child: Icon(Icons.cancel,
                                      size: MediaQuery.of(context).size.width *
                                          0.09),
                                  onTap: () => Navigator.pop(context)))
                        ])),
                Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_location.placeName,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false),
                          Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.005)),
                          Text(_location.addressName,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false),
                        ])),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: BigButton(
                        btnColor: Colors.black,
                        title: '선택',
                        txtColor: Colors.white,
                        press: () {
                          setState(() {
                            _checkList.add(selIdx);
                          });
                          Navigator.pop(context);
                        }))
              ]));
        });
  }

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBackContents(
              pressBack: _goBack,
              title: '',
              icon1: Icon(Icons.cancel,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.08),
              pressIcon1: _onPressCancel,
              bottomLine: false,
              backgroundColor: Colors.black,
            )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Text('직업인에게 제안할\n장소를 선택해주세요.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: MediaQuery.of(context).size.height * 0.0018))),
          Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: MediaQuery.of(context).size.width * 0.04,
                  runSpacing: MediaQuery.of(context).size.height * 0.02,
                  children: List<Widget>.generate(_availableLocation.length,
                      (idx) => _locationCard(_availableLocation[idx], idx))))
        ]),
        bottomSheet: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.08,
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: BigButton(
                    btnColor: Colors.black,
                    title: '다 음',
                    txtColor: Colors.white,
                    press: () {
                      _goNext();
                    }))));
  }

  Widget _locationCard(LocationModel location, int index) {
    return GestureDetector(
        onTap: () => _onSelect(index),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.43,
            alignment: Alignment.center,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
                border: Border.all(
                  color:
                      _checkList.contains(index) ? Colors.black : Colors.grey,
                  width: MediaQuery.of(context).size.width * 0.006,
                ),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  child: Icon(Icons.location_on_outlined,
                      size: MediaQuery.of(context).size.width * 0.07,
                      color: _checkList.contains(index)
                          ? Colors.black
                          : Colors.grey)),
              Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.03)),
              Text(location.placeName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false),
              Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.003)),
              Text(location.addressName,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false),
            ])));
  }
}
