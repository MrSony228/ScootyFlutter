// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transport _$TransportFromJson(Map<String, dynamic> json) => Transport(
      id: json['id'] as int,
      name: json['name'] as String,
      batteryLevel: json['batteryLevel'] as int,
      description: json['description'] as String,
      mileage: json['mileage'] as int,
      manufacturer: json['manufacturer'] as String,
      free: json['free'] as bool,
      price: json['price'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$TransportToJson(Transport instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'batteryLevel': instance.batteryLevel,
      'description': instance.description,
      'mileage': instance.mileage,
      'manufacturer': instance.manufacturer,
      'price': instance.price,
      'free': instance.free,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
