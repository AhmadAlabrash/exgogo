import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/extension/string_extension.dart';

import '../../../helper/local_keys.g.dart';
import '../../../helper/svg_assets.dart';

class ProjectDetailsButtons extends StatelessWidget {
  const ProjectDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            //
          },
          icon: SvgAssets.message.toSVG,
          label: Text(LocalKeys.sendMessage),
        ),
        20.toWidth,
      ],
    );
  }
}
