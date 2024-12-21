import 'package:flutter/material.dart';

import '../components/standard_regular_text.dart';
import '../utils/colors_utils.dart';

const _defaultIconSize = 25.0;
const _defaultArrowIconSize = 30.0;
const _defaultMultiContentExpandedPadding =
    EdgeInsets.only(left: 0.0, bottom: 0.0, top: 10.0);
const _defaultMultiContentCollapsedPadding = EdgeInsets.only(bottom: 0.0);

const _defaultColor = Colors.black87;

class MultiInputContainer extends StatefulWidget {
  const MultiInputContainer(
      {Key? key,
      this.title,
      this.iconData,
      this.iconChild,
      this.children,
      this.expanded = false})
      : super(key: key);

  @required
  final String? title;
  final IconData? iconData;
  final Widget? iconChild;
  @required
  final List<Widget>? children;
  final bool expanded;

  @override
  _MultiInputContainer createState() => _MultiInputContainer();
}

class _MultiInputContainer extends State<MultiInputContainer> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
  }

  @override
  void didUpdateWidget(MultiInputContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _expanded = widget.expanded;
  }

  _toggleExpandCollapse() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _toggleExpandCollapse();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: <Widget>[
                      // _icon()!,
                      _title(),
                      _expandCollapse(),
                    ],
                  ),
                ),
              ),
              _multiInputContents(),
            ],
          ),
        ));
  }

  // Widget? _icon() {
  //   if (widget.iconData != null) {
  //     return SizedBox(
  //         width: _defaultIconSize,
  //         height: _defaultIconSize,
  //         child: Icon(widget.iconData,
  //             color: _defaultColor, size: _defaultIconSize));
  //   } else {
  //     return widget.iconChild;
  //   }
  // }

  Widget _title() {
    return Expanded(
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: SizedBox(
          width: double.infinity,
          //margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: StandardCustomText(
            fontWeight: FontWeight.w900,
            maxlines: 5,
            color: textColor,
            align: TextAlign.start,
            fontSize: 14,
            label: widget.title!,
          ),
        ),
      ),
    );
  }

  Widget _expandCollapse() {
    return SizedBox(
        width: _defaultIconSize,
        height: _defaultIconSize,
        child: Icon(
            _expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            color: _defaultColor,
            size: _defaultArrowIconSize));
  }

  Widget _multiInputContents() {
    if (_expanded) {
      return Padding(
        padding: _defaultMultiContentExpandedPadding,
        child: Column(
          children: widget.children!,
        ),
      );
    } else {
      return Container(
        padding: _defaultMultiContentCollapsedPadding,
      );
    }
  }
}
