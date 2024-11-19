import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InPutFiled extends StatefulWidget {
  InPutFiled({
    super.key,
    required this.hintText,
    required this.textEditingController,
    required this.validator,
  });
  TextEditingController textEditingController;
  String hintText;
  final String? Function(String? val) validator;

  @override
  State<InPutFiled> createState() => _InPutFiledState();
}

class _InPutFiledState extends State<InPutFiled> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //color: Colors.red,
        //height: Adaptive.h(4),
        width: Adaptive.w(55),
        child: TextFormField(
          controller: widget.textEditingController,
          style: TextStyle(fontSize: Adaptive.px(18), color: Colors.black),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          validator: widget.validator,
          decoration: InputDecoration(
              //contentPadding: EdgeInsets.symmetric(vertical: -1),
              border: InputBorder.none,
              hintText: widget.hintText),
        ));
  }
}

class EditTextFiled extends StatelessWidget {
  EditTextFiled(
      {super.key, required this.textEditingController, this.readOnly = false});
  TextEditingController textEditingController;
  bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      readOnly: readOnly!,
      controller: textEditingController,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}






