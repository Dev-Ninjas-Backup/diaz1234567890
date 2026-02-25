import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String title1;
  final String title2;
  final String hint1;
  final String hint2;
  final TextEditingController? controller1;
  final TextEditingController? controller2;
  final bool isNumeric;
  final int? maxLength1;
  final int? maxLength2;

  const TextFieldWidget({
    super.key,
    required this.title1,
    required this.title2,
    required this.hint1,
    required this.hint2,
    this.controller1,
    this.controller2,
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
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title2,
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
                  controller: controller2,
                  keyboardType: isNumeric
                      ? TextInputType.number
                      : TextInputType.text,
                  maxLength: maxLength2 ?? (isNumeric ? 2 : null),
                  inputFormatters: isNumeric
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : [],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint2,
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
