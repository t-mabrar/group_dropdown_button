import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';

/// A custom text field widget, primarily designed for use within the [GroupDropdownButton].
/// It extends [StatefulWidget] to manage its own [TextEditingController] if one is not provided.
///
/// This widget provides a standardized appearance and behavior for the text input
/// part of the dropdown, including handling for initial values, hints, labels,
/// prefixes, suffixes, and various border styles.
class DropdownTextField extends StatefulWidget {
  /// An optional controller to manage the text field's content.
  /// If not provided, the widget will create and manage its own.
  final TextEditingController? controller;

  /// An initial value to display in the text field.
  /// This is used if a [controller] is also provided and has an empty text.
  final String? initialValue;

  /// Hint text to display when the text field is empty.
  final String? hintText;

  /// Label text to display above or floating over the text field.
  final String? labelText;

  /// An optional widget to display before the text input area.
  final Widget? prefix;

  /// An optional widget to display after the text input area.
  final Widget? suffix;

  /// Callback function that is invoked when the text in the field changes.
  final void Function(String)? onChanged;

  /// Callback function that is invoked when the text field is tapped.
  final void Function()? onTap;

  /// Whether the text field is enabled for user interaction. Defaults to `true`.
  final bool? enabled;

  /// Whether the text field is read-only. Defaults to `false`.
  final bool? readOnly;

  /// Padding for the content within the text field.
  final EdgeInsets? contentPadding;

  /// A validator function that takes the current text value and returns an error string
  /// if validation fails, or `null` otherwise.
  final String? Function(String?)? validator;

  /// The border radius for the text field, used when [borderType] is [TextFieldInputBorder.outLine].
  final double borderRadius;

  /// The type of border to display around the text field (outline or underline).
  final TextFieldInputBorder? borderType;

  /// The color of the text field's border when it's in its default state.
  final Color? borderColor;

  /// The color of the text field's border when it is enabled.
  final Color? enabledBorderColor;

  /// The color of the text field's border when it is focused.
  final Color? focusedBorderColor;

  /// The color of the text field's border when it has an error.
  final Color? errorBorderColor;

  /// The color of the text field's border when it is focused and has an error.
  final Color? focusedErrorBorderColor;

  /// Creates a [DropdownTextField].
  ///
  /// All parameters are optional except for [borderRadius].
  /// The [controller] and [initialValue] can be used together; if [controller]
  /// is provided and [initialValue] is also set, the [controller]'s text
  /// will be set to [initialValue] if the controller's text is initially empty.
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

/// State class for [DropdownTextField].
class _DropdownTextFieldState extends State<DropdownTextField> {
  /// The local [TextEditingController] used if no external controller is provided
  /// or if an initial value needs to be set on a provided controller.
  TextEditingController _controller = TextEditingController();

  /// Flag to determine if the local [_controller] should be used or the [widget.controller].
  bool _useLocalController = false;

  @override
  void initState() {
    super.initState();

    // If an external controller is provided AND an initial value is given,
    // use the external controller and set its text to the initial value if it's currently empty.
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
    // Uses TextFormField for built-in validation and form integration.
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      enabled: widget.enabled ?? true,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      controller: _useLocalController ? _controller : widget.controller,
      decoration: InputDecoration(
        // Hides the default counter text.
        counterText: "",

        // Styles for hint and label text, derived from the current theme.
        hintStyle: context.textTheme.bodyLarge!.copyWith(color: Colors.grey),
        labelStyle: context.textTheme.bodyLarge!.copyWith(color: Colors.grey),

        // Appends an asterisk (*) to hint and label text if a validator is present,
        // indicating a required field.
        hintText:
            widget.hintText == null
                ? null
                : "${widget.hintText}${widget.validator != null ? '*' : ''}",
        labelText:
            widget.labelText == null
                ? null
                : "${widget.labelText}${widget.validator != null ? '*' : ''}",

        // Assigns prefix and suffix icons/widgets.
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,

        prefixIconColor: context.iconColor,
        suffixIconColor: context.iconColor,

        // Defines the various border styles based on the field's state.
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

  /// Determines the appropriate [InputBorder] based on the [widget.borderType].
  ///
  /// [border] specifies which state of the border is being drawn (e.g., default, focused, error).
  /// [borderWidth] is the width of the border line.
  InputBorder _borderType(DifferentBorder border, {double borderWidth = 2.0}) {
    switch (widget.borderType) {
      case TextFieldInputBorder.underLine:
        // Returns an UnderlineInputBorder if specified.
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: _borderBasedColor(border),
            width: borderWidth,
          ),
        );

      case TextFieldInputBorder.outLine:
      default:
        // Defaults to OutlineInputBorder.
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: _borderBasedColor(border),
            width: borderWidth,
          ),
        );
    }
  }

  /// Determines the color of the border based on its state and provided widget properties.
  ///
  /// [border] specifies the current state of the border (e.g., default, enabled, focused).
  /// It prioritizes explicitly set colors from the widget's properties, falling back to
  /// theme-derived colors via `context` extensions if not provided.
  Color _borderBasedColor(DifferentBorder border) {
    switch (border) {
      case DifferentBorder.border:
        // Default border color.
        return widget.borderColor ?? context.borderColor;

      case DifferentBorder.enabledBorder:
        // Border color when the field is enabled.
        return widget.enabledBorderColor ?? context.enabledBorderColor;

      case DifferentBorder.focusedBorder:
        // Border color when the field is focused.
        return widget.focusedBorderColor ?? context.primaryColor;

      case DifferentBorder.errorBorder:
        // Border color when the field has a validation error.
        return widget.errorBorderColor ?? context.errorColor;

      case DifferentBorder.focusedErrorBorder:
        // Border color when the field is focused and has a validation error.
        return widget.focusedErrorBorderColor ?? context.errorColor;
    }
  }
}
