import 'package:flutter/material.dart';

import '../components/standard_regular_text.dart';

const _defaultIconSize = 25.0;
const _defaultArrowIconSize = 30.0;
const _defaultMultiContentCollapsedPadding = EdgeInsets.only(bottom: 0.0);

const _defaultColor = Colors.black87;

class MultiViewExpandContainer extends StatefulWidget {
  const MultiViewExpandContainer(
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
  _MultiViewExpandContainer createState() => _MultiViewExpandContainer();
}

class _MultiViewExpandContainer extends State<MultiViewExpandContainer> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
  }

  @override
  void didUpdateWidget(MultiViewExpandContainer oldWidget) {
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _toggleExpandCollapse();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _icon()!,
              _title(),
              _expandCollapse(),
            ],
          ),
        ),
        _multiInputContents(),
      ],
    );
  }

  Widget? _icon() {
    if (widget.iconData != null) {
      return SizedBox(
          width: _defaultIconSize,
          height: _defaultIconSize,
          child: Icon(widget.iconData,
              color: _defaultColor, size: _defaultIconSize));
    } else {
      return widget.iconChild;
    }
  }

  Widget _title() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: StandardCustomText(
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
            _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: _defaultColor,
            size: _defaultArrowIconSize));
  }

  Widget _multiInputContents() {
    if (_expanded) {
      return Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
