import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/share/style/const.dart';

import '../../modules/login_screen/login_screen.dart';
import '../network/remote/cach_helper.dart';

Widget defaultMaterialButton({
  context,
  required Function onPressed,
  required String text,
  double high = 40,
  double width = 150,
  Color color = Colors.deepPurple,
  Color textColor = Colors.white,
  bool isUpperCase = false,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
      child: Container(
        width: width,
        height: high,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: color,
        ),
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: TextStyle(color: textColor, fontSize: 16.0),
          ),
        ),
      ),
    ),
  );
}

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value == true) {
      navigateToAndFinish(context, LoginScreen());
    }
  });
}

defaultText(
    {required String text,
    double size = 18.0,
    fontWeight,
    double letterSpacing = 0.0,
    Color color = Colors.black,
    isUpperCase = false}) {
  return Text(
    isUpperCase ? text.toUpperCase() : text,
    style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color),
  );
}

defaultTextButton(
    {required Function onPressed,
    required String text,
    fontWeight,
    double? size,
    bool isUpperCase = false}) {
  return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(fontWeight: fontWeight, fontSize: size)));
}

navigateToAndFinish(context, Widget widget) {
  return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

navigateTo(context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigateAndReplace(context, Widget widget) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyBoardTyp,
  required BuildContext context,
  required String text,
  Icon? icon,
  Function? onSubmitted,
  required String validateText,
  Widget? widget,
  IconButton? suffixIcon,
  bool obscure = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyBoardTyp,
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(25.0)),
        label: Text(text),
        filled: true,
        fillColor: Colors.black12,
        prefixIcon: icon,
        prefix: widget ,
        suffixIcon: suffixIcon,
        prefixIconColor: defaultColor[500],
        suffixIconColor: defaultColor[500],
        iconColor: Theme.of(context).primaryColor),
    onFieldSubmitted: (String value) {
      onSubmitted!(value);
    },
    validator: (value) {
      if (value!.isEmpty) {
        return validateText;
      }
      return null;
    },
  );
}

snackBar(
    {required message,
    required title,
    required ContentType contentType,
    int seconds = 4}) {
  return SnackBar(
    backgroundColor: Colors.white,
    content: AwesomeSnackbarContent(
      title: title,
      contentType: contentType,
      message: message,
    ),
    duration: Duration(seconds: seconds),
  );
}
