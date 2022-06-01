// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankCards _$BankCardsFromJson(Map<String, dynamic> json) => BankCards(
      numberBankCard: json['numberBankCard'] as String,
      cardDate: DateTime.parse(json['cardDate'] as String),
      cvc: json['cardCvc'] as int,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$BankCardsToJson(BankCards instance) => <String, dynamic>{
      'numberBankCard': instance.numberBankCard,
      'cardDate': instance.cardDate.toIso8601String(),
      'cvc': instance.cvc,
      'userId': instance.userId,
    };
