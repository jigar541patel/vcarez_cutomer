import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'colors_utils.dart';

class DecorationUtils {
  BuildContext context;

  DecorationUtils(this.context);

  InputDecoration getUnderlineInputDecoration({
    String? labelText = "",
    bool isRequire = false,
    bool isEnable = true,
    bool isIconDisplay = true,
    bool isSuffixIconDisplay = true,
    icon = "",
    suffixIcon = "",
  }) {
    return InputDecoration(
      fillColor: primaryColor,
      filled: true,
      errorMaxLines: 3,
      prefixIcon: isIconDisplay
          ? SvgPicture.asset(
              icon,
              fit: BoxFit.none,
            )
          : null,
      contentPadding: isIconDisplay
          ? const EdgeInsets.all(8.0)
          : const EdgeInsets.all(16.0),
      suffixIcon: isSuffixIconDisplay
          ? suffixIcon
          : null,
      labelText: labelText,
      counterText: "",
      labelStyle: const TextStyle(color: hintTextColor),
      hintStyle: const TextStyle(color: hintTextColor),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        borderSide: BorderSide(color: textFieldColor, width: 0.0),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        borderSide: BorderSide(color: textFieldColor, width: 0.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        borderSide: BorderSide(color: textFieldColor, width: 0.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        borderSide: BorderSide(color: errorColor, width: 0.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        borderSide: BorderSide(color: errorColor, width: 0.0),
      ),
    );
  }
}
