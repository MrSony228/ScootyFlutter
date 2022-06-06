import 'package:json_annotation/json_annotation.dart';

part 'transport.g.dart';

@JsonSerializable()
class Transport {
  Transport(
      {required this.id,
      required this.name,
      required this.batteryLevel,
      required this.description,
      required this.mileage,
      required this.manufacturer,
      required this.free,
      required this.price,
      required this.latitude,
      required this.longitude});

  late int id;
  late String name;
  late int batteryLevel;
  late String description;
  late int mileage;
  late String manufacturer;
  late int price;
  late bool free;
  late double latitude;
  late double longitude;

  factory Transport.fromJson(Map<String, dynamic> data) =>
      _$TransportFromJson(data);

  Map<String, dynamic> toJson() => _$TransportToJson(this);
}
