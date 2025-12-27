import 'package:flutter/material.dart';

import '../export.dart';

class CustomPopupOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const CustomPopupOption({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppColors.darkGrey),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextTheme.size14Bold.copyWith(
                      color: titleColor ?? AppColors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextTheme.size12Normal),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

/// Generalized function to show the popup
Future<Future<Object?>> showCustomPopupMenu({
  required BuildContext context,
  required Offset tapPosition,
  required List<CustomPopupOption> options,
}) async {
  final popupHeight = options.length * 56.0 + 16;
  final screenSize = MediaQuery.of(context).size;
  final popupWidth = screenSize.width.clamp(0.0, 264.0) - 48.0;

  double left = tapPosition.dx - popupWidth / 2;
  left = left.clamp(16.0, screenSize.width - popupWidth - 16.0);

  double top = tapPosition.dy - popupHeight - 12;
  final placeBelow = top < MediaQuery.of(context).padding.top + 12;
  if (placeBelow) top = tapPosition.dy + 12;

  return showGeneralDialog(
    context: context,
    barrierLabel: "Custom Popup Menu",
    barrierDismissible: true,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => const SizedBox.shrink(),
    transitionBuilder: (ctx, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.75, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                left: left,
                top: top,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Main menu card
                      Container(
                        width: popupWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < options.length; i++) ...[
                              options[i],
                              if (i != options.length - 1)
                                const Divider(height: 1),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Cancel button
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          width: popupWidth,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text('Cancel', style: AppTextTheme.size14Bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
