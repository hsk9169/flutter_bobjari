import 'package:flutter/material.dart';

class TopBarSearch extends StatelessWidget {
  final Function press;
  final Widget search;

  const TopBarSearch({
    Key? key,
    required this.press,
    required this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: Colors.black,
        onPressed: () {
          press();
        },
      ),
      Spacer(),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(child: search),
      ),
      Spacer()
    ]);
  }
}
