import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scooty/internet_engine.dart';
import 'package:scooty/model/user_to_register.dart';
import 'package:scooty/widgets/scooty_text_field.dart';

class PassportRegistrationScreen extends StatefulWidget {
  final UserToRegister user;

  const PassportRegistrationScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PassportRegistrationScreenState();
  }
}

class _PassportRegistrationScreenState
    extends State<PassportRegistrationScreen> {
  TextEditingController seriesUdostController = TextEditingController();
  TextEditingController numberUdostController = TextEditingController();
  TextEditingController issuedByUdostController = TextEditingController();
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: ListView(children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                "Регистрация паспорта",
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                textAlign: TextAlign.center,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Серия",
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle2,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle2,
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
                                      initialDate: selectDate,
                                      firstDate: DateTime(1940, 8),
                                      lastDate: DateTime(2101));
                                  if (picked != null && picked != selectDate) {
                                    setState(() {
                                      selectDate = picked;
                                      widget.user.dateOfIssuePassport =
                                          selectDate;
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ScootyTextField("Отделом УФМС Росиии...", issuedByUdostController,
                  MaskTextInputFormatter()),
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                      if (seriesUdostController.text.isEmpty ||
                          numberUdostController.text.isEmpty ||
                          issuedByUdostController.text.isEmpty ||
                          selectDate.isAfter(DateTime.now())) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                title: const Text("Ошибка", style: TextStyle(
                                  color: Colors.white,
                                ),),
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
                      widget.user.seriesPassport = seriesUdostController.text;
                      widget.user.numberPassport = numberUdostController.text;
                      widget.user.issuedByPassport =
                          issuedByUdostController.text;
                      var result = await InternetEngine().register(widget.user);
                      if (result != 200) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Ошибка"),
                                content: Text(
                                  "Код ошибки: " + result.toString(),
                                  style: const TextStyle(
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


                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //          EmailConfirmationScreen(user: widget.user,)),
                      // );
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
