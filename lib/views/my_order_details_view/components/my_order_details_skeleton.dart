import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/extension/widget_extension.dart';
import 'package:xilancer/utils/components/text_skeleton.dart';


class MyOrderSkeleton extends StatelessWidget {
  const MyOrderSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.dProvider.whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextSkeleton(height: 16, width: 60).hp20,
              12.toHeight,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Container(
                    height: 16,
                    width: 80,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: context.dProvider.black9,
                    ),
                  ),
                  Container(
                    height: 16,
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: context.dProvider.greenColor.withOpacity(.05),
                    ),
                  ),
                  Container(
                    height: 16,
                    width: 120,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: context.dProvider.primary05,
                    ),
                  ),
                ],
              ).hp20,
              8.toHeight,
              const TextSkeleton(height: 14, width: 100).hp20,
              8.toHeight,
              Divider(
                color: context.dProvider.black8,
                thickness: 2,
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          TextSkeleton(height: 14, width: 96),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          const TextSkeleton(height: 14, width: 50),
                          4.toWidth,
                          Container(
                            height: 14,
                            width: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: context.dProvider.primary05,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).hp20,
              ),
              Divider(
                color: context.dProvider.black8,
                thickness: 2,
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            TextSkeleton(height: 14, width: 96),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          TextSkeleton(height: 14, width: 80),
                        ],
                      ),
                    ),
                  ],
                ).hp20,
              ),
              Divider(
                color: context.dProvider.black8,
                thickness: 2,
                height: 24,
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          TextSkeleton(height: 14, width: 80),
                        ],
                      )),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 16.0,
                          backgroundColor: context.dProvider.black8,
                        ),
                        12.toWidth,
                        const TextSkeleton(height: 14, width: 100),
                        2.toHeight
                      ],
                    ),
                  ),
                ],
              ).hp20,
              12.toHeight,
              ...[0, 1, 2, 3]
                  .map((e) => Container(
                        height: 70,
                        margin:
                            e != 3 ? const EdgeInsets.only(bottom: 12) : null,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.dProvider.gridColors[e],
                        ),
                      ).hp20)
                  .toList()
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.dProvider.whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextSkeleton(height: 16, width: 100).hp20,
              8.toHeight,
              Divider(
                color: context.dProvider.black8,
                thickness: 2,
                height: 24,
              ),
              const TextSkeleton(height: 14, width: double.infinity).hp20,
              8.toHeight,
              TextSkeleton(height: 14, width: context.width - 100).hp20,
              8.toHeight,
              const TextSkeleton(height: 14, width: 100).hp20,
            ],
          ),
        )
      ],
    ).shim;
  }
}
