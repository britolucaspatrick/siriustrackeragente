import 'package:flutter/material.dart';

class MoveAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const MoveAnimation({Key key, @required this.duration, @required this.child})
      : super(key: key);

  @override
  _MoveAnimationState createState() => _MoveAnimationState();
}

class _MoveAnimationState extends State<MoveAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));
    final Animation curve = CurvedAnimation(
        parent: animationController, curve: Curves.elasticInOut);
    animation = Tween<double>(begin: 400, end: 0).animate(curve);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(animation.value, 0.0, 0.0),
      child: widget.child,
    );
  }
}
