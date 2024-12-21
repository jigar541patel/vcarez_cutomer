import 'package:flutter/material.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';

import '../../../../../utils/colors_utils.dart';

class Search extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: Container(child: StandardCustomText(label: 'Search',),)),
    );
  }
}
