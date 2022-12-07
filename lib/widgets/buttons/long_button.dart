import 'package:flutter/material.dart';

class LongButton extends StatefulWidget {
  final action;
  final String icon;
  final String text;

  const LongButton(
      {super.key,
      required this.action,
      required this.icon,
      required this.text});

  @override
  State<LongButton> createState() => _LongButtonState();
}

class _LongButtonState extends State<LongButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(65, 65, 65, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: widget.action,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        widget.icon,
                        width: 30,
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
