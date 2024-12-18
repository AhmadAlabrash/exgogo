import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xilancer/helper/constant_helper.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/string_extension.dart';
import 'package:xilancer/helper/extension/widget_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';
import 'package:xilancer/helper/svg_assets.dart';
import 'package:xilancer/services/order_details_service.dart';

class OrderDetailsWorkHistoryTab extends StatelessWidget {
  const OrderDetailsWorkHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsService>(builder: (context, od, child) {
      if ((od.orderDetailsModel.orderDetails?.hourlyWorkHistory ?? [])
          .isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.dProvider.whiteColor,
          ),
          child: Text(
            LocalKeys.noHistoryFound,
            style: context.titleSmall,
          ),
        );
      }
      return Wrap(
        runSpacing: 8,
        children: (od.orderDetailsModel.orderDetails?.hourlyWorkHistory ?? [])
            .map((h) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: context.width - 80,
                              decoration: BoxDecoration(
                                  color: context.dProvider.whiteColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Stack(
                                children: [
                                  ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(20),
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                context.pop;
                                              },
                                              child: Icon(Icons.close_rounded)),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                LocalKeys.startTime,
                                                style:
                                                    context.titleSmall?.black5,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                h.startDate == null
                                                    ? "---"
                                                    : DateFormat(
                                                            "hh:mm:ss a dd-MMM-yyy")
                                                        .format(h.startDate!),
                                                style:
                                                    context.titleSmall?.bold6,
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                LocalKeys.endTime,
                                                style:
                                                    context.titleSmall?.black5,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                h.endDate == null
                                                    ? "---"
                                                    : DateFormat(
                                                            "hh:mm:ss a dd-MMM-yyy")
                                                        .format(h.endDate!),
                                                style:
                                                    context.titleSmall?.bold6,
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                LocalKeys.workHistory,
                                                style:
                                                    context.titleSmall?.black5,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                h.hoursWorked ?? "---",
                                                style:
                                                    context.titleSmall?.bold6,
                                              ),
                                            ),
                                          ],
                                        ).hp20,
                                      ),
                                      if (h.notes != null) ...[
                                        Divider(
                                          color: context.dProvider.black8,
                                          thickness: 2,
                                          height: 24,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  LocalKeys.note,
                                                  style: context
                                                      .titleSmall?.black5,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  h.notes!,
                                                  style:
                                                      context.titleSmall?.bold6,
                                                ),
                                              ),
                                            ],
                                          ).hp20,
                                        )
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.dProvider.whiteColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${LocalKeys.workedHours}: ${h.hoursWorked ?? "--:--:--"}",
                          style: context.titleSmall?.bold,
                        ),
                        SvgAssets.invisible
                            .toSVGSized(24, color: dProvider.black3),
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }
}
