import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/services/profile_details_service.dart';
import 'package:xilancer/views/chat_list_view/components/chat_tile_avatar.dart';

import '../../../customizations.dart';
import '../../../helper/constant_helper.dart';
import '../../project_details_view/components/freelancer_level_tag.dart';
import '../../project_details_view/components/profile_pro_tag.dart';

class ProfileNameInfos extends StatelessWidget {
  final bool userActiveStatus;
  const ProfileNameInfos({super.key, required this.userActiveStatus});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailsService>(builder: (context, pd, child) {
      final user = pd.profileDetails.user;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: badges.Badge(
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.transparent),
              position: badges.BadgePosition.bottomEnd(),
              badgeContent: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dProvider.whiteColor,
                ),
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: userActiveStatus
                      ? context.dProvider.greenColor
                      : context.dProvider.black3,
                ),
              ),
              child: ChatTileAvatar(
                  imageUrl: user?.freelancerCloudImage ??
                      "$userProfilePath/${user?.image}",
                  name: "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                  size: 60.0),
            ),
          ),
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: [
                    if (pd.profileDetails.freelancerLevel?.levelTitle != null)
                      FreelancerLevelTag(
                          levelTitle:
                              pd.profileDetails.freelancerLevel?.levelTitle),
                    if (pd.profileDetails.isPro)
                      ProfileProTag(
                          isPro: pd.profileDetails.isPro,
                          proExpDate: DateTime.now().add(Duration(days: 1))),
                  ],
                ),
                if (pd.profileDetails.freelancerLevel?.levelTitle != null ||
                    (pd.profileDetails.isPro))
                  4.toHeight,
                Text(
                  "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                  style: context.titleMedium?.bold6,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (user?.userIntroduction?.title != null) ...[
                      Text(
                        user?.userIntroduction?.title ?? "",
                        style: context.titleSmall
                            ?.copyWith(color: context.dProvider.black5),
                      )
                    ],
                    if ((pd.profileDetails.avgRating ?? 0) > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              context.dProvider.yellowColor.withOpacity(0.10),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: context.dProvider.yellowColor,
                                size: 20,
                              ),
                              Text(
                                " ${pd.profileDetails.avgRating ?? 0} (${pd.profileDetails.totalRating ?? 0})",
                                style: context.titleSmall
                                    ?.copyWith(
                                        color: context.dProvider.yellowColor)
                                    .bold6,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
