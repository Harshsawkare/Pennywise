import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Color picker widget using flex_color_picker package
/// Displays a color picker with multiple picker types for selecting colors
class ColorPickerWidget extends StatefulWidget {
  /// Currently selected color
  final Color selectedColor;

  /// Callback when color is selected
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  void didUpdateWidget(ColorPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedColor != oldWidget.selectedColor) {
      _selectedColor = widget.selectedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ColorPicker(
        color: _selectedColor,
        onColorChanged: (Color color) {
          setState(() {
            _selectedColor = color;
          });
          widget.onColorChanged(color);
        },
        width: 44,
        height: 44,
        borderRadius: 4,
        spacing: 5,
        runSpacing: 5,
        wheelDiameter: 200,
        wheelWidth: 20,
        heading: Text(
          AppStrings.selectColor,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        subheading: Text(
          AppStrings.selectColorShade,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mediumGreyColor,
          ),
        ),
        showMaterialName: false,
        showColorName: false,
        showColorCode: false,
        pickersEnabled: <ColorPickerType, bool>{
          ColorPickerType.wheel: false,
          ColorPickerType.custom: true,
          ColorPickerType.primary: true,
          ColorPickerType.accent: true,
          ColorPickerType.both: false,
        },
      ),
    );
  }
}

