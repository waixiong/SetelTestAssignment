import 'package:Setel_Test_Assignment/main.dart';
import 'package:Setel_Test_Assignment/view/screen/undefined_page.dart';
import 'package:flutter/material.dart';

// class ChangeSiblingsArguments {
//   final List<Student> students;
//   final ProfileModel model;
//   // final int selection;

//   ChangeSiblingsArguments({@required this.students, @required this.model});
// }

// Route<dynamic> loginPage = MaterialPageRoute(builder: (context) => LoginScreen());

// handle all routing here
Route<dynamic> generateRoute(RouteSettings settings) {
  // ModalRoute.of(context).settings.arguments
  switch (settings.name) {
    case RouteName.wifi:
      return MaterialPageRoute(builder: (context) => MyHomePage(), settings: settings);
    // default:
    //   throw UnsupportedError('Unknown route: ${settings.name}');

    default:
      return MaterialPageRoute(
        builder: (context) => UndefinedPage(
          name: settings.name,
        )
      );
  }
}

class RouteName {
  static const String wifi = '/wifi';
}