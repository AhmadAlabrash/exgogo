import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';

class JobBubble extends StatelessWidget {
  final String title;
  final bool senderFromWeb;
  const JobBubble({
    super.key,
    required this.title,
    required this.senderFromWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(12),
          bottomRight: const Radius.circular(12),
          topRight: senderFromWeb
              ? const Radius.circular(12)
              : const Radius.circular(0),
          topLeft: senderFromWeb
              ? const Radius.circular(0)
              : const Radius.circular(12),
        ),
        color: context.dProvider.whiteColor,
      ),
      constraints: BoxConstraints(maxWidth: context.width - 84),
      child: Column(
        crossAxisAlignment:
            senderFromWeb ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            LocalKeys.job,
            style: context.titleSmall,
          ),
          Text(
            title,
            style: context.titleMedium,
          ),
        ],
      ),
    );
  }
}
