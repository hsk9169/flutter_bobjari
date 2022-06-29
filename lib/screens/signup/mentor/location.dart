import 'dart:async';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bobjari_proj/services/kakao_service.dart';
import 'package:bobjari_proj/models/kakao_map_model.dart';
import 'package:bobjari_proj/screens/signup/mentor/auth.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupMentorLocationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorLocationView();
}

class _SignupMentorLocationView extends State<SignupMentorLocationView> {
  final KakaoService _kakaoService = KakaoService();
  late ScrollController _selectListScrollController;
  late ScrollController _searchListScrollController;
  final TextEditingController _textController = TextEditingController();
  late FocusNode _textFocusNode;
  //late GooglePlace _googlePlace;
  //late FakeGoogleService _fakeGoogleService = FakeGoogleService();
  //List<AutocompletePrediction> predictions = [];
  final String _kakaoApiKey = dotenv.env['KAKAO_JAVASCRIPT_KEY']!;
  String _query = '';
  //ValueNotifier<List<PlaceModel>> _suggestionList =
  //    ValueNotifier<List<PlaceModel>>([]);
  //String _sessionToken = '';
  List<PlaceModel> _locationList = [];
  List<PlaceModel> _selLocation = [];
  //late GoogleMapController _mapController;
  //Marker _marker = Marker(markerId: MarkerId('Selected Location'));
  //LatLng _mapCenter = const LatLng(0, 0);
  var _isSearchbarTapped = false;
  //Timer? _timer;
  ValueNotifier<bool> _isModalCloseTapped = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isItemTapped = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isUrlTapped = ValueNotifier<bool>(false);
  ValueNotifier<int> _selected = ValueNotifier<int>(-1);
  ValueNotifier<double> _mapHeight = ValueNotifier<double>(0);
  ValueNotifier<bool> _isSearched = ValueNotifier<bool>(false);
  ValueNotifier<int> _selIdx = ValueNotifier<int>(-1);
  bool _found = false;
  late WebViewController _mapController;

  @override
  void initState() {
    //_initPosition();
    //String _apiKey = dotenv.env['GOOGLE_API_KEY']!;
    //_googlePlace = GooglePlace(_apiKey);
    _selectListScrollController = ScrollController();
    _searchListScrollController = ScrollController();
    _textController.addListener(_onChanged);
    _textFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _selectListScrollController.dispose();
    _searchListScrollController.dispose();
    //_mapController.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    //_timer?.cancel();
    super.dispose();
  }

  void _onChanged() async {
    //if (_textController.text == '') {
    //  setState(() {
    //    _sessionToken = Uuid().v4();
    //  });
    //}
    //if (_textController.text != _query) {
    setState(() {
      _query = _textController.text;
      //_query = '카카오 제주';
      //_suggestionList.value = [];
    });

    //_timer?.cancel();
    //_getSuggestions();
    //}
  }

  //void _onItemSelected(SuggestionModel selVal) async {
  //  setState(() {
  //    _locationList.add(selVal);
  //  });
  //  final placeDetails =
  //      //await GoogleService().getPlaceDetailsFromId(selVal.placeId!);
  //      await _fakeGoogleService.getPlaceDetailsFromId(selVal.placeId!);
  //  print(placeDetails.toJson());
  //}

  void _onItemSelected(int idx) {
    _selIdx.value = idx;
    var _lat = _locationList[idx].geolocation!.y;
    var _lng = _locationList[idx].geolocation!.x;
    _mapController.runJavascript('''
        moveLatLon = new kakao.maps.LatLng($_lat - 0.002, $_lng);
        map.panTo(moveLatLon);
      ''');
  }

  void _onTapSearch() async {
    List<double> _lat = [];
    List<double> _lng = [];
    _locationList.forEach((el) {
      _lat.add(double.parse(el.geolocation!.y));
      _lng.add(double.parse(el.geolocation!.x));
    });
    _mapController.runJavascript('''
      for (let i=0; i<markers.length; i++) {
        markers[i].setMap(null);
      }
    ''');
    _mapHeight.value = MediaQuery.of(context).size.height * 0.6;
    final result = await _kakaoService.searchPlaceByKeyword(_query);
    _isSearched.value = true;
    _lat = [];
    _lng = [];
    setState(() {
      _locationList = result;
      _found = true;
    });
    _selIdx.value = -1;

    _locationList.forEach((el) {
      _lat.add(double.parse(el.geolocation!.y));
      _lng.add(double.parse(el.geolocation!.x));
    });
    _mapController.runJavascript('''
        if ($_lat.length > 0) {
          moveLatLon = new kakao.maps.LatLng($_lat[0] - 0.002, $_lng[0]);
          map.panTo(moveLatLon);
          for (let i=0; i<$_lat.length; i++) {
            addMarker(new kakao.maps.LatLng($_lat[i], $_lng[i]));
          }
        }
      ''');
  }

