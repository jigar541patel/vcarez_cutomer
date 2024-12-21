// import 'dart:math';

// import 'package:bookus_kiosk/extras/constant/AppColor.dart';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../utils/colors_utils.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      width: 100,
      child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotate,

          /// Required, The loading type of the widget
          colors: [darkSkyBluePrimaryColor],

          /// Optional, The color collections
          strokeWidth: 2,

          /// Optional, The stroke of the line, only applicable to widget which contains line
          // backgroundColor: whiteTransparentColor,
          /// Optional, Background of the widget
          pathBackgroundColor: whiteTransparentColor

          /// Optional, the stroke backgroundColor
          ),
    );
  }
}
