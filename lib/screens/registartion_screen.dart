import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scooty/internet_engine.dart';
import 'package:scooty/model/user_to_register.dart';
import 'package:scooty/screens/driver_licence_registration_screen.dart';
import 'package:scooty/screens/start_screen.dart';
import 'package:scooty/widgets/scooty_text_field.dart';
import 'package:intl/intl.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children:[ Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 146,
                height: 34,
                alignment: Alignment.center,
                child: Image.asset("assets/images/logo.png"),
              ),
             const SizedBox(
                height: 20,
              ),
              Text("Привет", style: Theme.of(context).textTheme.subtitle1),
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
              ScootyTextField("scooty@gmail.com", emailController,
                  MaskTextInputFormatter()),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Пароль",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            TextField(
              controller: passwordController, obscureText: true,
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
                  borderSide:const BorderSide(color: Colors.white),
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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Фамилия",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ScootyTextField("Иванов", firstNameController, MaskTextInputFormatter()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Имя",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ScootyTextField("Иван", lastNameController, MaskTextInputFormatter()),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Отчество",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      const  SizedBox(
                          height: 20,
                        ),
                        ScootyTextField("Иванович", middleNameController, MaskTextInputFormatter()),
                      ],
                    ),
                  ),
              const    SizedBox(
                    width: 28,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Дата рождения",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                       const  SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 48,
                          width: 250,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  )),
                              onPressed: () {
                                Future<void> _selectDate(
                                    BuildContext context) async {
                                  final DateTime? picked = await showDatePicker(
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

                                    initialDate: selectDate,
                                    firstDate: DateTime(1940, 8),
                                    lastDate: DateTime(2110),
                                  );
                                  if (picked != null && picked != selectDate) {
                                    setState(() {
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Нажимая кнопку продолжить, вы принимаете действительное ",
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      String license = await rootBundle.loadString(
                          'assets/text/license.txt');
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                                  width: 1,
                                  color: Colors.yellow
                              )
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.black,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setModalState) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
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
                                              height: MediaQuery.of(context).size.height/1.1,
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: ListView(children: [ const Text(
                                                "Лицензионное соглашение",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24),),
                                                const SizedBox(height: 16,),
                                                Text(license, ),
                                              ]
                                              )
                                          ),])
                                    ,
                                  );
                                });
                          });
                    },
                    child: const Text("Лицензионное соглашение",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,

                        )),
                  ),
              Text(
                " и ",
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1,
              ),
                ],
              ),
              const SizedBox(height: 4,),
              InkWell(
                onTap: () async {
                  String license = await rootBundle.loadString(
                      'assets/text/approval.txt');
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              width: 1,
                              color: Colors.yellow
                          )
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.black,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                            builder: (context, setModalState) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16),
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
                                          height: MediaQuery.of(context).size.height/1.1,
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: ListView(children: [ const Text(
                                            "Согласие на обработку персональных данных",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),),
                                            const SizedBox(height: 16,),
                                            Text(license, ),
                                          ]
                                          )
                                      ),])
                                ,
                              );
                            });
                      });
                },
                child: const Text("Согласие на обработку персональных данных",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,

                    )),
              ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty ||
                          firstNameController.text.isEmpty ||
                          middleNameController.text.isEmpty ||
                          lastNameController.text.isEmpty ||
                          selectDate == DateTime.now() ||
                          passwordController.text.isEmpty) {
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
                      bool email = EmailValidator.validate(emailController.text);
                      if(email == false)
                        {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: const Text("Ошибка", style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                  content: const Text(
                                    "E-Mail введен неверно",
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
                      DateTime date = DateTime.now();
                      if(selectDate.day == date.day &&
                         selectDate.month == date.month &&
                          selectDate.year == date.year)
                        {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: const Text("Ошибка", style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                  content: const Text(
                                    "Дата рождения выбрана неверно",
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
                      var newDate = DateTime(date.year - selectDate.year, date.month - selectDate.month, date.day - selectDate.day);
                      if(newDate.year<= 0016)
                        {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: const Text("Ошибка", style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                  content: const Text(
                                    "Ваша дата рождения не соответствует лицензионному соглашению",
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
                      InternetEngine()
                          .checkExist(emailController.text)
                          .then((value) {
                        if (value['answer'] == true) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: const Text("Ошибка", style: TextStyle(
                                       color: Colors.white,
                                     ),),
                                  content: const Text(
                                    "Этот e-mail уже используеться, укажите другой e-mail",
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
                        else
                          {
                            UserToRegister user = UserToRegister(
                                email: emailController.text,
                                lastName: lastNameController.text,
                                firstName: firstNameController.text,
                                middleName: middleNameController.text,
                                birthdate: selectDate,
                                seriesDriverLicense: "",
                                numberDriverLicense: "",
                                dateOfIssueDriverLicense: DateTime.now(),
                                issuedByDriverLicense: "",
                                seriesPassport: "",
                                numberPassport: "",
                                dateOfIssuePassport: DateTime.now(),
                                issuedByPassport: "",
                                password: passwordController.text);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverLicenseRegistrationScreen(
                                    user: user,
                                  )),
                            );
                          }
                      });

                    },
                    child: const Text(
                      'Продолжить',
                    )),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
