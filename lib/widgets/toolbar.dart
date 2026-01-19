import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool showActions;
  final bool allowBackNavigation;
  final List<Widget>? actions;

  const Toolbar({
    super.key,
    required this.title,
    this.height = 56.0, // Default height for AppBar
    this.showActions = true,
    this.allowBackNavigation = false,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // Default actions if none provided
    List<Widget> appBarActions = [];
    if (actions != null) {
      appBarActions = actions!;
    } else if (showActions) {
      // Add default actions here if needed
      appBarActions = [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
      ];
    }

    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: allowBackNavigation,
      leading: allowBackNavigation
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      actions: appBarActions,
    );
  }
}
