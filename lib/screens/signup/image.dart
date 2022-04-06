import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/screens/signup/role.dart';
import 'package:bobjari_proj/const/colors.dart';

enum Select { myImage, basicImage }

class SignupProfileImageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupProfileImageView();
}

class _SignupProfileImageView extends State<SignupProfileImageView> {
  final ImagePicker _picker = ImagePicker();
  String? _image;
  Image? _imageDisplay;
  AssetImage dog = const AssetImage('assets/images/dog.png');
  late String? dogBase64;

  @override
  void initState() async {
    super.initState();
    dogBase64 = await _loadAssetImage('assets/images/dog.png');
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _uploadImage(ImageSource source, BuildContext context) async {
    XFile? _imgFile = await _picker.pickImage(
      source: source,
      maxHeight: MediaQuery.of(context).size.width * 0.5,
      maxWidth: MediaQuery.of(context).size.width * 0.5,
    );
    Uint8List? _imgBytes = await _imgFile?.readAsBytes();
    setState(() {
      _imageDisplay = Image.memory(_imgBytes!);
      _image = base64.encode(_imgBytes);
    });
  }

  void _refresh() {
    setState(() {
      _image = null;
      _imageDisplay = null;
    });
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext() {
    print(dogBase64);
    print(dogBase64.runtimeType);
    Provider.of<Signup>(context, listen: false).image =
        _image ?? dogBase64 as String;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignupProfileRoleView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Signup>(context).show();
    return SignupForm(
        topTitle: const ['프로필 사진을 등록해주세요.', ''],
        child: Center(
            child: Column(children: [
          const Padding(padding: EdgeInsets.all(20)),
          Container(
            alignment: Alignment.bottomRight,
            width: (MediaQuery.of(context).size.width) * 0.5,
            height: (MediaQuery.of(context).size.width) * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                )
              ],
              image: DecorationImage(
                image: _imageDisplay?.image ?? dog,
                fit: BoxFit.cover,
              ),
            ),
            child: IconButton(
                icon:
                    const Icon(Icons.camera_alt, color: Colors.grey, size: 45),
                onPressed: () {
                  _uploadImage(ImageSource.gallery, context);
                }),
          ),
          const Padding(padding: EdgeInsets.all(20)),
          ElevatedButton(
            onPressed: _refresh,
            style: ElevatedButton.styleFrom(
              primary: BobColors.mainColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.transparent),
              ),
            ),
            child: const Text('초기화',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          )
        ])),
        btnTitle: '다 음',
        pressBack: _pressBack,
        pressNext: _pressNext);
  }
}

Future<String>? _loadAssetImage(String path) async {
  final bytes = await rootBundle.load(path);
  var buffer = bytes.buffer;
  String? ret = base64.encode(Uint8List.view(buffer));
  return ret;
}