  void _removeSearchInput() {
    setState(() {
      _textController.text = '';
    });
    _textFocusNode.requestFocus();
  }

  //void _getSuggestions() {
  //  if (_query != '') {
  //    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
  //      final placeSuggestions =
  //          //await GoogleService(sessionToken: _sessionToken)
  //          //    .fetchPlaceSuggestions(_textController.text);
  //          await _fakeGoogleService.fetchPlaceSuggestions();
  //      placeSuggestions.forEach((element) {
  //        print(element.toJson());
  //      });
  //      _timer?.cancel();
  //      setState(() {
  //        _suggestionList.value = placeSuggestions;
  //        _found = true;
  //      });
  //    });
  //  }
  //}

  //void _onMapCreated(GoogleMapController controller) {
  //  _mapController = controller;
  //}

  void _onUrlTapped(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext(bool isValue) {
    if (isValue) {
      Provider.of<Signup>(context, listen: false).location = _locationList;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignupMentorAuthView()));
  }

  void _openMap() {
    double w = MediaQuery.of(context).size.width;
    _mapHeight.value = MediaQuery.of(context).size.height * 0.95;
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.95,
              child: ValueListenableBuilder(
                  builder: (BuildContext context, double value, Widget? child) {
                    var _mapH = value;
                    var _listH =
                        MediaQuery.of(context).size.height * 0.95 - value;
                    return AnimatedSize(
                        curve: Curves.easeIn,
                        duration: const Duration(seconds: 1),
                        child: ValueListenableBuilder(
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return Stack(children: [
                                Column(children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      child: KakaoMapView(
                                        width: w,
                                        height: _mapH,
                                        kakaoMapKey: _kakaoApiKey,
                                        lat: 33.450701,
                                        lng: 126.570667,
                                        zoomLevel: 4,
                                        mapController: (controller) {
                                          _mapController = controller;
                                        },
                                        customScript: '''
                                          let markers = [];
                                          let moveLatLon;
                                          //var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png';   
                                          //var imageSize = new kakao.maps.Size(64, 69);
                                          //var imageOption = {offset: new kakao.maps.Point(27, 69)}; 
                                          //var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
                                          function addMarker(position) {
                                            //var marker = new kakao.maps.Marker({position: position, image: markerImage});
                                            var marker = new kakao.maps.Marker({position: position});
                                            marker.setMap(map);
                                            markers.push(marker);
                                          }

                                        ''',
                                        onTapMarker: (message) =>
                                            print(message.message),
                                      )),
                                  value
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.grey))),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: _listH,
                                          child: renderSearchResults(
                                              _locationList))
                                      : SizedBox()
                                ]),
                                Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.05),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      GestureDetector(
                                          onTapDown: (details) {
                                            _isModalCloseTapped.value = true;
                                          },
                                          onTapUp: (details) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _isModalCloseTapped.value = false;
                                              Navigator.pop(context);
                                              _mapHeight.value =
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.9;
                                              _isSearched.value = false;
                                              _textController.text = '';
                                              setState(() {
                                                _query = '';
                                              });
                                            });
                                          },
                                          onTapCancel: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _isModalCloseTapped.value = false;
                                            });
                                          },
                                          child: ValueListenableBuilder(
                                            builder: (BuildContext context,
                                                bool value, Widget? child) {
                                              return Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text('닫기',
                                                      style: TextStyle(
                                                          color: value
                                                              ? Colors
                                                                  .amber[400]
                                                              : Colors
                                                                  .amber[900],
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                          fontWeight: FontWeight
                                                              .bold)));
                                            },
                                            valueListenable:
                                                _isModalCloseTapped,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015)),
                                      renderSearchBar(),
                                      Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.005)),
                                      //========= Autocomplete result list
                                      //ValueListenableBuilder(
                                      //  builder: (BuildContext context,
                                      //      List<SuggestionModel> value, Widget? child) {
                                      //    return renderSuggestions(value);
                                      //  },
                                      //  valueListenable: _suggestionList,
                                      //),
                                    ])),
                              ]);
                            },
                            valueListenable: _isSearched));
                  },
                  valueListenable: _mapHeight));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: false,
        child: Stack(children: [
          Container(color: Colors.grey[200]),
          Column(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(
                            0, MediaQuery.of(context).size.height * 0.015))
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Text('등록된 장소 중에서\n예비직업인이 밥자리를 제안합니다.',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold)))),
            SingleChildScrollView(
                controller: _selectListScrollController,
                child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        top: MediaQuery.of(context).size.height * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.2),
                    child: Column(children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: BigButton(
                              btnColor: BobColors.mainColor,
                              title: '+ 장소 등록하기',
                              txtColor: Colors.white,
                              press:
                                  _selLocation.length == 10 ? null : _openMap)),
                      renderSelectedList(_selLocation)
                    ])))
          ])
        ]),
        topTitle: const ['밥자리 희망 장소를', '등록해주세요.'],
        btn1Title: '다 음',
        btn1Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn1: _locationList.isEmpty ? null : () => _pressNext(true),
        btn2Title: '나중에 하기',
        btn2Color: Colors.black,
        pressBtn2: () => _pressNext(false));
  }

  Widget renderSearchBar() {
    return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: BobColors.mainColor, width: 2),
            borderRadius: BorderRadius.circular(30)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        alignment: Alignment.center,
        child: TextField(
          onSubmitted: (_value) => _onTapSearch(),
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: TextAlign.start,
          autofocus: true,
          focusNode: _textFocusNode,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.cancel),
                  color: Colors.grey,
                  onPressed: () => _removeSearchInput()),
              hintText: '식당, 카페 이름을 검색해보세요'),
          controller: _textController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        ));
  }

  Widget renderSearchResults(List<PlaceModel> list) {
    return _found
        ? _locationList.isEmpty
            ? Container(alignment: Alignment.center, child: Text('검색결과가 없습니다.'))
            : ValueListenableBuilder(
                builder: (BuildContext context, int value, Widget? child) {
                  return value == -1
                      ? SingleChildScrollView(
                          controller: _searchListScrollController,
                          child: Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              color: Colors.white,
                              child: Column(
                                  children: List.generate(
                                      list.length,
                                      (idx) => GestureDetector(
                                          onTapDown: (details) {
                                            _isItemTapped.value = true;
                                            _selected.value = idx;
                                          },
                                          onTapUp: (details) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _isItemTapped.value = false;
                                              _selected.value = -1;
                                              //_onItemSelected(_suggestionList.value[idx]);
                                              _onItemSelected(idx);
                                              //Navigator.pop(context);
                                            });
                                          },
                                          onTapCancel: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _isItemTapped.value = false;
                                              _selected.value = -1;
                                            });
                                          },
                                          child: ValueListenableBuilder(
                                              builder: (BuildContext context,
                                                  int value, Widget? child) {
                                                return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                    decoration: BoxDecoration(
                                                        color: value == idx
                                                            ? Colors.grey[200]
                                                            : Colors.white,
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                            .grey[
                                                                        200] ??
                                                                    Colors
                                                                        .black12))),
                                                    padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(children: [
                                                            Container(
                                                                padding: EdgeInsets.all(
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.01),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                            .grey[
                                                                        200]),
                                                                child: Icon(
                                                                    Icons
                                                                        .location_on_outlined,
                                                                    size: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06)),
                                                            Text('700m',
                                                                style: TextStyle(
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.03,
                                                                    color: Colors
                                                                        .grey))
                                                          ]),
                                                          Padding(
                                                              padding: EdgeInsets.all(
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.02)),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.77,
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        list[idx]
                                                                            .name!,
                                                                        style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.width *
                                                                                0.04,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight: FontWeight
                                                                                .bold),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .fade,
                                                                        maxLines:
                                                                            1,
                                                                        softWrap:
                                                                            false),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.all(MediaQuery.of(context).size.width *
                                                                                0.005)),
                                                                    Text(
                                                                        list[idx]
                                                                            .address!,
                                                                        style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.width *
                                                                                0.035,
                                                                            color: Colors
                                                                                .grey),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .fade,
                                                                        maxLines:
                                                                            1,
                                                                        softWrap:
                                                                            false)
                                                                  ])),
                                                          Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              size: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              color:
                                                                  Colors.grey)
                                                        ]));
                                              },
                                              valueListenable: _selected))))))
                      : Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            bottom: MediaQuery.of(context).size.height * 0.03,
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          color: Colors.white,
                          child: Column(children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(list[_selIdx.value].name!,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false),
                                      Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.005)),
                                      Text(list[_selIdx.value].address!,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false),
                                      Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.005)),
                                      GestureDetector(
                                          onTapDown: (details) {
                                            _isUrlTapped.value = true;
                                          },
                                          onTapUp: (details) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _isUrlTapped.value = false;
                                              _onUrlTapped(
                                                  list[_selIdx.value].url!);
                                            });
                                          },
                                          onTapCancel: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              _isUrlTapped.value = false;
                                            });
                                          },
                                          child: Text('가게 정보 자세히 보기',
                                              style: TextStyle(
                                                  color: BobColors.mainColor,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                  decoration:
                                                      TextDecoration.underline)
                                              //list[_selIdx.value].url!
                                              )),
                                    ])),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.02)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: BigButton(
                                    btnColor: BobColors.mainColor,
                                    title: '희망 장소로 등록',
                                    txtColor: Colors.white,
                                    press: () {
                                      setState(() => _selLocation
                                          .add(list[_selIdx.value]));
                                      Navigator.pop(context);
                                    })),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        0.005)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: BigButton(
                                    btnColor: Colors.black,
                                    title: '검색목록 돌아가기',
                                    txtColor: Colors.white,
                                    press: () => _selIdx.value = -1))
                          ]));
                },
                valueListenable: _selIdx)
        : SizedBox();
  }

  Widget renderSelectedList(List<PlaceModel> list) {
    return Column(
        children: List.generate(
            list.length,
            (index) => Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03),
                child: renderChip(list[index]))));
  }

  Widget renderChip(PlaceModel place) {
    double radius = 10;
    return Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: Offset(0, MediaQuery.of(context).size.height * 0.003))
              //Offset(0, 0))
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(),
          Spacer(),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(children: [
                Text(place.name!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.005)),
                Text(place.address!,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false),
              ])),
          Spacer(),
          GestureDetector(
              onTap: () => setState(() {
                    _selLocation.remove(place);
                  }),
              child: Icon(Icons.clear,
                  size: MediaQuery.of(context).size.width * 0.05))
        ]));
  }
