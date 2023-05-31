import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';

class ReturnButton extends StatelessWidget {
  final Function onPressed;

  const ReturnButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final buttonScale = LayoutHelpers.scaleReturnButtonToDisplaySize(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: SvgPicture.asset(
          'assets/buttons/close_card_generator.svg',
          height: buttonScale, // Set the appropriate height
          width: buttonScale, // Set the appropriate width
        ),
      ),
    );
  }
}
