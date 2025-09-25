import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A checkbox on the left with a description on the right that contains
/// tappable "Terms of Service" and "Privacy Policy" links.
class TermsCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTapTerms;
  final VoidCallback? onTapPrivacy;
  final TextStyle? textStyle;
  final Color? checkboxActiveColor;

  const TermsCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onTapTerms,
    this.onTapPrivacy,
    this.textStyle,
    this.checkboxActiveColor,
  });

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  late bool _value;
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTapTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onTapPrivacy;
  }

  @override
  void didUpdateWidget(covariant TermsCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep recognizers in sync with possible new callbacks
    _termsRecognizer.onTap = widget.onTapTerms;
    _privacyRecognizer.onTap = widget.onTapPrivacy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _value = !_value);
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        widget.textStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.2);

    return InkWell(
      onTap: _toggle, // taps anywhere on the row toggle the checkbox
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Checkbox on the left
          Checkbox(
            value: _value,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _value = v);
              widget.onChanged(v);
            },
            activeColor:
                widget.checkboxActiveColor ?? Theme.of(context).primaryColor,
          ),

          // Spacing between checkbox and text
          const SizedBox(width: 8),

          // Description on the right (wraps if needed)
          Expanded(
            child: RichText(
              text: TextSpan(
                style:
                    defaultStyle?.copyWith(color: Colors.white) ??
                    const TextStyle(color: Colors.white),
                children: [
                  const TextSpan(text: 'I have read Spotlight’s '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: (defaultStyle ?? const TextStyle()).copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    recognizer: _termsRecognizer,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: (defaultStyle ?? const TextStyle()).copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    recognizer: _privacyRecognizer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
