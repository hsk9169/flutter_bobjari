import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/preference/location.dart';
import 'package:bobjari_proj/models/preference/fee.dart';

class ProposalModel {
  late FeeModel? fee;
  late List<ScheduleProposalModel>? schedule;
  late List<LocationModel>? location;

  ProposalModel(
      {required this.fee, required this.schedule, required this.location});

  ProposalModel.fromJson(Map<String, dynamic> json) {
    fee = FeeModel.fromJson(json['fee']);
    schedule = json['schedule']
        ?.map<ScheduleProposalModel>(
            (dynamic schedule) => ScheduleProposalModel.fromJson(schedule))
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
