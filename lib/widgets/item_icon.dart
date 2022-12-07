import 'package:flutter/material.dart';

class ItemIcon extends StatefulWidget {
  final String icon;

  const ItemIcon({super.key, required this.icon});

  @override
  State<ItemIcon> createState() => _ItemIconState();
}

class _ItemIconState extends State<ItemIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(217, 39, 46, 1),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.all(5), child: Image.asset(widget.icon)),
    );
  }
}
