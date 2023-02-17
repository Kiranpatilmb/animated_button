import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class AnimatedButton extends StatefulWidget {
  final AnimatedButtons? controller ;

  final VoidCallback? onPressed;

  final Widget? child;

  final Color? color;

  final double? height;

  final double? width;

  final bool? animateOnTap;

  final Color? borderColor;

  final double? borderRadius;

  const AnimatedButton(
      {
        this.controller,
        this.onPressed,
        this.child,
        this.color = Colors.blue,
        this.borderColor= Colors.red,
        this.borderRadius = 50,
        this.height = 50,
        this.width = 300,
        this.animateOnTap = true});

  @override
  State<StatefulWidget> createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController? _buttonController;
  AnimationController? _checkButtonControler;

  Animation? _squeezeAnimation;
  Animation? _bounceAnimation;

  bool _isSuccessful = false;
  bool _isErrored = false;

  var ispressed=false;

  @override
  Widget build(BuildContext context) {
    var check = Container(
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius:
          BorderRadius.all(Radius.circular(_bounceAnimation?.value / 2)),
        ),
        width: _bounceAnimation?.value,
        height: _bounceAnimation?.value,
        child: _bounceAnimation?.value > 20
            ? const Icon(
          Icons.check,
          color: Colors.white,
        )
            : null);

    var cross = Container(
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius:
          BorderRadius.all(Radius.circular(_bounceAnimation!.value / 2)),
        ),
        width: _bounceAnimation?.value,
        height: _bounceAnimation?.value,
        child: _bounceAnimation?.value > 20
            ? const Icon(
          Icons.close,
          color: Colors.white,
        )
            : null);

    var loader =
    LoadingRotating.square(
      borderColor: widget.borderColor!,
      borderSize: 3.0,
      size:widget.height!,
      backgroundColor:  widget.color!,
      duration: Duration(milliseconds: 2000),
    );

    var btn = ButtonTheme(
      shape:
      RoundedRectangleBorder(side: BorderSide(
          color: ispressed?Colors.transparent:widget.borderColor!,
          width:ispressed?0: 2,
          style: BorderStyle.solid
      ), borderRadius: BorderRadius.circular(widget.borderRadius!)),
      minWidth: _squeezeAnimation?.value,
      height: widget.height!,
      child: MaterialButton(
          color: ispressed?Colors.transparent:widget.color,
          elevation: 0,

          onPressed: () async {
            if (widget.animateOnTap!) {
              ispressed=true;
              _start();
            } else {
              widget.onPressed!();
            }
          },
          child: _squeezeAnimation?.value > 150  ? widget.child : loader),
    );

    return SizedBox(
        height: widget.height,
        child:
        Center(child: _isErrored ? cross : _isSuccessful ? check : btn));
  }

  @override
  void initState() {
    super.initState();

    _buttonController =  AnimationController(
        duration:  const Duration(milliseconds: 500), vsync: this);

    _checkButtonControler =  AnimationController(
        duration:  const Duration(milliseconds: 1000), vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: widget.height).animate(
        CurvedAnimation(
            parent: _checkButtonControler!, curve: Curves.bounceOut));
    _bounceAnimation?.addListener(() {
      setState(() {});
    });

    _squeezeAnimation = Tween<double>(begin: widget.width, end: widget.height).animate(
        CurvedAnimation(
            parent: _buttonController!, curve: Curves.bounceOut));
    _squeezeAnimation?.addListener(() {
      setState(() {});
    });

    _squeezeAnimation?.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        widget.onPressed!();
      }
    });

    widget.controller?._addListeners(_start, _stop, _success, _error, _reset);
  }

  @override
  void dispose() {
    _buttonController?.dispose();
    _checkButtonControler?.dispose();
    super.dispose();
  }

  _start() {
    _buttonController?.forward();
  }

  _stop() {
    _isSuccessful = false;
    _isErrored = false;
    _buttonController?.reverse();
  }

  _success() {
    _isSuccessful = true;
    _isErrored = false;
    _checkButtonControler?.forward();
  }

  _error() {
    _isErrored = true;
    _checkButtonControler?.forward();
  }

  _reset() {
    _isSuccessful = false;
    _isErrored = false;
    _buttonController?.reverse();
  }
}

class AnimatedButtons {
  late VoidCallback _startListener;
  late VoidCallback _stopListener;
  late VoidCallback _successListener;
  late VoidCallback _errorListener;
  late VoidCallback _resetListener;

  _addListeners(
      VoidCallback startListener,
      VoidCallback stopListener,
      VoidCallback successListener,
      VoidCallback errorListener,
      VoidCallback resetListener) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  start() {
    _startListener();
  }

  stop() {
    _stopListener();
  }

  success() {
    _successListener();
  }

  error() {
    _errorListener();
  }

  reset() {
    _resetListener();
  }
}