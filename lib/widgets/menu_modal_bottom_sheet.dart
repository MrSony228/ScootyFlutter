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
import 'package:scooty/widgets/bank_card_widget.dart';
import 'package:scooty/widgets/scooty_text_field.dart';

import 'dialog_line.dart';

class MenuModalBottomSheet {
  final BuildContext context;

  const MenuModalBottomSheet(this.context);

  Future<void> show() async {
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
                  // DialogLine('Уведомления', MdiIcons.bellOutline, () {
                  //   Navigator.pop(context);
                  // }),
                  // DialogLine('Профиль', MdiIcons.accountOutline, () {
                  //   Navigator.pop(context);
                  // }),
                  // DialogLine('История поездок', MdiIcons.history, () {
                  //   Navigator.pop(context);
                  // }),
                  DialogLine('Банковские карты', MdiIcons.creditCardOutline,
                      () async {
                    List<BankCard> result =
                        await InternetEngine().getBankCards();
                    if (result.isEmpty) {
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
                                "Ошибка",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: const Text(
                                "У вас нет существующих банковских карт, хотите добавить новую?",
                              ),
                              actions: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              BankCard bankCard = BankCard(
                                                  numberBankCard: "",
                                                  cardDate: "",
                                                  cardCvc: 0,
                                                  userId: 0,
                                                  cardName: "");
                                              Navigator.pop(context);
                                              BankCardModalBottomSheet(context,
                                                      bankCard, user, true)
                                                  .show();
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
                    } else {
                      BankCard bankCard = result[0];
                      BankCardModalBottomSheet(context, bankCard, user, false)
                          .show();
                    }
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
