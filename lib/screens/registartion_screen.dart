import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              SizedBox(
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
              ScootyTextField("scooty@gmail.com", emailController),
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
                        SizedBox(
                          height: 20,
                        ),
                        ScootyTextField("Иванов", firstNameController),
                      ],
                    ),
                  ),
                  SizedBox(
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
                        SizedBox(
                          height: 20,
                        ),
                        ScootyTextField("Иван", lastNameController),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
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
                        ScootyTextField("Иванович", middleNameController),
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
                        Container(
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
                                    initialDate: selectDate,
                                    firstDate: DateTime(1940, 8),
                                    lastDate: DateTime(2101),
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
                                title: const Text("Ошибка"),
                                content: const Text(
                                  "Заполните все поля",
                                  style: TextStyle(
                                    color: Colors.black,
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
                      InternetEngine()
                          .checkExist(emailController.text)
                          .then((value) {
                        if (value['answer'] == true) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Ошибка"),
                                  content: const Text(
                                    "Этот e-mail уже используеться, укажите другой e-mail",
                                    style: TextStyle(
                                      color: Colors.black,
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
