
import 'package:json_annotation/json_annotation.dart';

part 'bank_card.g.dart';


@JsonSerializable()
 class BankCards{

  BankCards({
    required this.numberBankCard,
    required this.cardDate,
    required this.cvc,
    required this.userId
});

  late String numberBankCard;
  late DateTime cardDate;
  late int cvc;
  late int userId;

  factory BankCards.fromJson(Map<String, dynamic> data) =>
      _$BankCardsFromJson(data);

  Map<String, dynamic> toJson() => _$BankCardsToJson(this);
}
