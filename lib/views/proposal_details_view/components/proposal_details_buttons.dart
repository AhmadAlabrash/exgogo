import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';
import 'package:xilancer/view_models/fix_price_job_details_view_model/fix_price_job_details_view_model.dart';

import '../../../helper/constant_helper.dart';
import '../../../utils/components/custom_button.dart';
import '../../../utils/components/field_with_label.dart';

class ProposalDetailsButtons extends StatelessWidget {
  final proposalId;
  final shortlisted;
  final hired;
  final rejected;
  final chatInfo;
  final jobType;
  final offeredAmount;
  final estimatedHours;
  const ProposalDetailsButtons({
    super.key,
    this.proposalId,
    required this.hired,
    required this.rejected,
    required this.shortlisted,
    required this.chatInfo,
    this.jobType,
    this.offeredAmount,
    this.estimatedHours,
  });

  @override
  Widget build(BuildContext context) {
    final jdm = FixPriceJobDetailsViewModel.instance;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.dProvider.primaryColor,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                debugPrint(proposalId.toString());
                if (!rejected && !hired) {
                  if (jobType == "hourly") {
                    ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
                    jdm.hourlyRateController.text =
                        offeredAmount?.toString() ?? "";
                    jdm.estimatedHoursController.text =
                        estimatedHours?.toString() ?? "";
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return Material(
                          color: Colors.transparent,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: context.width - 80,
                                decoration: BoxDecoration(
                                    color: context.dProvider.whiteColor,
                                    borderRadius: BorderRadius.circular(12)),
                                constraints:
                                    const BoxConstraints(maxWidth: 480),
                                child: Stack(
                                  children: [
                                    Form(
                                      key: jdm.acceptProposalFormKey,
                                      child: ListView(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(20),
                                        children: [
                                          FieldWithLabel(
                                            isRequired: true,
                                            label: LocalKeys.hourlyRate,
                                            hintText:
                                                LocalKeys.enterHourlyAmount,
                                            controller:
                                                jdm.hourlyRateController,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: SizedBox(
                                              width: 24,
                                              child: Center(
                                                child: Text(
                                                  dProvider.currencySymbol,
                                                  style: context
                                                      .titleLarge?.bold6
                                                      .copyWith(
                                                    color: context
                                                        .dProvider.black5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              return (num.tryParse(value
                                                              .toString()) ??
                                                          0) <
                                                      1
                                                  ? LocalKeys.enterValidAmount
                                                  : null;
                                            },
                                          ),
                                          8.toHeight,
                                          FieldWithLabel(
                                            isRequired: true,
                                            label: LocalKeys.estimatedHours,
                                            hintText:
                                                LocalKeys.enterEstimatedHours,
                                            controller:
                                                jdm.estimatedHoursController,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: SizedBox(
                                              width: 24,
                                              child: Center(
                                                child: Text(
                                                  dProvider.currencySymbol,
                                                  style: context
                                                      .titleLarge?.bold6
                                                      .copyWith(
                                                    color: context
                                                        .dProvider.black5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              return (num.tryParse(value
                                                              .toString()) ??
                                                          0) <
                                                      1
                                                  ? LocalKeys.enterValidAmount
                                                  : null;
                                            },
                                          ),
                                          12.toHeight,
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    context.popFalse;
                                                  },
                                                  child: Text(
                                                    LocalKeys.cancel,
                                                    style: context.titleSmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ),
                                              ),
                                              16.toWidth,
                                              ValueListenableBuilder(
                                                  valueListenable:
                                                      loadingNotifier,
                                                  builder:
                                                      (context, value, child) {
                                                    return Expanded(
                                                        flex: 8,
                                                        child: CustomButton(
                                                          onPressed: () {
                                                            if (jdm.acceptProposalFormKey
                                                                    .currentState
                                                                    ?.validate() !=
                                                                true) return;
                                                            loadingNotifier
                                                                .value = true;
                                                            jdm
                                                                .tryAcceptingHourlyProposal(
                                                                    context,
                                                                    id:
                                                                        proposalId)
                                                                .then((value) =>
                                                                    loadingNotifier
                                                                            .value =
                                                                        false);
                                                          },
                                                          btText:
                                                              LocalKeys.accept,
                                                          isLoading: value,
                                                        ));
                                                  }),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    return;
                  }
                  jdm.tryAcceptingProposal(context, id: proposalId);
                } else {
                  jdm.tryAddingShortList(context,
                      id: proposalId, shortlisted: shortlisted);
                }
              },
              child: Text(
                !rejected && !hired
                    ? LocalKeys.accept
                    : (shortlisted
                        ? LocalKeys.removeFromShortlist
                        : LocalKeys.addToShortlist),
                textAlign: TextAlign.center,
                style: context.titleMedium?.bold6.copyWith(
                  color: context.dProvider.whiteColor,
                ),
              ),
            ),
          ),
          if (!rejected && !hired)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: VerticalDivider(
                color: context.dProvider.whiteColor.withOpacity(.20),
                thickness: 2,
              ),
            ),
          if (!rejected && !hired)
            PopupMenuButton(
              onSelected: (value) {
                final jdm = FixPriceJobDetailsViewModel.instance;
                debugPrint(proposalId.toString());
                switch (value) {
                  case "reject":
                    jdm.tryRejecting(context, id: proposalId);
                    break;
                  default:
                    jdm.tryAddingShortList(
                      context,
                      id: proposalId,
                      shortlisted: shortlisted,
                    );
                }
              },
              itemBuilder: (context) => [
                if (!rejected && !hired)
                  PopupMenuItem(
                    value: "reject",
                    child: Text(LocalKeys.reject),
                  ),
                PopupMenuItem(
                    value: "shortlist",
                    child: Text(shortlisted
                        ? LocalKeys.removeFromShortlist
                        : LocalKeys.addToShortlist)),
              ],
              iconColor: context.dProvider.whiteColor,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
            )
        ],
      ),
    );
  }
}
