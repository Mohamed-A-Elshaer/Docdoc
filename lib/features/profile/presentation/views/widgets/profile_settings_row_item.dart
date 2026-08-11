import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Row + spacing + divider for Profile / Settings lists.
///
/// Set [useSwitchRow] to true for label + [Switch] rows (no icon, no chevron).
/// Set [useRadioRow] to true for label + radio [IconButton] (no leading icon).
class ProfileSettingsRowItem extends StatelessWidget {
  const ProfileSettingsRowItem({
    super.key,
    required this.label,
    required this.textColor,
    this.useSwitchRow = false,
    this.useRadioRow = false,
    this.iconAssetPath,
    this.onTap,
    this.showDividerBelow = true,
    this.switchValue,
    this.onSwitchChanged,
    this.radioSelected,
    this.onRadioTap,
    this.beforeDividerHeight = 15,
    this.isLeadingIconActive = true,
  })  : assert(
          !useSwitchRow || (switchValue != null && onSwitchChanged != null),
        ),
        assert(
          !useRadioRow || (onRadioTap != null && radioSelected != null),
        ),
        assert(
          !(useSwitchRow && useRadioRow),
        ),
        assert(
          useSwitchRow ||
              useRadioRow ||
              iconAssetPath != null ||
              !isLeadingIconActive,
        );

  /// When true, builds a text-only label and a [Switch] trailing control.
  final bool useSwitchRow;

  /// When true, builds a text-only label and a trailing radio [IconButton].
  final bool useRadioRow;

  /// Leading icon asset; required for chevron rows when [isLeadingIconActive] is true.
  final String? iconAssetPath;
  final bool isLeadingIconActive;

  final String label;
  final Color textColor;
  final VoidCallback? onTap;
  final bool showDividerBelow;

  /// Switch row: bound to the trailing [Switch] when [useSwitchRow] is true.
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  /// Radio row: selection state when [useRadioRow] is true.
  final bool? radioSelected;
  final VoidCallback? onRadioTap;

  static const Color _chevronColor = Color(0xff242424);
  final double beforeDividerHeight;

  static const Widget _divider = Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Divider(
      thickness: 1,
      height: 2,
      color: Color(0xffEDEDED),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Widget rowContent = useSwitchRow
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyles.regular14.copyWith(color: textColor),
                  ),
                ),
                Switch(
                  value: switchValue!,
                  onChanged: onSwitchChanged,
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primaryColor;
                    }
                    return null;
                  }),
                ),
              ],
            ),
          )
        : useRadioRow
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyles.regular14.copyWith(color: textColor),
                      ),
                    ),
                    IconButton(
                      onPressed: onRadioTap,
                      icon: Icon(
                        radioSelected!
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      if (isLeadingIconActive) ...[
                        _LeadingIcon(assetPath: iconAssetPath!),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Text(
                          label,
                          style:
                              TextStyles.regular14.copyWith(color: textColor),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                        height: 25,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.chevron_right,
                            color: _chevronColor,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        rowContent,
        SizedBox(height: beforeDividerHeight),
        if (showDividerBelow) _divider,
      ],
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final isSvg = assetPath.toLowerCase().endsWith('.svg');
    if (isSvg) {
      return SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
      );
    }
    return Image.asset(
      assetPath,
      width: 24,
      height: 24,
    );
  }
}
