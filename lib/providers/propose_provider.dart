import 'package:flutter/foundation.dart';
import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';

class Propose with ChangeNotifier {
  MentorModel _mentorDetails = MentorModel();
  List<ScheduleProposalModel> _scheduleCheck = [];
  List<int> _locationCheck = [];

  MentorModel get mentorDetails => _mentorDetails;
  List<ScheduleProposalModel> get scheduleCheck => _scheduleCheck;
  List<int> get locationCheck => _locationCheck;

  set mentor(MentorModel value) {
    _mentorDetails = value;
    notifyListeners();
  }

  set schedule(List<ScheduleProposalModel> value) {
    _scheduleCheck = value;
    notifyListeners();
  }

  set location(List<int> value) {
    _locationCheck = value;
    notifyListeners();
  }

  void flush() {
    _scheduleCheck = [];
    _locationCheck = [];
    _mentorDetails = MentorModel();
  }

  void show() {
    _scheduleCheck.map((dynamic el) => el.toJson()).toList();
    _locationCheck.map((dynamic el) => el.toJson()).toList();
  }
}
