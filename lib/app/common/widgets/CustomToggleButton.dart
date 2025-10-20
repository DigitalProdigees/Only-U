import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomToggleButton extends StatefulWidget {
  final void Function(bool isOn)? onChanged;

  const CustomToggleButton({Key? key, this.onChanged}) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  bool isOn = false;

  void toggle() {
    setState(() => isOn = !isOn);
    if (widget.onChanged != null) widget.onChanged!(isOn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: SvgPicture.asset(
        isOn ? 'assets/imgs/toggle_on.svg' : 'assets/imgs/toggle_off.svg',
        height: 50,
        width: 50,
      ),
    );
  }
}
