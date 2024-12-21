import 'package:flutter/material.dart';

import '../utils/colors_utils.dart';

class MyThemeButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;

  const MyThemeButton({
    Key? key,
    @required this.buttonText,
    this.color,
    this.textColor,
    this.onPressed,
    this.borderRadius = 24,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius!)),
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
      color: color ?? darkSkyBluePrimaryColor,
      splashColor: Theme.of(context).primaryColor,
      disabledColor: Theme.of(context).disabledColor,
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            buttonText!,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
