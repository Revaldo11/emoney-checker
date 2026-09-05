import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(color: color ?? AppColors.cream, border: const Border.fromBorderSide(AppTheme.border), borderRadius: AppTheme.cardRadius, boxShadow: AppTheme.shadow),
        child: child,
      );
}

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({super.key, required this.label, required this.onPressed, this.icon, this.isLoading = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : (icon == null ? null : Icon(icon));
    if (child == null) {
      return ElevatedButton(onPressed: isLoading ? null : onPressed, child: Text(label));
    }
    return ElevatedButton.icon(onPressed: isLoading ? null : onPressed, icon: child, label: Text(label));
  }
}

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => icon == null
      ? OutlinedButton(onPressed: onPressed, child: Text(label))
      : OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label));
}

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, this.color = AppColors.info});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color, border: const Border.fromBorderSide(AppTheme.border), borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}

class AppBalanceText extends StatelessWidget {
  const AppBalanceText({super.key, required this.balance, this.style});

  final String balance;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text(balance, style: (style ?? Theme.of(context).textTheme.headlineMedium)?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]));
}

class AppStatusIcon extends StatelessWidget {
  const AppStatusIcon({super.key, required this.icon, this.color = AppColors.success, this.size = 64});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, border: const Border.fromBorderSide(AppTheme.border), borderRadius: AppTheme.cardRadius, boxShadow: AppTheme.shadow),
        child: Icon(icon, size: size * .55, color: AppColors.ink),
      );
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key, required this.title, required this.onPressed, this.description, this.icon = Icons.account_balance_wallet_outlined});

  final String title;
  final String? description;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [AppStatusIcon(icon: icon, color: AppColors.pink), const SizedBox(height: 20), Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center), if (description != null) ...[const SizedBox(height: 8), Text(description!, textAlign: TextAlign.center)], const SizedBox(height: 20), AppPrimaryButton(label: 'Scan kartu pertama', onPressed: onPressed, icon: Icons.nfc)]);
}
