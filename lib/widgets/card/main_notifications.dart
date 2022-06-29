import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';

class NotificationCard extends StatelessWidget {
  final Widget? child;
  final Color? color;
  const NotificationCard({
    Key? key,
    this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: child,
        ));
  }
}

class BobGuidesCard extends StatelessWidget {
  static String title = '밥자리\n이렇게 하는겁니다.';
  static String link = '지금 보러가기';

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
        color: BobColors.mainColor,
        child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.005)),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_forward,
                      size: MediaQuery.of(context).size.height * 0.016,
                      color: Colors.white),
                  const Padding(padding: EdgeInsets.all(0.5)),
                  Text(link,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.016,
                          fontWeight: FontWeight.normal,
                          color: Colors.white))
                ])
          ]),
          Row(children: [
            Padding(
                padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.01,
            )),
            Container(
              alignment: Alignment.centerRight,
              width: (MediaQuery.of(context).size.height) * 0.12,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/dog.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          ]),
        ]));
  }
}

class BobRulesCard extends StatelessWidget {
  static String title = '밥자리 강령 10조.';
  AssetImage cat = const AssetImage('assets/images/cat.png');
  AssetImage dog = const AssetImage('assets/images/dog.png');

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
        color: Colors.greenAccent,
        child: Text(title,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.white)));
  }
}
