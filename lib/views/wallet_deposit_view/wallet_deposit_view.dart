import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';
import 'package:xilancer/utils/components/custom_button.dart';
import 'package:xilancer/utils/components/field_with_label.dart';
import 'package:xilancer/utils/components/navigation_pop_icon.dart';
import 'package:xilancer/view_models/wallet_deposit_view_model/wallet_deposit_view_model.dart';

import '../payment_views/payment_gateways.dart';

class WalletDepositView extends StatelessWidget {
  const WalletDepositView({super.key});

  @override
  Widget build(BuildContext context) {
    final wdm = WalletDepositViewModel.instance;
    return Scaffold(
      appBar: AppBar(
        leading: const NavigationPopIcon(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.dProvider.whiteColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldWithLabel(
                label: LocalKeys.amount,
                hintText: LocalKeys.enterAmount,
                controller: wdm.amountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                isRequired: true,
                validator: (value) {
                  if ((num.tryParse(value.toString()) ?? 0) < 1) {
                    return LocalKeys.enterValidAmount;
                  }
                  return null;
                },
              ),
              PaymentGateways(
                gatewayNotifier: wdm.selectedGateway,
                attachmentNotifier: wdm.selectedAttachment,
                cardController: wdm.aCardController,
                secretCodeController: wdm.authCodeController,
                zUsernameController: wdm.zUsernameController,
                expireDateNotifier: wdm.authNetExpireDate,
                usernameController: TextEditingController(),
              ),
              20.toHeight,
              ValueListenableBuilder(
                valueListenable: wdm.isLoading,
                builder: (context, loading, child) {
                  return CustomButton(
                      onPressed: () {
                        wdm.tryDeposit(context);
                      },
                      btText: LocalKeys.deposit,
                      isLoading: loading);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
