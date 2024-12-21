import 'package:flutter/material.dart';

import '../utils/colors_utils.dart';

class StandardCustomText extends StatelessWidget {
  final String label;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final int? maxlines;
  final TextDecoration? decoration;
  final TextStyle? style;

  const StandardCustomText(
      {Key? key,
      required this.label,
      this.color = primaryTextColor,
      this.fontSize = 13.0,
      this.fontWeight = FontWeight.normal,
      this.align = TextAlign.center,
      this.maxlines,
      this.decoration = TextDecoration.none,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: align,
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      style: style ?? TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: FontStyle.normal,
              decoration: decoration),
    );
  }
}
