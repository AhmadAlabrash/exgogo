import 'package:flutter/material.dart';
import 'package:xilancer/helper/constant_helper.dart';
import 'package:xilancer/helper/extension/context_extension.dart';

class FreelancerLevelTag extends StatelessWidget {
  const FreelancerLevelTag({
    super.key,
    required this.levelTitle,
  });

  final String? levelTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: dProvider.yellowColor.withOpacity(.4)),
      child: FittedBox(
        child: Row(
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: dProvider.black3,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              levelTitle ?? "",
              style: context.titleSmall
                  ?.copyWith(color: context.dProvider.black3)
                  .bold6,
            ),
            SizedBox(
              width: 4,
            ),
            CircleAvatar(
              radius: 4,
              backgroundColor: dProvider.black3,
            ),
          ],
        ),
      ),
    );
  }
}
