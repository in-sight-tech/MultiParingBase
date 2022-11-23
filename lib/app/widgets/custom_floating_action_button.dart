import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final bool? state;
  final void Function(bool?) onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (state == null)
          FloatingActionButton(
            onPressed: () => onPressed(null),
            child: const Icon(Icons.play_arrow_rounded),
          ),
        if (state == true)
          FloatingActionButton(
            onPressed: () => onPressed(true),
            child: const Icon(Icons.pause_rounded),
          ),
        if (state == false)
          FloatingActionButton(
            onPressed: () => onPressed(null),
            child: const Icon(Icons.play_arrow_rounded),
          ),
        if (state == false) const SizedBox(width: 10),
        if (state == false)
          FloatingActionButton(
            onPressed: () => onPressed(false),
            child: const Icon(Icons.stop_rounded),
          ),
      ],
    );
  }
}
