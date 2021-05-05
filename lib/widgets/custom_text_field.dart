import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool copied;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.copied = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Theme.of(context).accentColor,
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(10.0),
            hintText: hintText,
          ),
        ),
        copied
            ? Positioned(
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.text));
                  },
                  child: Icon(Icons.copy),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
