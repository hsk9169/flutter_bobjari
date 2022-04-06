import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/screens/screens.dart';
import 'package:bobjari_proj/widgets/base_scroller.dart';

class ServiceView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServiceView();
}

class _ServiceView extends State<ServiceView> {
  int _selected = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MainView(),
    BobView(),
    MypageView(),
  ];

  void _onItemTapped(int sel) {
    setState(() {
      _selected = sel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScroller(
      child: BasePadding(
          child: (PageTransitionSwitcher(
        transitionBuilder: (
          child,
          animation,
          secondaryAnimation,
        ) {
          return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child);
        },
        child: _widgetOptions.elementAt(_selected),
      ))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rice_bowl),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selected,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 28),
        unselectedIconTheme:
            IconThemeData(color: Colors.black.withOpacity(0.35), size: 25),
      ),
    );
  }
}
