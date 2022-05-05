import './preference/fee.dart';
import './preference/schedule.dart';
import './preference/location.dart';

class AppointmentModel {
  late FeeModel? fee;
  late ScheduleAppointmentModel? schedule;
  late LocationModel? location;

  AppointmentModel(
      {required this.fee, required this.schedule, required this.location});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    fee = FeeModel?.fromJson(json['fee']);
    schedule = ScheduleAppointmentModel?.fromJson(json['schedule']);
    location = LocationModel?.fromJson(json['location']);
  }

  Map<String, dynamic> toJson() => {
        'fee': fee?.toJson(),
        'schedule': schedule?.toJson(),
        'location': location?.toJson(),
      };
}
