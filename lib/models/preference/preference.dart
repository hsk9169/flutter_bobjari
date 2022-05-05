import './fee.dart';
import './schedule.dart';
import './location.dart';

class PreferenceModel {
  late FeeModel? fee;
  late List<SchedulePreferenceModel>? schedule;
  late List<LocationModel>? location;

  PreferenceModel(
      {required this.fee, required this.schedule, required this.location});

  PreferenceModel.fromJson(Map<String, dynamic> json) {
    fee = FeeModel.fromJson(json['fee']);
    schedule = json['schedule']
        ?.map<SchedulePreferenceModel>(
            (dynamic schedule) => SchedulePreferenceModel.fromJson(schedule))
        .toList();
    location = json['location']
        ?.map<LocationModel>(
            (dynamic location) => LocationModel.fromJson(location))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'fee': fee?.toJson(),
        'schedule': schedule?.map((el) => el.toJson()).toList(),
        'location': location?.map((el) => el.toJson()).toList(),
      };
}
