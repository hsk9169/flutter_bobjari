import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/const/etc.dart';

class MentorSearchCard extends StatelessWidget {
  final MentorModel mentor;
  //final Function? pressClear;

  const MentorSearchCard({
    Key? key,
    required this.mentor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    flex: 4,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Uri.parse(mentor.userDetail!.profile!
                                            .profileImage!.data!)
                                        .data !=
                                    null
                                ? Image.memory(Uri.parse(mentor.userDetail!
                                            .profile!.profileImage!.data!)
                                        .data!
                                        .contentAsBytes())
                                    .image
                                : const AssetImage('assets/images/dog.png'),
                            fit: BoxFit.cover,
                          ),
                        ))),
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 20,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [
                                Text(mentor.userDetail!.profile!.nickname!,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false),
                                Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.008)),
                                Icon(Icons.star,
                                    size: MediaQuery.of(context).size.width *
                                        0.035,
                                    color: Colors.deepOrange),
                                Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.003)),
                                Text(
                                    mentor.metadata!.rate!.num! == 0
                                        ? '0.0'
                                        : mentor.metadata!.rate!.score
                                            .toString(),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        color: Colors.grey)),
                                Text(
                                    '(' +
                                        mentor.metadata!.rate!.num.toString() +
                                        ')',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        color: Colors.grey))
                              ]),
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          0.005)),
                              Text(mentor.career!.job!,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false),
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          0.005)),
                              Text(
                                  Etc.careerYear[mentor.career!.years!] +
                                      ' ' +
                                      String.fromCharCode(0x00B7) +
                                      ' ' +
                                      mentor.career!.company!,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      fontWeight: FontWeight.normal),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false),
                            ])))
              ])),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01)),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(mentor.title!,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false)))),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01)),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Row(children: []),
                Spacer(),
                Row(children: [
                  Text(
                      mentor.details!.preference!.fee!.select == 0
                          ? mentor.details!.preference!.fee!.value + '원'
                          : mentor.details!.preference!.fee!.select == 1
                              ? '식사 대접'
                              : '커피 대접',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold)),
                  Text(
                      mentor.details!.preference!.fee!.select == 0 ? '/1h' : '',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.normal))
                ])
              ]))
        ]));
  }
}
