class ScheduleAppointmentModel {
  late int day;
  late int dateDay;
  late TimeModel time;
  late int month;
  late int year;

  ScheduleAppointmentModel(
      {required this.day,
      required this.dateDay,
      required this.time,
      required this.month,
      required this.year});

  ScheduleAppointmentModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dateDay = json['dateDay'];
    time = TimeModel.fromJson(json['time']);
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'dateDay': dateDay,
        'time': time.toJson(),
        'month': month,
        'year': year,
      };
}

class ScheduleProposalModel {
  late List<int> day;
  late List<int> dateDay;
  late List<TimeModel> time;
  late int month;
  late int year;

  ScheduleProposalModel(
      {required this.day,
      required this.dateDay,
      required this.time,
      required this.month,
      required this.year});

  ScheduleProposalModel.fromJson(Map<String, dynamic> json) {
    day = json['day']?.map<int>((el) => el as String).toList();
    dateDay = json['dateDay']?.map<int>((el) => el as String).toList();
    time = json['time']?.map<TimeModel>((el) => el as TimeModel).toList();
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'dateDay': dateDay,
        'time': time,
        'month': month,
        'year': year,
      };
}

class SchedulePreferenceModel {
  late String day;
  late String startTime;
  late String endTime;

  SchedulePreferenceModel(
      {required this.day, required this.startTime, required this.endTime});

  SchedulePreferenceModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'startTime': startTime,
        'endTime': endTime,
      };
}

class TimeModel {
  late String startTime;
  late String endTime;

  TimeModel({required this.startTime, required this.endTime});

  TimeModel.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
      };
}
