import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';

class DropdownTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool? enabled;
  final bool? readOnly;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validator;

  final double borderRadius;
  final TextFieldInputBorder? borderType;
  final Color? borderColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? focusedErrorBorderColor;

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
  TextEditingController _controller = TextEditingController();
  bool _useLocalController = false;

  @override
  void initState() {
    if (widget.controller != null && widget.initialValue != null) {
      _useLocalController = true;
      _controller = widget.controller!;
      if (widget.initialValue!.isNotEmpty) {
        _controller.text = widget.initialValue!;
      }
    }
    super.initState();
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
        counterText: "",
        hintStyle: context.textTheme.bodyLarge!.copyWith(color: Colors.grey),
        hintText:
            widget.hintText == null
                ? null
                : "${widget.hintText}${widget.validator != null ? '*' : ''}",
        labelText:
            widget.labelText == null
                ? null
                : "${widget.labelText}${widget.validator != null ? '*' : ''}",
        labelStyle: context.textTheme.bodyLarge!.copyWith(color: Colors.grey),
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,
        prefixIconColor: context.iconColor,
        suffixIconColor: context.iconColor,
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
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: _borderBasedColor(border),
            width: borderWidth,
          ),
        );
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

  Color _borderBasedColor(DifferentBorder border) {
    switch (border) {
      case DifferentBorder.border:
        return widget.borderColor ?? Colors.black;
      case DifferentBorder.enabledBorder:
        return widget.enabledBorderColor ?? Colors.black;
      case DifferentBorder.focusedBorder:
        return widget.focusedBorderColor ?? context.primaryColor;
      case DifferentBorder.errorBorder:
        return widget.errorBorderColor ?? context.redColor;
      case DifferentBorder.focusedErrorBorder:
        return widget.focusedErrorBorderColor ?? context.redColor;
    }
  }
}
