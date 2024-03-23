import 'package:flutter/material.dart';

class JumpingDotIndicator extends StatefulWidget {
  final int numberOfDots;
  final Duration duration;
  final Color? color;

  const JumpingDotIndicator({
    required this.duration,
    this.numberOfDots = 3,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  _JumpingDotIndicatorState createState() => _JumpingDotIndicatorState();
}

class _JumpingDotIndicatorState extends State<JumpingDotIndicator>
    with TickerProviderStateMixin {
  static const int animationDuration = 200;
  static const double gap = 4.0;

  final List<AnimationController> _animationControllers = [];
  final List<Animation> _animations = [];

  void _initAnimation() {
    for (var i = 0; i < widget.numberOfDots; i++) {
      // Initialization of _animationControllers
      _animationControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: animationDuration),
        ),
      );

      // Initialization of _animations
      _animations.add(
        Tween<double>(begin: 0, end: -6.0).animate(_animationControllers[i]),
      );

      // Add listener to _animationControllers
      _animationControllers[i].addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            // Return of original position
            _animationControllers[i].reverse();
            // Start the animation of next dot if it is not last dot.
            if (i != widget.numberOfDots - 1) {
              _animationControllers[i + 1].forward();
            }
          }
          // If last dot is back to its original position then start animation of the first dot. And the animation will be repeated infinitely
          if (i == widget.numberOfDots - 1 &&
              status == AnimationStatus.dismissed) {
            _animationControllers[0].forward();
          }
        },
      );
    }

    // Trigger animation of first dot to start the whole animation.
    _animationControllers.first.forward();
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gapWidth = gap * (widget.numberOfDots - 1);
        final dotSize = (constraints.maxWidth - gapWidth) / widget.numberOfDots;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            widget.numberOfDots,
            (index) {
              return AnimatedBuilder(
                animation: _animationControllers[index],
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animations[index].value),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color ?? Colors.black,
                      ),
                      height: dotSize,
                      width: dotSize,
                    ),
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}
