import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scooty/model/user_to_register.dart';
import 'package:scooty/screens/passport_registartion.dart';
import 'package:scooty/screens/registartion_screen.dart';
import 'package:scooty/screens/start_screen.dart';
import 'package:scooty/widgets/scooty_text_field.dart';

class DriverLicenseRegistrationScreen extends StatefulWidget {
  // DriverLicenseRegistrationScreen(@required UserToRegister user);
  final UserToRegister user;

  const DriverLicenseRegistrationScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DriverLicenseRegistrationScreenState();
  }
}

class _DriverLicenseRegistrationScreenState
    extends State<DriverLicenseRegistrationScreen> {
  TextEditingController seriesUdostController = TextEditingController();
  TextEditingController numberUdostController = TextEditingController();
  TextEditingController issuedByUdostController = TextEditingController();
  DateTime selectDate = DateTime.now();

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
              Text(
                "Регистрация водительского удостоверения",
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Серия",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ScootyTextField(
                  "6654",
                  seriesUdostController,
                  MaskTextInputFormatter(
                      mask: '####',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy)),
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
                            "Номер",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ScootyTextField(
                            "347658",
                            numberUdostController,
                            MaskTextInputFormatter(
                                mask: '######',
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy)),
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
                            "Дата выдачи",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        const SizedBox(
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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Кем выдан",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ScootyTextField(
                  "0275",
                  issuedByUdostController,
                  MaskTextInputFormatter(
                      mask: '####',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy)),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      if (seriesUdostController.text.isEmpty ||
                          numberUdostController.text.isEmpty ||
                          issuedByUdostController.text.isEmpty) {
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
                      if(selectDate.isAfter(DateTime.now())){
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
                                  "Дата выдачи выбранна неверно",
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
                      widget.user.seriesDriverLicense =
                          seriesUdostController.text;
                      widget.user.numberDriverLicense =
                          numberUdostController.text;
                      widget.user.issuedByDriverLicense =
                          issuedByUdostController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PassportRegistrationScreen(
                                  user: widget.user,
                                )),
                      );
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
