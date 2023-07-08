import 'package:flutter/material.dart';

import '../constant/colors/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
    ));
  }
}

class LoadingWhite extends StatelessWidget {
  const LoadingWhite({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation<Color>(white),
    ));
  }
}
