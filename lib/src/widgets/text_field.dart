import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';

/// A customizable text field widget that behaves like a dropdown input,
/// supporting decorations, read-only mode, validation, and custom borders.
class DropdownTextField extends StatefulWidget {
  /// A controller to manage the text being edited.
  final TextEditingController? controller;

  /// The initial value to be displayed in the text field.
  final String? initialValue;

  /// Hint text shown when the field is empty and not focused.
  final String? hintText;

  /// Label text shown above the input field.
  final String? labelText;

  /// Optional widget to show before the input field (e.g., an icon).
  final Widget? prefix;

  /// Optional widget to show after the input field (e.g., a clear button).
  final Widget? suffix;

  /// Callback function called when the text changes.
  final void Function(String)? onChanged;

  /// Callback function called when the field is tapped.
  final void Function()? onTap;

  /// Whether the field is enabled for interaction.
  final bool? enabled;

  /// Whether the field is read-only.
  final bool? readOnly;

  /// Custom padding for the content inside the field.
  final EdgeInsets? contentPadding;

  /// A function to validate the input value.
  final String? Function(String?)? validator;

  /// Border radius for the outline of the input field.
  final double borderRadius;

  /// Type of border to use: outline or underline.
  final TextFieldInputBorder? borderType;

  /// Color of the general border.
  final Color? borderColor;

  /// Color of the border when the field is enabled.
  final Color? enabledBorderColor;

  /// Color of the border when the field is focused.
  final Color? focusedBorderColor;

  /// Color of the border when the field has an error.
  final Color? errorBorderColor;

  /// Color of the border when the field is focused and has an error.
  final Color? focusedErrorBorderColor;

  /// Constructor for [DropdownTextField].
  const DropdownTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onTap,
    this.enabled,
    this.readOnly,
    this.contentPadding,
    this.validator,
    required this.borderRadius,
    this.borderType,
    this.borderColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
  });

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  /// Local controller to manage internal text if no external controller is provided.
  TextEditingController _controller = TextEditingController();

  /// Flag to determine whether to use a locally assigned controller.
  bool _useLocalController = false;

  @override
  void initState() {
    super.initState();

    // Initialize the controller and set the initial value if provided.
    if (widget.controller != null && widget.initialValue != null) {
      _useLocalController = true;
      _controller = widget.controller!;
      if (widget.initialValue!.isNotEmpty) {
        _controller.text = widget.initialValue!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      enabled: widget.enabled ?? true,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      controller: _useLocalController ? _controller : widget.controller,
      decoration: InputDecoration(
        counterText: "", // Removes the character counter for better UI.
        // Apply theme-based styles for hint and label text.
        hintStyle: context.textTheme.bodyLarge!.copyWith(color: Colors.grey),
        labelStyle: context.textTheme.bodyLarge!.copyWith(color: Colors.grey),

        // Add asterisk for required fields based on the validator.
        hintText:
            widget.hintText == null
                ? null
                : "${widget.hintText}${widget.validator != null ? '*' : ''}",
        labelText:
            widget.labelText == null
                ? null
                : "${widget.labelText}${widget.validator != null ? '*' : ''}",

        // Prefix and suffix widgets (e.g., icons).
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,

        // Theme-based icon colors.
        prefixIconColor: context.iconColor,
        suffixIconColor: context.iconColor,

        // Apply custom borders based on state.
        border: _borderType(DifferentBorder.border),
        enabledBorder: _borderType(
          DifferentBorder.enabledBorder,
          borderWidth: 1.0,
        ),
        focusedBorder: _borderType(DifferentBorder.focusedBorder),
        errorBorder: _borderType(DifferentBorder.errorBorder),
        focusedErrorBorder: _borderType(DifferentBorder.focusedErrorBorder),
      ),
    );
  }

  /// Returns the appropriate input border based on the selected [TextFieldInputBorder] type.
  InputBorder _borderType(DifferentBorder border, {double borderWidth = 2.0}) {
    switch (widget.borderType) {
      case TextFieldInputBorder.underLine:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: _borderBasedColor(border),
            width: borderWidth,
          ),
        );

      case TextFieldInputBorder.outLine:
      default:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: _borderBasedColor(border),
            width: borderWidth,
          ),
        );
    }
  }

  /// Returns the color to be used for a specific [DifferentBorder] type.
  Color _borderBasedColor(DifferentBorder border) {
    switch (border) {
      case DifferentBorder.border:
        return widget.borderColor ?? context.borderColor;

      case DifferentBorder.enabledBorder:
        return widget.enabledBorderColor ?? context.enabledBorderColor;

      case DifferentBorder.focusedBorder:
        return widget.focusedBorderColor ?? context.primaryColor;

      case DifferentBorder.errorBorder:
        return widget.errorBorderColor ?? context.errorColor;

      case DifferentBorder.focusedErrorBorder:
        return widget.focusedErrorBorderColor ?? context.errorColor;
    }
  }
}
