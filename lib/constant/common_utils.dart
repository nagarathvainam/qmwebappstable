import 'package:flutter/material.dart';
class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message,) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(message),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
    );
  }
}



class OrdinalUtils {
  static String getOrdinal(int number) {
    if (!(number >= 1 && number <= 100)) { //here you change the range
      throw Exception('Invalid number');
    }

    if (number >= 11 && number <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}


//
// class ColorUtils {
//    colorFromHex(String hexColor) {
//     final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
//     return Color(int.parse('FF$hexCode', radix: 16));
//   }
// }

class ColorUtils {
  static Color colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

