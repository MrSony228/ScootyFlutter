import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scooty/internet_engine.dart';
import 'package:scooty/model/bank_card.dart';
import 'package:scooty/model/local_storage.dart';
import 'package:scooty/model/user_to_register.dart';
import 'package:scooty/screens/login_screen.dart';
import 'package:scooty/screens/start_screen.dart';
import 'package:scooty/widgets/scooty_text_field.dart';

import 'dialog_line.dart';

class MenuModalBottomSheet {
  final BuildContext context;

  const MenuModalBottomSheet(this.context);

  void show() async {
    UserToRegister? user = await InternetEngine().getUser();

    if (user == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Text(
                "Ошибка",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "Ошибка соеденения с бд, попробуйте войти в аккаунт снова",
                style: TextStyle(),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      LocalStorage().deleteToken();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("Закрыть"))
              ],
            );
          });
    } else {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          isScrollControlled: true,
          backgroundColor: Colors.black,
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                  DialogLine('Уведомления', MdiIcons.bellOutline, () {
                    Navigator.pop(context);
                  }),
                  DialogLine('Профиль', MdiIcons.accountOutline, () {
                    Navigator.pop(context);
                  }),
                  DialogLine('История поездок', MdiIcons.history, () {
                    Navigator.pop(context);
                  }),
                  DialogLine('Банковские карты', MdiIcons.creditCardOutline,
                      () async{
                      List<BankCards>? result = await InternetEngine().getBankCards();
                      // if(result?.length == 0)
                      //   {
                      //     showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return AlertDialog(
                      //             backgroundColor: Colors.black,
                      //             title: const Text(
                      //               "Ошибка",
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //             content: const Text(
                      //               "Заполните все поля",
                      //             ),
                      //             actions: [
                      //               ElevatedButton(
                      //                   onPressed: () {
                      //                     Navigator.pop(context);
                      //                   },
                      //                   child: const Text("Закрыть"))
                      //             ],
                      //           );
                      //         });
                      //     return;
                      //   }
                      BankCards bankCard = result![0];
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.black,
                        context: context,
                        builder: (context) {
                          TextEditingController bankCardNumberController = TextEditingController();
                          bankCardNumberController.text = bankCard.numberBankCard;
                          DateTime selectDate = bankCard.cardDate;
                          return StatefulBuilder(builder: (context, setModalState) {
                            TextEditingController bankCardCVCController = TextEditingController();
                            bankCardCVCController.text = bankCard.cvc.toString();
                            return Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.1,
                                padding:
                                const EdgeInsets.only(left: 16, right: 16),
                                child: ListView(
                                    children: [Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Center(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
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
                                          const SizedBox(height: 16,),
                                          Container(
                                            height: 200,
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                                color: Colors.yellow,
                                                image: DecorationImage(
                                                    image: const AssetImage(
                                                      "assets/images/vector.png",
                                                    ),
                                                    alignment: Alignment
                                                        .centerRight,
                                                    colorFilter: ColorFilter
                                                        .mode(
                                                        Colors.yellow
                                                            .withOpacity(0.08),
                                                        BlendMode.dstATop))),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: SvgPicture.asset(
                                                    'assets/images/scootyWallet.svg',
                                                    alignment: Alignment
                                                        .topRight,
                                                  ),
                                                ),
                                                const SizedBox(height: 16,),
                                                Row(
                                                  children:[ SizedBox( width: 170,
                                                    child: ScootyTextField(
                                                        "4276 5900 1776 3508",
                                                        bankCardNumberController,
                                                        MaskTextInputFormatter(
                                                            mask: '#### #### #### ####',
                                                            filter: {
                                                              "#": RegExp(r'[0-9]')
                                                            },
                                                            type: MaskAutoCompletionType
                                                                .lazy)),
                                                  ),
                                                const Spacer(),
                                                SizedBox(
                                                  height: 48,
                                                  width: 115,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shadowColor: Colors.transparent,
                                                          primary: Colors.white,
                                                          onPrimary: Colors
                                                              .white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(7.0),
                                                          )),
                                                      onPressed: () {
                                                        Future<
                                                            void> _selectDate(
                                                            BuildContext context) async {
                                                          final DateTime? picked = await showDatePicker(
                                                            context: context,
                                                            builder: (context,
                                                                child) =>
                                                                Theme(
                                                                  data: ThemeData()
                                                                      .copyWith(
                                                                    colorScheme: const ColorScheme
                                                                        .dark(
                                                                      primary: Colors
                                                                          .yellow,
                                                                      onPrimary: Colors
                                                                          .black,
                                                                      surface: Colors
                                                                          .black,
                                                                      onSurface: Colors
                                                                          .white,
                                                                    ),
                                                                    dialogBackgroundColor: Colors
                                                                        .black,
                                                                  ),
                                                                  child: child!,
                                                                ),
                                                            initialDate: selectDate,
                                                            firstDate: DateTime(
                                                                1940, 8),
                                                            lastDate: DateTime(
                                                                2110),
                                                          );
                                                          if (picked != null &&
                                                              picked !=
                                                                  selectDate) {
                                                            setModalState(() {
                                                              selectDate =
                                                                  picked;
                                                            });
                                                          }
                                                        }

                                                        _selectDate(context);
                                                      },
                                                      child: Text(
                                                        "${selectDate
                                                            .toLocal()}".split(
                                                            ' ')[0],
                                                        style: const TextStyle(
                                                            color: Color
                                                                .fromRGBO(
                                                                101, 101, 101,
                                                                1),
                                                            fontSize: 17),
                                                        textAlign: TextAlign
                                                            .left,
                                                      )),
                                                ),]),
                                                const SizedBox(height: 16,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment
                                                          .bottomLeft,
                                                      child: Text(
                                                          user.firstName +
                                                              " " +
                                                              user.lastName,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: 20,
                                                              fontFamily: 'Cera-Pro',
                                                              fontWeight: FontWeight
                                                                  .bold)),
                                                    ),
                                                    const Spacer(),
                                                    SizedBox( width: 45,
                                                      child: ScootyTextField(
                                                          "123",
                                                          bankCardCVCController,
                                                          MaskTextInputFormatter(
                                                              mask: '###',
                                                              filter: {
                                                                "#": RegExp(r'[0-9]')
                                                              },
                                                              type: MaskAutoCompletionType
                                                                  .lazy)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16,),
                                          SizedBox( width: double.infinity, child: ElevatedButton( onPressed: (){}, child: const Text('Сохранить')))
                                        ]),
                                    ]));
                          });
                        });
                  }),
                  DialogLine('Выход', MdiIcons.exitToApp, () async {
                    bool result = await LocalStorage().deleteToken();
                    if (result == true) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {}
                  }),
                  const SizedBox(
                    height: 42,
                  ),
                  Container(
                    height: 165,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                    user.firstName + " " + user.lastName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Cera-Pro',
                                        fontWeight: FontWeight.bold)),
                              ),
                              const Spacer(),
                              Expanded(
                                child: SvgPicture.asset(
                                  'assets/images/scootyWallet.svg',
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: const Text('0 Руб',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Cera-Pro',
                                        fontWeight: FontWeight.bold)),
                              ),
                              //   const Spacer(),
                              Expanded(
                                  child: IconButton(
                                onPressed: () {},
                                icon: const Icon(MdiIcons.arrowRight),
                                alignment: Alignment.bottomRight,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                ],
              ),
            );
          });
    }
  }
}
