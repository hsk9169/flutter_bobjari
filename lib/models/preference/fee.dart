class FeeModel {
  late int select;
  late String value;

  FeeModel({required this.select, required this.value});

  FeeModel.fromJson(Map<String, dynamic> json) {
    select = json['select'] ?? -1;
    value = json['value'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'select': select,
        'value': value,
      };
}
