
import 'package:json_annotation/json_annotation.dart';

part 'bank_card.g.dart';


@JsonSerializable()
 class BankCard{

  BankCard({
    required this.numberBankCard,
    required this.cardDate,
    required this.cardCvc,
    required this.userId,
    required this.cardName
});

  late String numberBankCard;
  late String cardDate;
  late int cardCvc;
  late int userId;
  late String cardName;

  factory BankCard.fromJson(Map<String, dynamic> data) =>
      _$BankCardFromJson(data);

  Map<String, dynamic> toJson() => _$BankCardToJson(this);
}
