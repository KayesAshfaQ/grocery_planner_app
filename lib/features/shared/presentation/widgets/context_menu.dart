import 'package:flutter/material.dart';

/// Menu item for context menu
class ContextMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  ContextMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

/// Reusable context menu widget
class ContextMenu extends StatelessWidget {
  final List<ContextMenuItem> items;
  final Widget child;

  const ContextMenu({
    super.key,
    required this.items,
    required this.child,
  });

  /// Show context menu as modal bottom sheet
  static Future<void> show(
      BuildContext context, List<ContextMenuItem> items) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              return ListTile(
                leading: Icon(item.icon, color: item.color),
                title: Text(
                  item.label,
                  style: TextStyle(color: item.color),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  item.onTap();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => ContextMenu.show(context, items),
      child: child,
    );
  }
}
