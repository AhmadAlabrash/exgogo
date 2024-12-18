import 'dart:convert';

CountryModel? countryModelFromJson(String str) =>
    CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel? data) => json.encode(data!.toJson());

class CountryModel {
  CountryModel({
    this.countries,
    this.nextPage,
  });

  List<Country?>? countries;
  final String? nextPage;

  factory CountryModel.fromJson(Map json) => CountryModel(
        countries: json["data"] == null
            ? []
            : List<Country?>.from(
                json["data"]!.map((x) => Country.fromJson(x))),
        nextPage: json["links"]?["next"],
      );

  Map<String, dynamic> toJson() => {
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x!.toJson())),
      };
}

class Country {
  Country({
    this.id,
    this.name,
  });

  dynamic id;
  String? name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
