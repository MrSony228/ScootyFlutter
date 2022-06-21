import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scooty/screens/login_screen.dart';
import 'package:scooty/screens/registartion_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StartScreen();
  }
}

class _StartScreen extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundImage.png"),
            fit: BoxFit.fill,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Получите свободу передвижения с",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 104,
                  height: 24,
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(
                  height: 26,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text("Войти")),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.yellow,
                          side: const BorderSide(
                              width: 2.0, color: Colors.yellow)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: const Text("Регистрация")),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    String license =
                        await rootBundle.loadString('assets/text/about.txt');
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                                width: 1, color: Colors.yellow)),
                        isScrollControlled: true,
                        backgroundColor: Colors.black,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setModalState) {
                            return Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Column(
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
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.1,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListView(children: [
                                          const Text(
                                            "О компании",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            license,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                            const  Text('Связь с тех-поддержкой: ',style:
                                             TextStyle(fontSize: 17),),
                                              IconButton(
                                                  onPressed: () {
                                                    launchTelegram();
                                                  },
                                                  icon: SvgPicture.asset(
                                                    "assets/images/telegram.svg",
                                                    color: Colors.yellow,
                                                    height: 70,
                                                  ),),

                                            ],
                                          ),
                                        ])),
                                  ]),
                            );
                          });
                        });
                  },
                  child: const Text("О компании",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
              ]),
        ),
      ),
    );
  }

  void launchTelegram() async {
    var url = Uri.https('t.me', 'ooo_scooty', {});
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
