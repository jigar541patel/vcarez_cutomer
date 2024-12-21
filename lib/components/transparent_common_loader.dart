// import 'dart:math';

// import 'package:bookus_kiosk/extras/constant/AppColor.dart';

import 'package:flutter/material.dart';
import 'common_loader.dart';

class CustomTransparentLoader extends StatelessWidget {
  const CustomTransparentLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.4),
        child: const Center(child: CustomLoader()));
  }
}
