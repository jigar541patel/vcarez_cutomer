// import 'dart:math';

// import 'package:bookus_kiosk/extras/constant/AppColor.dart';

import 'package:flutter/material.dart';
import 'package:vcarez_new/components/common_loader.dart';

import '../utils/colors_utils.dart';

class CustomHorizontalPlaceLoader extends StatelessWidget {
  const CustomHorizontalPlaceLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 7, 5),
              child: Container(
                  width: 168,
                  height: 218,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: whiteColor,
                      ),
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10))),
                  child: const Padding(
                    padding:
                    EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    child: Center(child: CustomLoader()),
                  )));
          // Container(
          //   color: bgColor,
          //   width: MediaQuery.of(context).size.width - 10,
          //   child: const Center(child: CustomLoader()));
        });
  }
}
