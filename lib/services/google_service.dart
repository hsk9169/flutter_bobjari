import 'dart:convert';
import 'dart:io';
import 'package:bobjari_proj/models/preference/location.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bobjari_proj/models/google_map_model.dart';

// Basic Data
// *

class GoogleService {
  final client = Client();

  GoogleService({this.sessionToken});

  final sessionToken;

  static final String androidKey = dotenv.env['ANDROID_API_KEY']!;
  static final String iosKey = dotenv.env['IOS_API_KEY']!;
  //final apiKey = Platform.isAndroid ? androidKey : iosKey;
  final apiKey = 'AIzaSyBSs4WguWymzWF4hWI7yBhkDGVSRvcNmDA';

  Future<List<SuggestionModel>> fetchPlaceSuggestions(String input) async {
    final request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=establishment&language=ko&components=country:kr&key=$apiKey&sessiontoken=$sessionToken');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<SuggestionModel>(
                (dynamic suggestion) => SuggestionModel.fromJson(suggestion))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List<PlaceDetailsModel>> getPlacesWithDetails(String input) async {
    final request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$input&language=ko&region=kr&key=$apiKey');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<PlaceDetailsModel>(
                (dynamic place) => PlaceDetailsModel.fromJson(place))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<PlaceDetailsModel> getPlaceDetailsFromId(String placeId) async {
    final request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=rating%2Cformatted_phone_number%2Cbusiness_status%2Cphotos%2Curl%2Copening_hours%2Creviews%2Cprice_level%2Cgeometry%2Cuser_ratings_total&language=ko&region=kr&key=$apiKey');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return PlaceDetailsModel.fromJson(result['result']);
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return PlaceDetailsModel();
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
