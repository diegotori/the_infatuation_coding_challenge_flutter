import 'package:flutter/material.dart';

///
/// Simple [CircularProgressIndicator] to indicate loading.
///
class SimpleLoadingSpinner extends StatelessWidget {
  final bool visible;

  const SimpleLoadingSpinner({Key? key, this.visible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        alignment: FractionalOffset.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
