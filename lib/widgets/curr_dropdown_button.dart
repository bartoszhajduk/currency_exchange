import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrDropdownButton extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final List<String> itemList;
  final Color iconColor;
  final Color textColor;
  final Color buttonColor;

  CurrDropdownButton({
    @required this.value,
    @required this.onChanged,
    @required this.itemList,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.buttonColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: DropdownButton(
          underline: SizedBox(),
          iconSize: 30.0,
          iconEnabledColor: iconColor,
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          items: itemList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: textColor),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
