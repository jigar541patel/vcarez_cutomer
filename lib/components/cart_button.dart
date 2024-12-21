import 'package:flutter/material.dart';

import '../utils/colors_utils.dart';

class CartButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fontSize;

  const CartButton({
    Key? key,
    @required this.buttonText,
    this.color,
    this.onPressed,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
      color: color ?? darkSkyBluePrimaryColor.withOpacity(0.5),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
      disabledColor: Theme.of(context).disabledColor.withOpacity(0.5),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            buttonText!,
            style: TextStyle(
              fontSize: fontSize,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
