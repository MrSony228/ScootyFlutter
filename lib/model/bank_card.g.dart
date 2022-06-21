// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankCard _$BankCardFromJson(Map<String, dynamic> json) => BankCard(
      numberBankCard: json['numberBankCard'] as String,
      cardDate: json['cardDate'] as String,
      cardCvc: json['cardCvc'] as int,
      userId: json['userId'] as int,
      cardName: json['cardName'] as String,
    );

Map<String, dynamic> _$BankCardToJson(BankCard instance) => <String, dynamic>{
      'numberBankCard': instance.numberBankCard,
      'cardDate': instance.cardDate,
      'cardCvc': instance.cardCvc,
      'userId': instance.userId,
      'cardName': instance.cardName,
    };
