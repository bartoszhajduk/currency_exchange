import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrChart extends StatefulWidget {
  final List<double> values;
  final double height;
  final double width;
  final Function(int, double) onPressed;
  final Color backgroundColor;
  final Color barColor;
  final Color selectedBarColor;
  final double barRadiusValue;
  final double separatorWidth;
  final int selected;

  CurrChart({
    this.values = const [],
    @required this.height,
    @required this.width,
    @required this.onPressed,
    @required this.selected,
    this.backgroundColor = Colors.white,
    this.barColor = Colors.grey,
    this.selectedBarColor = Colors.blue,
    this.barRadiusValue = 9.0,
    this.separatorWidth = 0.0,
  });

  @override
  _CurrChartState createState() => _CurrChartState();
}

class _CurrChartState extends State<CurrChart> {
  @override
  Widget build(BuildContext context) {
    final maxVal = widget.values.isNotEmpty ? findMaxValue() : 0;
    final minVal = widget.values.isNotEmpty ? findMinValue() : 0;
    final valuesSize = widget.values.length;
    final valuesMap = widget.values.asMap();
    return Container(
      height: widget.height,
      width: widget.width,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: valuesMap.entries.map((entry) {
          final shift = minVal / 1.005;
          final filledHeight =
              ((entry.value - shift) * widget.height) / (maxVal - shift);
          return GestureDetector(
            onTap: () {
              widget.onPressed(entry.key, entry.value);
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                /// REST OF SPACE
                Container(
                  color: widget.backgroundColor,
                  height: widget.height,
                  width: widget.width / valuesSize,
                ),

                /// * * * FILLED * * *
                Container(
                  width: (widget.width / valuesSize) -
                      (widget.separatorWidth * widget.values.length),
                  height: filledHeight,
                  decoration: BoxDecoration(
                    color: entry.key == widget.selected
                        ? widget.selectedBarColor
                        : widget.barColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.barRadiusValue),
                      topRight: Radius.circular(widget.barRadiusValue),
                    ),
                  ),
                ),
                SizedBox(width: widget.separatorWidth),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  double findMaxValue() {
    var maxVal = widget.values[0];

    for (var v in widget.values) {
      if (v > maxVal) maxVal = v;
    }

    return maxVal;
  }

  double findMinValue() {
    var maxVal = widget.values[0];

    for (var v in widget.values) {
      if (v < maxVal) maxVal = v;
    }

    return maxVal;
  }
}
