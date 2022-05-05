import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/mentee/mentee.dart';
import 'package:bobjari_proj/models/preference/preference.dart';
import 'package:bobjari_proj/models/appointment_model.dart';
import 'package:bobjari_proj/models/chat_model.dart';

class BobjariModel {
  late String? bobjariId;
  late PreferenceModel? proposal;
  late AppointmentModel? appointment;
  late int? status;
  late int? numNews;
  late String? updatedAt;
  late ChatModel? chat;
  late MentorModel? mentor;
  late MenteeModel? mentee;

  BobjariModel({
    this.bobjariId,
    this.proposal,
    this.appointment,
    this.status,
    this.numNews,
    this.updatedAt,
    this.chat,
    this.mentor,
    this.mentee,
  });

  BobjariModel.fromJsonMentee(Map<String, dynamic> json) {
    bobjariId = json['id'];
    proposal = PreferenceModel.fromJson(json['proposal']);
    appointment = AppointmentModel.fromJson(json['appointment']);
    status = json['status'];
    numNews = json['numNews'];
    updatedAt = json['updatedAt'];
    chat = json['chat'] != null ? ChatModel.fromJson(json['chat']) : null;
    mentor = MentorModel.fromJsonBobjari(json['mentor']);
    mentee = null;
  }

  BobjariModel.fromJsonMentor(Map<String, dynamic> json) {
    bobjariId = json['id'];
    proposal = PreferenceModel.fromJson(json['proposal']);
    appointment = AppointmentModel.fromJson(json['appointment']);
    status = json['status'];
    numNews = json['numNews'];
    updatedAt = json['updatedAt'];
    chat = ChatModel.fromJson(json['chat']);
    mentee = MenteeModel.fromJsonBobjari(json['mentee']);
    mentor = null;
  }

  Map<String, dynamic> toJson() => {
        'bobjariId': bobjariId,
        'proposal': proposal?.toJson(),
        'appointment': appointment?.toJson(),
        'status': status,
        'numNews': numNews,
        'updatedAt': updatedAt,
        'chat': chat?.toJson(),
        'mentor': mentor?.toJson(),
        'mentee': mentee?.toJson(),
      };
}
