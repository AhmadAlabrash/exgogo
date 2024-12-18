import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/string_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';
import 'package:xilancer/view_models/wallet_deposit_view_model/wallet_deposit_view_model.dart';
import 'package:xilancer/views/wallet_deposit_view/wallet_deposit_view.dart';

class RemainingBalance extends StatelessWidget {
  final num amount;
  const RemainingBalance({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: context.dProvider.whiteColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
              text: TextSpan(
                  text: "${LocalKeys.balance}: ",
                  style: context.titleMedium
                      ?.copyWith(color: context.dProvider.black5),
                  children: [
                TextSpan(
                    text: amount.toStringAsFixed(2).cur,
                    style: context.titleLarge?.bold6),
              ])),
          IconButton(
              onPressed: () {
                WalletDepositViewModel.dispose;
                context.toPage(const WalletDepositView());
              },
              icon: const Icon(Icons.add_circle_outline_rounded))
        ],
      ),
    );
  }
}
