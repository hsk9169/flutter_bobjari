import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:animations/animations.dart';
import 'package:bobjari_proj/screens/screens.dart';
import 'package:bobjari_proj/routes/routes.dart';

class ServiceView extends StatefulWidget {
  final int selected;
  final int? subSelected;
  const ServiceView({Key? key, required this.selected, this.subSelected});
  @override
  State<StatefulWidget> createState() => _ServiceView();
}

class _ServiceView extends State<ServiceView> {
  late int _selected;

  @override
  void initState() {
    _selected = widget.selected;
    super.initState();
  }

  Widget? _bodyWidget(int _index, dynamic _session) {
    switch (_index) {
      case 0:
        return MainView(session: _session);
      case 1:
        return BobView(session: _session, tabNum: widget.subSelected ?? 0);
      case 2:
        return MypageView(session: _session);
      default:
        break;
    }
  }

  void _onItemTapped(int sel) {
    if (sel > 0 &&
        Provider.of<Session>(context, listen: false).user.userId == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeView()),
        (Route<dynamic> route) => false,
      );
    }
    setState(() {
      _selected = sel;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _session = Provider.of<Session>(context, listen: false);
    return Scaffold(
      body: SafeArea(
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
              child: _bodyWidget(_selected, _session)))),
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
