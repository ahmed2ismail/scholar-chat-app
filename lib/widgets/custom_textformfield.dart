import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.onChanged, this.obscureText=false,
  });

  final String? hintText;
  final Function(String)? onChanged;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    // هنحول ال TextField الي TextFormField عشان عملية ال validate تتم صح
    return TextFormField(
      obscureText: obscureText!,
      // هنستخدم خاصية ال validator اللي جوه ال TextFormField عشان نحدد القواعد او القيم اللي المناسبة لينا واللي هنستقبلها من TextFormField
      validator: (value) {
        // value : الداتا اللي هتيجي من المستخدم عن طريق ال TextFormField
        if (value!.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
