import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldForDigits extends StatelessWidget {
  final String label;

  /// This widget DOES NOT dispose of the controller by itself.
  final TextEditingController controller;
  const TextFieldForDigits({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            onPressed: () {
              constrainDigits();

              controller.text = (int.parse(controller.text) + 1).toString();
            },
            icon: const Icon(Icons.add)),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (text) {
              if (text.length > 2) controller.text = 100.toString();
              if (controller.text == '0') controller.text = 1.toString();
            },
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                label: Center(
                  child: Text(
                    label,
                  ),
                )),
          ),
        ),
        IconButton(
            onPressed: () {
              constrainDigits();

              if (int.parse(controller.text) <= 1) return;
              controller.text = (int.parse(controller.text) - 1).toString();
            },
            icon: const Icon(Icons.remove)),
      ],
    );
  }

  void constrainDigits() {
    if (controller.text.isEmpty) controller.text = 1.toString();
    if (controller.text.length > 2) controller.text = 99.toString();
    if (int.parse(controller.text) - 1 == 0) controller.text = 1.toString();
  }
}
