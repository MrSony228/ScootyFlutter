// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankCard _$BankCardFromJson(Map<String, dynamic> json) => BankCard(
      numberBankCard: json['numberBankCard'] as String,
      cardDate: DateTime.parse(json['cardDate'] as String),
      cardCvc: json['cardCvc'] as int,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$BankCardToJson(BankCard instance) => <String, dynamic>{
      'numberBankCard': instance.numberBankCard,
      'cardDate': instance.cardDate.toIso8601String().substring(0,10),
      'cardCvc': instance.cardCvc,
      'userId': instance.userId,
    };
