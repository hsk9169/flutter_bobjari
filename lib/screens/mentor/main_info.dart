import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/etc.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';

class MainInfoView extends StatelessWidget {
  final MentorModel mentor;
  const MainInfoView({required this.mentor});

  @override
  Widget build(BuildContext context) {
    final _userDetail = mentor.userDetail;
    final _career = mentor.career;
    final _details = mentor.details;
    final _metadata = mentor.metadata;
    final _rate = _metadata!.rate!.num != 0
        ? (_metadata.rate!.score! / _metadata.rate!.num!).toStringAsFixed(1)
        : '0.0';

    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_career!.job!,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.003)),
                        Text(_userDetail!.profile!.nickname!,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.005)),
                        Text(
                            mentor.career!.years != null
                                ? Etc.careerYear[_career.years!] +
                                    ' ' +
                                    String.fromCharCode(0x00B7) +
                                    ' ' +
                                    _career.company!
                                : '',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.025)),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            Uri.parse(_userDetail.profile!.profileImage!.data!)
                                        .data !=
                                    null
                                ? Image.memory(
                                        Uri.parse(_userDetail
                                                .profile!.profileImage!.data!)
                                            .data!
                                            .contentAsBytes(),
                                        gaplessPlayback: true)
                                    .image
                                : const AssetImage('assets/images/dog.png'),
                        fit: BoxFit.cover,
                      ),
                    ))
              ],
            ),
            Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Icon(Icons.location_on_outlined,
                      size: MediaQuery.of(context).size.width * 0.1),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01)),
                  Text('강남/송파',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.bold))
                ]),
                Column(children: [
                  Icon(Icons.access_time,
                      size: MediaQuery.of(context).size.width * 0.1),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01)),
                  Text('금 토 일',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.bold))
                ]),
                Column(children: [
                  Icon(Icons.star_border,
                      size: MediaQuery.of(context).size.width * 0.1),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01)),
                  Text(_rate + '점(' + mentor.review!.length.toString() + ')',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.bold))
                ]),
                Column(children: [
                  Icon(Icons.rice_bowl_outlined,
                      size: MediaQuery.of(context).size.width * 0.1),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01)),
                  Text(_metadata.numBobjari.toString() + '회',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.bold))
                ]),
              ],
            )
          ],
        ));
  }
}
