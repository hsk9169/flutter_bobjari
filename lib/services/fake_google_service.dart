import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bobjari_proj/models/google_map_model.dart';

class FakeGoogleService {
  static const _jsonDir = 'assets/json/';
  static const _jsonExtension = '.json';

  Future<List<SuggestionModel>> fetchPlaceSuggestions() async {
    final _resourcePath = _jsonDir + 'google_autocomplete' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return _map
        .map<SuggestionModel>((dynamic el) => SuggestionModel.fromJson(el))
        .toList();
  }

  Future<List<PlaceDetailsModel>> getPlacesWithDetails(String input) async {
    final _resourcePath = _jsonDir + 'google_keyword_search' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return _map
        .map<PlaceDetailsModel>((dynamic el) => PlaceDetailsModel.fromJson(el))
        .toList();
  }

  Future<PlaceDetailsModel> getPlaceDetailsFromId(String placeId) async {
    final _resourcePath = _jsonDir + 'google_place_details' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return PlaceDetailsModel.fromJson(_map);
  }
}
