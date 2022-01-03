import 'package:da3afes/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TileButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final IconData iconData;
  const TileButton({
    Key key,
    this.text,
    this.onTap,
    this.iconData = Icons.bookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: yellowAmber,
              width: 2,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 50,
              color: yellowAmber,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
