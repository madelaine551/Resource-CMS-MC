import 'package:flutter/material.dart';

class IconBoxButton extends StatefulWidget {
  final String icon;
  final action;
  const IconBoxButton({super.key, required this.icon, required this.action});

  @override
  State<IconBoxButton> createState() => _IconBoxButtonState();
}

class _IconBoxButtonState extends State<IconBoxButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(65, 65, 65, 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
                onPressed: () {
                  widget.action();
                },
                iconSize: 30,
                icon: Image.asset(widget.icon))));
  }
}
