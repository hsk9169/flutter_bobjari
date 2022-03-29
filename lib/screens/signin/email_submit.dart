import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/screens/screens.dart';

class EmailSubmitView extends StatefulWidget {
  const EmailSubmitView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailSubmitView();
}

class _EmailSubmitView extends State<EmailSubmitView> {
  final RealApiService _realApiService = RealApiService();

  late TextEditingController _textController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'mentee@test.com');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitEmail(BuildContext context) async {
    String _email = _textController.text;
    final _res = await _realApiService.authEmail(_email);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignInBobView(email: _email, authNum: _res)));
  }

  void _uploadImage(ImageSource source, BuildContext context) async {
    XFile? _imgFile = await _picker.pickImage(
      source: source,
    );
    Uint8List? _imgBytes = await _imgFile?.readAsBytes();
    String _imgBase64 = base64.encode(_imgBytes as Uint8List);
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(children: [
                      TopBarBack(press: _goBack),
                      BasePadding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Padding(padding: EdgeInsets.all(15)),
                            const TopTitle(
                                titleText: ['등록된 이메일로', '인증번호를 요청해주세요.']),
                            const Padding(padding: EdgeInsets.all(10)),
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: 'example@bobjari.com'),
                              controller: _textController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      )
                    ])))),
        bottomSheet: BasePadding(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BigButton(
                        btnColor: Colors.black,
                        title: '인증번호 요청',
                        txtColor: Colors.white,
                        press: () {
                          _submitEmail(context);
                        })))));
  }
}
