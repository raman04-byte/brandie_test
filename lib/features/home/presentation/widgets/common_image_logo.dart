import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';

class CommonImageLogo extends StatelessWidget {
  const CommonImageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.logo);
  }
}
