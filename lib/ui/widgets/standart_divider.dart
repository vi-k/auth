import 'package:auth/const/values.dart';
import 'package:flutter/material.dart';

class StandartDivider extends StatelessWidget {
  const StandartDivider({
    Key? key,
    this.height = Values.commonSpacing,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
