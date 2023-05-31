import 'package:flutter/material.dart';

class NavigationCircles extends StatelessWidget {
  const NavigationCircles(
      this._pageController, {
        Key? key,
      }) : super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NavigationCircle(
          onTap: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
          iconData: Icons.arrow_back_ios,
        ),
        NavigationCircle(
          onTap: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
          iconData: Icons.arrow_forward_ios,
        ),
      ],
    );
  }
}

class NavigationCircle extends StatelessWidget {
  const NavigationCircle({
    Key? key,
    required this.onTap,
    required this.iconData,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(iconData, color: Colors.white, size: 30.0),
          ),
        ),
      ),
    );
  }
}
