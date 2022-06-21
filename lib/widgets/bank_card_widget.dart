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
  TextEditingController bankCardDateController = TextEditingController();
  TextEditingController bankCardNameController = TextEditingController();
  String selectDate = "";
  bool deleteVisibility = true;

  void show() async {
    if (isEmpty == true) {
      deleteVisibility = false;
    }
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
                            width: 185,
                            child: ScootyTextField(
                                "0000 0000 0000 0000",
                                bankCardNumberController,
                                MaskTextInputFormatter(
                                    mask: '#### #### #### ####',
                                    filter: {"#": RegExp(r'[0-9]')},
                                    type: MaskAutoCompletionType.lazy),
                                TextInputType.number),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 48,
                            width: 115,
                            child: ScootyTextField(
                                "00/00",
                                bankCardDateController,
                                MaskTextInputFormatter(
                                    mask: '*#/##',
                                    filter: {
                                      "#": RegExp(r'[0-9]'),
                                      "*": RegExp(r'[0-1]')
                                    },
                                    type: MaskAutoCompletionType.lazy),
                                TextInputType.number),
                          ),
                        ]),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.bottomLeft,
                                child: SizedBox(
                                  height: 48,
                                  width: 185,
                                  child: ScootyTextField(
                                      'Владелец карты',
                                      bankCardNameController,
                                      MaskTextInputFormatter(),
                                      TextInputType.text),
                                )),
                            const Spacer(),
                            SizedBox(
                                width: 45,
                                child: TextField(
                                  controller: bankCardCVCController,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '###',
                                        filter: {"#": RegExp(r'[0-9]')},
                                        type: MaskAutoCompletionType.lazy)
                                  ],
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 17),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    hintText: '000',
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 15),
                                    hintStyle: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                )),
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
                            if (bankCardNumberController.text.isEmpty ||
                                bankCardDateController.text.isEmpty ||
                                bankCardDateController.text.isEmpty ||
                                bankCardNameController.text.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: const Text(
                                        "Ошибка",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      content: const Text(
                                        "Заполните все поля",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Закрыть"))
                                      ],
                                    );
                                  });
                              return;
                            }
                            if (bankCardNumberController.text.length < 13) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: const Text(
                                        "Ошибка",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      content: const Text(
                                        "Номер карты введен неверно",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Закрыть"))
                                      ],
                                    );
                                  });
                              return;
                            }
                            if (bankCardDateController.text.length < 5) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: const Text(
                                        "Ошибка",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      content: const Text(
                                        "Неверно введена дата",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Закрыть"))
                                      ],
                                    );
                                  });
                              return;
                            }
                            var month = int.parse(
                                bankCardDateController.text.substring(0, 2));
                            if (month > 12) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: const Text(
                                        "Ошибка",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      content: const Text(
                                        "В году всего 12 месяцев!",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Закрыть"))
                                      ],
                                    );
                                  });
                              return;
                            }
                            if (bankCardCVCController.text.length < 3) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: const Text(
                                        "Ошибка",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      content: const Text(
                                        "Неверно введен CVC-код",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Закрыть"))
                                      ],
                                    );
                                  });
                              return;
                            }
                            if (isEmpty == false) {
                              bankCard.cardCvc =
                                  int.parse(bankCardCVCController.text);
                              bankCard.cardDate = bankCardDateController.text;
                              bankCard.numberBankCard =
                                  bankCardNumberController.text;
                              bankCard.cardName = bankCardNameController.text;
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
                              bankCard.cardDate = bankCardDateController.text;
                              bankCard.numberBankCard =
                                  bankCardNumberController.text;
                              bankCard.cardName = bankCardNameController.text;
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
                  Visibility(
                    child: SizedBox(
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              content:
                                                                  const Text(
                                                                "Проблемы сервера",
                                                              ),
                                                              actions: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 16,
                                                                      right: 16,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.black,
                                                          onPrimary:
                                                              Colors.yellow,
                                                          side:
                                                              const BorderSide(
                                                                  width: 2.0,
                                                                  color: Colors
                                                                      .yellow)),
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
                        )),
                    visible: deleteVisibility,
                  )
                ]));
          });
        });
  }

  void fillBankCard(BankCard bankCard) {
    bankCardNumberController.text = bankCard.numberBankCard;
    selectDate = bankCard.cardDate;
    bankCardCVCController.text = bankCard.cardCvc.toString();
    bankCardDateController.text = bankCard.cardDate;
    bankCardNameController.text = bankCard.cardName;
  }
}
