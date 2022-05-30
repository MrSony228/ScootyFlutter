import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ScootyTextField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;
  final MaskTextInputFormatter maskFormater;


  const ScootyTextField(this.hint, this.controller, this.maskFormater);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [maskFormater],
      style: const TextStyle(color: Colors.black, fontSize: 17),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(7.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide:const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(7.0),
        ),
        hintText: hint,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
        hintStyle: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }



}