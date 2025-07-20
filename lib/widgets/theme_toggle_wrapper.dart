import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme_cubit.dart';

class ThemeToggleWrapper extends StatelessWidget {
  final Widget child;

  const ThemeToggleWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            child: const Icon(Icons.brightness_6),
          ),
        ),
      ],
    );
  }
}
