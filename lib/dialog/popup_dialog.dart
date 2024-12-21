import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vcarez_new/components/my_theme_button.dart';
import 'package:vcarez_new/utils/colors_utils.dart';

class PopupDialog extends StatefulWidget {
  PopupDialog(
      {Key? key,
      this.text,
      this.onPressedYes,
      this.style,
      this.textAlign,
      this.yesText,
      this.onPressedNo,
      this.noText,
      this.onClose})
      : super(key: key);

  @required
  final String? text;

  @required
  final VoidCallback? onPressedYes;
  final VoidCallback? onPressedNo;
  final VoidCallback? onClose;
  @required
  final String? yesText;

  String? noText;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  _PopupDialogState createState() {
    return _PopupDialogState();
  }
}

class _PopupDialogState extends State<PopupDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(widget.text!,
                  style: widget.style, textAlign: widget.textAlign),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (widget.noText == null || widget.noText == "")
                      ? SizedBox()
                      : Expanded(child: _buttonNo()),
                  (widget.noText == null || widget.noText == "")
                      ? SizedBox()
                      : SizedBox(width: 10),
                  Expanded(child: _buttonYes())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buttonYes() {
    return MyThemeButton(
        buttonText: widget.yesText,
        // : TextAlign.center,
        onPressed: () {
          widget.onPressedYes?.call();
        });
  }

  _buttonNo() {
    return Container(
      child: MyThemeButton(
          buttonText: widget.noText!,
          color: greyColor,

          onPressed: () {
            widget.onPressedNo?.call();
          }),
    );
  }
}
