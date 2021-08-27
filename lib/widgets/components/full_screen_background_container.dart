import 'package:flutter/widgets.dart';

class FullScreenBackgroundContainer extends StatelessWidget {
  FullScreenBackgroundContainer({
    Widget? child,
  }) : this.child = child;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.asset('assets/images/background_circles.png').image,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
