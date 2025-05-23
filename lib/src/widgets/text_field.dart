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

  /// Style for the hint text.
  final TextStyle? hintStyle;

  /// Label text to display above or floating over the text field.
  final String? labelText;

  /// Style for the label text.
  final TextStyle? labelStyle;

  /// Style for the text field.
  final TextStyle? textStyle;

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
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
  });

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

/// State class for [DropdownTextField].
class _DropdownTextFieldState extends State<DropdownTextField> {
  /// The [TextEditingController] that will be used by the [TextFormField].
  /// This can be either the `widget.controller` if provided, or a locally created one.
  late TextEditingController _effectiveController;

  /// Tracks whether the [_effectiveController] was created locally by this state.
  /// If `true`, this state is responsible for disposing it.
  bool _isLocalController = false;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  /// Sets up or updates the [_effectiveController] based on `widget.controller` and `widget.initialValue`.
  void _setupController() {
    if (widget.controller == null) {
      // No external controller provided, create and manage a local one.
      _effectiveController = TextEditingController(
        text: widget.initialValue ?? '',
      );
      _isLocalController = true;
    } else {
      // External controller is provided.
      _effectiveController = widget.controller!;
      _isLocalController = false;
      // If initialValue is also provided and the external controller's text is empty,
      // set its text. This helps initialize an empty external controller.
      if (widget.initialValue != null && _effectiveController.text.isEmpty) {
        _effectiveController.text = widget.initialValue!;
      }
    }
  }

  @override
  void didUpdateWidget(covariant DropdownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool controllerIdentityChanged =
        widget.controller != oldWidget.controller;

    if (controllerIdentityChanged) {
      // If we were managing a local controller previously, and it's not the new controller
      // (i.e., widget.controller is now provided, or widget.controller is null again after being non-null),
      // then dispose the old local controller.
      if (_isLocalController && _effectiveController != widget.controller) {
        _effectiveController.dispose();
      }
      // Re-initialize the controller (either use the new widget.controller or create a new local one).
      _setupController();
    } else {
      // The controller instance itself hasn't changed (or both were/are null).
      // Now, check if initialValue has changed.
      if (widget.initialValue != oldWidget.initialValue) {
        // If initialValue changes, update the text of the _effectiveController.
        // This makes initialValue behave like a "value" prop that can be changed externally.
        // We update only if the current text is different to avoid unnecessary controller notifications.
        if (_effectiveController.text != (widget.initialValue ?? '')) {
          _effectiveController.text = widget.initialValue ?? '';
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This method is called when dependencies of this State object change.
    // For example, if you were using an InheritedWidget and its value changed.
    // In this specific widget, there aren't obvious direct dependencies that
    // would typically be handled here.
  }

  @override
  void dispose() {
    // Dispose the controller only if it was created and is managed locally by this state.
    if (_isLocalController) {
      _effectiveController.dispose();
    }
    super.dispose();
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
      style: widget.textStyle,
      controller: _effectiveController, // Use the managed effective controller
      decoration: InputDecoration(
        // Hides the default counter text.
        counterText: "",

        // Styles for hint and label text, derived from the current theme.
        hintStyle:
            widget.hintStyle ??
            context.textTheme.bodyLarge!.copyWith(color: Colors.grey),
        labelStyle:
            widget.labelStyle ??
            context.textTheme.bodyLarge!.copyWith(color: Colors.grey),

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
