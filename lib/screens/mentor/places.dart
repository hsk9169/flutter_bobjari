import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/preference/location.dart';

class PlacesView extends StatefulWidget {
  final List<LocationModel>? places;
  const PlacesView({this.places});
  @override
  State<StatefulWidget> createState() => _PlacesView();
}

class _PlacesView extends State<PlacesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('장소',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold)),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
          Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: MediaQuery.of(context).size.width * 0.04,
              runSpacing: MediaQuery.of(context).size.height * 0.02,
              children: List<Widget>.generate(
                  widget.places!.length, (idx) => _chip(idx)))
        ]));
  }

  Widget _chip(int _idx) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.43,
        child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(children: [
              Container(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.location_on_outlined,
                      color: Colors.amber[300],
                      size: MediaQuery.of(context).size.width * 0.07)),
              Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.01)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.places![_idx].placeName,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.places![_idx].addressName,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.normal),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false)),
            ])));
  }
}