/*
  Widget renderSuggestions(List<SuggestionModel> list) {
    return _query != ''
        ? !_found
            ? const Text('검색 중...')
            : _suggestionList.value.isEmpty
                ? Text('검색결과가 없습니다.')
                : Column(
                    children: List.generate(
                        list.length,
                        (idx) => GestureDetector(
                            onTapDown: (details) {
                              _isItemTapped.value = true;
                              _selected.value = idx;
                            },
                            onTapUp: (details) {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _isItemTapped.value = false;
                                _selected.value = -1;

                                //_onItemSelected(_suggestionList.value[idx]);
                                Navigator.pop(context);
                              });
                            },
                            onTapCancel: () {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _isItemTapped.value = false;
                                _selected.value = -1;
                              });
                            },
                            child: ValueListenableBuilder(
                                builder: (BuildContext context, int value,
                                    Widget? child) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                          color: value == idx
                                              ? Colors.grey[200]
                                              : Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200] ??
                                                      Colors.black12))),
                                      padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.02,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(children: [
                                              Container(
                                                  padding: EdgeInsets.all(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.01),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey[200]),
                                                  child: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06)),
                                              Text('700m',
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      color: Colors.grey))
                                            ]),
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.02)),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.77,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(list[idx].placeName!,
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow:
                                                              TextOverflow.fade,
                                                          maxLines: 1,
                                                          softWrap: false),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .all(MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.005)),
                                                      Text(list[idx].address!,
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.035,
                                                              color:
                                                                  Colors.grey),
                                                          overflow:
                                                              TextOverflow.fade,
                                                          maxLines: 1,
                                                          softWrap: false)
                                                    ]))
                                          ]));
                                },
                                valueListenable: _selected))))
        : SizedBox();
  }
  */
}
