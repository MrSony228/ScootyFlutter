import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scooty/screens/main_screen.dart';
import 'package:scooty/screens/registartion_screen.dart';
import 'package:scooty/screens/start_screen.dart';
import 'package:scooty/widgets/scooty_text_field.dart';

import '../internet_engine.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 146,
                  height: 34,
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Добро пожаловать",
                    style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(
                  height: 127,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "E-Mail",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    hintText: 'scooty@gmail.com',
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                    hintStyle: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    hintText: "Пароль",
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                    hintStyle: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () async {
                        var email =
                            EmailValidator.validate(emailController.text);
                        if (email == false) {
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
                                    "E-Mail введен не верно.",
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
                        var result = await InternetEngine().login(
                            emailController.text, passwordController.text);
                        if (result == 403) {
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
                                    "Неверный логин или пароль, попробуйте еще раз",
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
                        if (result != 200) {
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
                                  content: Flexible(
                                    child: Text(
                                      "Произошла ошибка сервера. Код ошибки: " +
                                          result.toString(),
                                    ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      },
                      child: const Text(
                        'Войти',
                      )),
                ),
                const SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "У вас нет аккаунта?   ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: const Text("Зарегистрируйтесь!",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
