import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget2 extends StatelessWidget {
  final String title1;
  final String hint1;
  final TextEditingController? controller1;
  final bool isNumeric;
  final int? maxLength1;
  final int? maxLength2;

  const TextFieldWidget2({
    super.key,
    required this.title1,
    required this.hint1,
    this.controller1,
    this.isNumeric = false,
    this.maxLength1,
    this.maxLength2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title1,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.only(left: 10),
                //height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: controller1,
                  keyboardType: isNumeric
                      ? TextInputType.number
                      : TextInputType.text,
                  maxLength: maxLength1 ?? (isNumeric ? 3 : null),
                  inputFormatters: isNumeric
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : [],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint1,
                    hintStyle: TextStyle(color: Colors.grey),
                    counterText: '',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
