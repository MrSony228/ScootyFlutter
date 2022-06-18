import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scooty/internet_engine.dart';
import 'package:scooty/model/bank_card.dart';
import 'package:scooty/model/user_to_register.dart';
import 'package:scooty/widgets/scooty_text_field.dart';

class BankCardModalBottomSheet {
  final BuildContext context;
  final UserToRegister user;
  BankCard bankCard;
  final bool isEmpty;

  BankCardModalBottomSheet(
      this.context, this.bankCard, this.user, this.isEmpty);

  TextEditingController bankCardNumberController = TextEditingController();
  TextEditingController bankCardCVCController = TextEditingController();
  DateTime selectDate = DateTime.now();

  void show() async {
    if (isEmpty == false) {
      fillBankCard(bankCard);
    }
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.black,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Container(
                height: MediaQuery.of(context).size.height / 1.1,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      height: 3,
                      width: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Управление банковской картой",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow,
                        image: DecorationImage(
                            image: const AssetImage(
                              "assets/images/vector.png",
                            ),
                            alignment: Alignment.centerRight,
                            colorFilter: ColorFilter.mode(
                                Colors.yellow.withOpacity(0.08),
                                BlendMode.dstATop))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: SvgPicture.asset(
                            'assets/images/scootyWallet.svg',
                            alignment: Alignment.topRight,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(children: [
                          SizedBox(
                            width: 170,
                            child: ScootyTextField(
                                "4276 5900 1776 3508",
                                bankCardNumberController,
                                MaskTextInputFormatter(
                                    mask: '#### #### #### ####',
                                    filter: {"#": RegExp(r'[0-9]')},
                                    type: MaskAutoCompletionType.lazy)),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 48,
                            width: 115,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Colors.white,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    )),
                                onPressed: () {
                                  Future<void> _selectDate(
                                      BuildContext context) async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      builder: (context, child) => Theme(
                                        data: ThemeData().copyWith(
                                          colorScheme: const ColorScheme.dark(
                                            primary: Colors.yellow,
                                            onPrimary: Colors.black,
                                            surface: Colors.black,
                                            onSurface: Colors.white,
                                          ),
                                          dialogBackgroundColor: Colors.black,
                                        ),
                                        child: child!,
                                      ),
                                      initialDatePickerMode: DatePickerMode.year,
                                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                                      initialDate: selectDate,
                                      firstDate: DateTime(1940, 8),
                                      lastDate: DateTime(2110),
                                    );
                                    if (picked != null &&
                                        picked != selectDate) {
                                      setModalState(() {
                                        selectDate = picked;
                                      });
                                    }
                                  }

                                  _selectDate(context);
                                },
                                child: Text(
                                  "${selectDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                      color: Color.fromRGBO(101, 101, 101, 1),
                                      fontSize: 17),
                                  textAlign: TextAlign.left,
                                )),
                          ),
                        ]),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(user.firstName + " " + user.lastName,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Cera-Pro',
                                      fontWeight: FontWeight.bold)),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 45,
                              child: ScootyTextField(
                                  "123",
                                  bankCardCVCController,
                                  MaskTextInputFormatter(
                                      mask: '###',
                                      filter: {"#": RegExp(r'[0-9]')},
                                      type: MaskAutoCompletionType.lazy)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              onPrimary: Colors.yellow,
                              side: const BorderSide(
                                  width: 2.0, color: Colors.yellow)),
                          onPressed: () async {
                            if (isEmpty == false) {
                              bankCard.cardCvc =
                                  int.parse(bankCardCVCController.text);
                              bankCard.cardDate = selectDate;
                              bankCard.numberBankCard =
                                  bankCardNumberController.text;
                              bool result =
                                  await InternetEngine().editBankCard(bankCard);
                              if (result == true) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,

                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(6),
                                        //   side: const BorderSide(color: Colors.yellow),
                                        // ),
                                        title: const Text(
                                          "Уведомление",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        content: const Text(
                                          "Данные обновленны",
                                        ),
                                        actions: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Ок")),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                              return;
                            } else {
                              bankCard.cardCvc =
                                  int.parse(bankCardCVCController.text);
                              bankCard.cardDate = selectDate;
                              bankCard.numberBankCard =
                                  bankCardNumberController.text;
                              bool result =
                                  await InternetEngine().addBankCards(bankCard);
                              if (result == true) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,

                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(6),
                                        //   side: const BorderSide(color: Colors.yellow),
                                        // ),
                                        title: const Text(
                                          "Уведомление",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        content: const Text(
                                          "Ваша карта была успешно добавлена!",
                                        ),
                                        actions: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Ок")),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                          child: const Text('Сохранить'))),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.yellow,
                            side: const BorderSide(
                                width: 2.0, color: Colors.yellow)),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,

                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(6),
                                  //   side: const BorderSide(color: Colors.yellow),
                                  // ),
                                  title: const Text(
                                    "Уведомление",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  content: const Text(
                                    "Вы точно хотите удалить карту?",
                                  ),
                                  actions: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  var result =
                                                      await InternetEngine()
                                                          .deleteBankCard(
                                                              bankCard);
                                                  if (result == true) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    return;
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.black,

                                                            // shape: RoundedRectangleBorder(
                                                            //   borderRadius: BorderRadius.circular(6),
                                                            //   side: const BorderSide(color: Colors.yellow),
                                                            // ),
                                                            title: const Text(
                                                              "Ошибка",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            content: const Text(
                                                              "Проблемы сервера",
                                                            ),
                                                            actions: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        bottom:
                                                                            16),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          130,
                                                                      child: ElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text("Ок")),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                  return;
                                                },
                                                child: const Text("Да")),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: 130,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.black,
                                                    onPrimary: Colors.yellow,
                                                    side: const BorderSide(
                                                        width: 2.0,
                                                        color: Colors.yellow)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  return;
                                                },
                                                child: const Text('Нет')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text("Удалить карту"),
                      ))
                ]));
          });
        });
  }

  void fillBankCard(BankCard bankCard) {
    bankCardNumberController.text = bankCard.numberBankCard;
    selectDate = bankCard.cardDate;
    bankCardCVCController.text = bankCard.cardCvc.toString();
  }
}
