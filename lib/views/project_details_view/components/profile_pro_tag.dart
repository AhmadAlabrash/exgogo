import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';

import '../../../customizations.dart';
import '../../../helper/constant_helper.dart';
import '../../../helper/local_keys.g.dart';

class ProfileProTag extends StatelessWidget {
  final bool isPro;
  final DateTime? proExpDate;
  const ProfileProTag({
    super.key,
    required this.isPro,
    this.proExpDate,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    if (!isPro) {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: proTagColor.withOpacity(.1),
      ),
      child: FittedBox(
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: proTagColor,
                ),
                child: Icon(
                  Icons.done_rounded,
                  size: 10,
                  color: dProvider.whiteColor,
                )),
            SizedBox(width: 8),
            Text(
              LocalKeys.pro,
              style: context.titleSmall?.bold.copyWith(
                color: proTagColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
