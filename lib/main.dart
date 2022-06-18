
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scooty/model/local_storage.dart';
import 'package:scooty/model/user_to_register.dart';
import 'package:scooty/screens/main_screen.dart';
import 'package:scooty/screens/passport_registartion.dart';
import 'package:scooty/screens/start_screen.dart';

String token = "";

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().getToken().then((String result){
   token = result;
  });
  var mySystemTheme = SystemUiOverlayStyle.light
      .copyWith(systemNavigationBarColor: Colors.black);
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, token}) : super(key: key);

  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scooty',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''),
       // Locale('en', '')
      ],
      theme: ThemeData(
        fontFamily: 'CeraPro',
        primaryColor: const Color.fromRGBO(38, 38, 38, 0),
        backgroundColor: const Color.fromRGBO(38, 38, 38, 0),
        textTheme: const TextTheme(
          subtitle1: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          subtitle2: TextStyle(fontSize: 15),
          bodyText1: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold))),
      ),

      home: _getStartupScreen(),
    );
  }

  Widget _getStartupScreen() {
    if (token != "") {
      return const MainScreen();
    } else {
      return const StartScreen();
    }
  }
//   Widget _getStartupScreen()   {
//     UserToRegister user = UserToRegister(
//         email: 'emailController.text',
//         lastName: 'lastNameController.text',
//         firstName: 'firstNameController.text',
//         middleName: 'middleNameController.text',
//         birthdate: DateTime.now(),
//         seriesDriverLicense: "",
//         numberDriverLicense: "",
//         dateOfIssueDriverLicense: DateTime.now(),
//         issuedByDriverLicense: "",
//         seriesPassport: "",
//         numberPassport: "",
//         dateOfIssuePassport: DateTime.now(),
//         issuedByPassport: "",
//         password: 'passwordController.text');
//       return PassportRegistrationScreen(user: user);
//     }
// }
     }
