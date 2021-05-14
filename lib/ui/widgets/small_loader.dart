import 'package:flutter/material.dart';

/// Прогресс-индикатор загрузки для небольших виджетов.
class SmallLoader extends StatelessWidget {
  const SmallLoader({
    Key? key,
    this.color,
  }) : super(key: key);

  /// Цвет прогресс-индикатора.
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(color),
          strokeWidth: 2,
        ),
      );
}
