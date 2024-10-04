import 'package:flutter/material.dart';
import '../../constants/colors.dart';


class SubTitle extends StatelessWidget {
  final String title;

  const SubTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textWhite,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
