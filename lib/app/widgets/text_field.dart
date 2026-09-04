import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/screen_util.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  /// Caption shown above the field.
  ///
  /// A hint disappears the moment someone starts typing, which is exactly
  /// when a half-filled edit form becomes ambiguous - "0923354534" in an
  /// unlabelled box could be a phone, a licence number or a wallet id. Edit
  /// screens pass this; single-purpose screens like sign-in can rely on the
  /// hint alone.
  final String? labelText;
  final bool isPassword;
  final String? Function(String?) validator;
  final double radius;
  final bool? isHomePage;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final List<TextInputFormatter> formatters;

  final bool? enabled;

  final int? maxLines;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    required this.validator,
    this.radius = 24,
    this.isHomePage = false,
    this.formatters = const [],
    this.onFieldSubmitted,
    this.maxLines,
    this.enabled,
    this.onChanged,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      width: width(395),
      height: height(70), // أكبر شوي ليطلع مكان للـ error text
      child: TextFormField(
        onChanged: widget.onChanged,
        // onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        validator: widget.validator,
        maxLines: widget.maxLines ?? 1,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: widget.formatters,
        enabled: widget.enabled,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: width(14),
            vertical: height(14),
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: const Color(0xff7A7A7A),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          filled: true,
          fillColor: widget.isHomePage == true
              ? Theme.of(context).colorScheme.onPrimary
              : const Color(0xffb0b0b0).withOpacity(0.22),
          // الحدود (نفس تصميم الكونتينر)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius ?? 24),
            borderSide: BorderSide(
              color: widget.isHomePage == true
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.32)
                  : const Color(0xFF2B2F3F).withOpacity(0.2),
              width: 1.3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius ?? 24),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.3,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius ?? 24),
            borderSide: const BorderSide(color: Colors.red, width: 1.3),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius ?? 24),
            borderSide: const BorderSide(color: Colors.red, width: 1.3),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            height: 0.8,
          ),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(8)),
                    child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xff7A7A7A),
                    ),
                  ),
                )
              : null,
        ),
        cursorColor: Theme.of(context).primaryColor,
      ),
    );

    if (widget.labelText == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: height(4),
            right: width(4),
            left: width(4),
          ),
          child: Text(
            widget.labelText!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xff5A5A5A),
            ),
          ),
        ),
        field,
      ],
    );
  }
}
