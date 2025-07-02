import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constant/app_test_style.dart';
import '../utils/constant/sizes.dart';


class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    super.key,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixIconPressed,
    this.isPassword = false,
    this.hintText,
    required this.dark,
    this.headerText,
    this.headerStyle,
    this.headerFontWeight,
    this.headerFontFamily,
    this.hintTextColor,
    this.focusNode,
    this.radius,
    this.maxLines = 1,
    this.isEmail = false,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.isRequired = false,
  });

  final TextEditingController? controller;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool isPassword;
  final String? hintText;
  final bool dark;
  final String? headerText;
  final TextStyle? headerStyle;
  final FontWeight? headerFontWeight;
  final String? headerFontFamily;
  final Color? hintTextColor;
  final BorderRadius? radius;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool isEmail;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isRequired;

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool _obscureText = true;

  static const Color _darkModeFillColor = Color(0xFF010C20);

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return widget.isRequired ? 'Email is required' : null;
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Color _getFillColor() => widget.dark ? _darkModeFillColor : Colors.white;
  Color _getBorderColor() => widget.dark ? Colors.white.withOpacity(0.2) : Colors.grey;
  Color _getFocusedBorderColor() =>
      widget.dark ? Colors.white.withOpacity(0.5) : AColors.primary;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headerText != null) ...[
          Row(
            children: [
              Text(
                widget.headerText!,
                style:  AappTextStyle.roboto(
                  color: widget.dark ? AColors.lightGray100 : AColors.darkGray900,
                  fontSize: 16.0,
                  weight: FontWeight.w600,
                ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style:  AappTextStyle.roboto(
                    color: Colors.red,
                    fontSize: 16.0,
                    weight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: ASizes.inputFieldRadius - 4),
        ],
        TextFormField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          maxLines: widget.maxLines,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.isEmail
              ? TextInputType.emailAddress
              : (widget.keyboardType ?? TextInputType.text),
          onChanged: widget.onChanged,
          validator: widget.isEmail
              ? (widget.validator ?? _defaultEmailValidator)
              : widget.validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: _getFillColor(),
            hintText: widget.hintText,
            hintStyle:  AappTextStyle.roboto(
              color: widget.hintTextColor ??
                  (widget.dark ? AColors.lightGray500 : AColors.lightGray500),
              fontSize: 16.0,
              weight: FontWeight.w400,
            ),
            prefixIcon: widget.isEmail
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.email_outlined,
                color: widget.dark
                    ? AColors.lightGray400
                    : AColors.darkGray600,
              ),
            )
                : (widget.prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: widget.prefixIcon,
            )
                : null),
            suffixIcon: widget.isPassword
                ? IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: widget.dark
                    ? AColors.lightGray400
                    : AColors.darkGray600,
              ),
              splashRadius: 20,
            )
                : (widget.suffixIcon != null
                ? IconButton(
              onPressed: widget.onSuffixIconPressed,
              icon: widget.suffixIcon!,
              splashRadius: 20,
            )
                : null),
            border: OutlineInputBorder(
              borderRadius: widget.radius ?? BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0.94, color: _getBorderColor()),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.radius ?? BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0.94, color: _getBorderColor()),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.radius ?? BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0.94, color: _getFocusedBorderColor()),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: widget.radius ?? BorderRadius.circular(8.0),
              borderSide: const BorderSide(width: 0.94, color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: widget.radius ?? BorderRadius.circular(8.0),
              borderSide: const BorderSide(width: 1.5, color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 18.0,
            ),
          ),
          style: AappTextStyle.roboto(
            color:
            widget.dark ? AColors.lightGray100 : AColors.darkGray900,
            fontSize: 16.0,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
