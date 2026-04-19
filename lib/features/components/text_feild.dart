import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TextFieldType { name, phone, email, password }

class CustomTextField extends StatefulWidget {
  final TextFieldType type;
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? label;

  const CustomTextField({
    super.key,
    required this.type,
    this.placeholder = '',
    this.controller,
    this.onChanged,
    this.validator,
    this.label,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isPassword => widget.type == TextFieldType.password;
  bool get _isEmail => widget.type == TextFieldType.email;
  bool get _isName => widget.type == TextFieldType.name;
  bool get _isPhone => widget.type == TextFieldType.phone;

  Color get _borderColor {
    if (_hasError) return const Color(0xFFE53935);
    if (_isFocused) return const Color(0xFF6C63FF);
    return const Color(0xFFE0E0E0);
  }

  Color get _iconColor {
    if (_hasError) return const Color(0xFFE53935);
    if (_isFocused) return const Color(0xFF6C63FF);
    return const Color(0xFFBDBDBD);
  }

  void _validate(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _hasError = error != null;
        _errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF424242),
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: _borderColor,
              width: _isFocused ? 1.8.w : 1.2.w,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.12),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: _isPassword && _obscureText,
            keyboardType: _isEmail
                ? TextInputType.emailAddress
                : _isPhone
                    ? TextInputType.phone
                    : TextInputType.text,
            onChanged: (val) {
              widget.onChanged?.call(val);
              if (_hasError) _validate(val);
            },
            onEditingComplete: () => _validate(_controller.text),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A1A2E),
              letterSpacing: 0.1,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFBDBDBD),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 16.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,

              // ── Fix: align icon to center-right with symmetric padding ──
              suffixIcon: SizedBox(
                width: 48.w,
                child: Center(
                  child: _isPassword
                      ? GestureDetector(
                          onTap: () =>
                              setState(() => _obscureText = !_obscureText),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              key: ValueKey(_obscureText),
                              size: 20.sp,
                              color: _iconColor,
                            ),
                          ),
                        )
                      : Icon(
                          _isEmail
                              ? Icons.email_rounded
                              : _isPhone
                                  ? Icons.phone_rounded
                                  : _isName
                                      ? Icons.person_rounded
                                      : Icons.text_fields_rounded,
                          size: 20.sp,
                          color: _iconColor,
                        ),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 48.w,
                minHeight: 48.h,
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: _hasError && _errorText != null
              ? Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 13.sp,
                        color: const Color(0xFFE53935),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _errorText!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFE53935),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}