import 'dart:convert';

StateModel? stateModelFromJson(String str) =>
    StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel? data) => json.encode(data!.toJson());

class StateModel {
  StateModel({
    this.state,
    this.nextPage,
  });

  List<States?>? state;
  final String? nextPage;

  factory StateModel.fromJson(Map json) => StateModel(
        state: json["data"] == null
            ? []
            : List<States?>.from(json["data"]!.map((x) => States.fromJson(x))),
        nextPage: json["links"]?["next"],
      );

  Map<String, dynamic> toJson() => {
        "state": state == null
            ? []
            : List<dynamic>.from(state!.map((x) => x!.toJson())),
      };
}

class States {
  States({
    this.id,
    this.name,
    this.countryId,
  });

  dynamic id;
  String? name;
  dynamic countryId;

  factory States.fromJson(Map<String, dynamic> json) => States(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
      };
}
