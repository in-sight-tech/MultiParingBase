import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/enums.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final RecordStates state;
  final void Function(RecordStates) onPressed;
  final List<Icon> icons = const [
    Icon(Icons.play_arrow_rounded),
    Icon(Icons.pause_rounded),
  ];

  const CustomFloatingActionButton({
    super.key,
    required this.state,
    required this.onPressed,
  });

  RecordStates nextEnum(RecordStates value) {
    final nextIndex = (value.index + 1) % RecordStates.values.length;
    return RecordStates.values[nextIndex];
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(nextEnum(state)),
      child: icons[state.index],
    );
  }
}
