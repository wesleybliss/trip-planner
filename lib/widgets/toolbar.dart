import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool showActions;
  final bool allowBackNavigation;

  const Toolbar({
    super.key,
    required this.title,
    this.height = 56.0, // Default height for AppBar
    this.showActions = true,
    this.allowBackNavigation = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  // TODO
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(""));
  }
}
