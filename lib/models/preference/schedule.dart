class ScheduleAppointmentModel {
  late int? day;
  late int? dateDay;
  late TimeModel? time;
  late int? month;
  late int? year;

  ScheduleAppointmentModel(
      {this.day, this.dateDay, this.time, this.month, this.year});

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
        'time': time?.toJson(),
        'month': month,
        'year': year,
      };
}

class ScheduleProposalModel {
  late List<int>? day;
  late List<int>? dateDay;
  late List<TimeModel>? time;
  late int? month;
  late int? year;

  ScheduleProposalModel(
      {this.day, this.dateDay, this.time, this.month, this.year});

  ScheduleProposalModel.fromJson(Map<String, dynamic> json) {
    day = json['day'].map<int>((dynamic el) => el as int).toList();
    dateDay = json['dateDay'].map<int>((dynamic el) => el as int).toList();
    time = json['time']
        .map<TimeModel>((dynamic el) => TimeModel.fromJson(el))
        .toList();
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() => {
        'day': day ?? [],
        'dateDay': dateDay ?? [],
        'time': time?.map((dynamic el) => el.toJson()).toList(),
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
    startTime = json['startTime'] as String;
    endTime = json['endTime'] as String;
  }

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
      };
}
