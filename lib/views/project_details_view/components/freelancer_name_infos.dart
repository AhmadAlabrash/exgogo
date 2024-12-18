import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xilancer/customizations.dart';
import 'package:xilancer/helper/constant_helper.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/extension/string_extension.dart';

import '../../../helper/local_keys.g.dart';
import '../../../helper/pusher_helper.dart';
import '../../../helper/svg_assets.dart';
import '../../../models/project_details_model.dart';
import '../../../services/chat_list_service.dart';
import '../../../services/profile_info_service.dart';
import '../../../services/project_details_service.dart';
import '../../../views/chat_list_view/components/chat_tile_avatar.dart';
import '../../../views/profile_details_view/profile_details_view.dart';
import '../../conversation_view/conversation_view.dart';
import 'freelancer_level_tag.dart';
import 'profile_pro_tag.dart';

class FreelancerNameInfos extends StatelessWidget {
  final ProjectCreator? userDetails;
  final projectId;
  const FreelancerNameInfos({
    super.key,
    this.userDetails,
    this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    final pdProvider =
        Provider.of<ProjectDetailsService>(context, listen: false);
    final pi = Provider.of<ProfileInfoService>(context, listen: false);
    final project = pdProvider.projectDetailsModel[projectId.toString()];
    final freelancerRating = project?.freelancerRating ?? 0;
    final freelancerTotalRating = project?.freelancerTotalRating ?? 0;
    final completeOrdersCount = project?.completeOrdersCount ?? 0;
    final isFreelancerActive = DateTime.now()
            .difference(
                project?.projectDetails?.projectCreator?.checkOnlineStatus ??
                    DateTime(2022))
            .inMinutes
            .abs() <
        2;
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
                backgroundColor: isFreelancerActive
                    ? context.dProvider.greenColor
                    : context.dProvider.black3,
              ),
            ),
            child: ChatTileAvatar(
                imageUrl: userDetails?.freelancerCloudImage ??
                    "$userProfilePath/${userDetails?.image}",
                name:
                    "${userDetails?.firstName ?? ""} ${userDetails?.lastName ?? ""}",
                size: 60.0),
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (project?.freelancerLevel?.levelTitle != null)
                      FreelancerLevelTag(
                          levelTitle: project?.freelancerLevel?.levelTitle),
                    if (project?.isFreelancerPro ?? false)
                      ProfileProTag(
                        isPro: true,
                      ),
                  ],
                ),
                if (project?.freelancerLevel?.levelTitle != null ||
                    (project?.isFreelancerPro ?? false))
                  8.toHeight
              ],
              Text(
                "${userDetails?.firstName ?? ""} ${userDetails?.lastName ?? ""}",
                style: context.titleMedium?.bold6,
              ),
              8.toHeight,
              Wrap(
                runSpacing: 12,
                spacing: 12,
                children: [
                  if (userDetails?.userIntroduction?.title != null) ...[
                    Text(
                      userDetails?.userIntroduction?.title ?? "",
                      style: context.titleSmall
                          ?.copyWith(color: context.dProvider.black5),
                    )
                  ],
                  if (freelancerTotalRating > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.dProvider.yellowColor.withOpacity(0.10),
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
                              " $freelancerRating ($freelancerTotalRating)",
                              style: context.titleSmall
                                  ?.copyWith(
                                      color: context.dProvider.yellowColor)
                                  .bold6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (completeOrdersCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.dProvider.greenColor.withOpacity(0.10),
                      ),
                      child: Text(
                        completeOrdersCount > 0
                            ? "$completeOrdersCount ${LocalKeys.ordersCompleted}"
                            : LocalKeys.noOrder,
                        style: context.titleSmall
                            ?.copyWith(color: context.dProvider.greenColor)
                            .bold6,
                      ),
                    ),
                ],
              ),
              6.toHeight,
              Row(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        final userActiveStatus = DateTime.now()
                                .difference(project?.projectDetails
                                        ?.projectCreator?.checkOnlineStatus ??
                                    DateTime(2022))
                                .inMinutes
                                .abs() <
                            2;
                        debugPrint((userDetails?.username).toString());
                        context.toPage(ProfileDetailsView(
                          username: userDetails?.username,
                          userActiveStatus: userActiveStatus,
                        ));
                      },
                      child: Text(LocalKeys.viewProfile)),
                  12.toWidth,
                  if (pi.profileInfoModel.data != null)
                    GestureDetector(
                        onTap: () {
                          final profileInfo = pi.profileInfoModel.data!;
                          Provider.of<ChatListService>(context, listen: false)
                              .setChatRead(project?.chatInfo?.id);

                          PusherHelper().connectToPusher(
                              context,
                              profileInfo.id,
                              project?.projectDetails?.projectCreator?.id);
                          context
                              .toNamed(ConversationView.routeName, arguments: [
                            project?.chatInfo?.id ?? "",
                            "${project?.projectDetails?.projectCreator?.firstName} ${project?.projectDetails?.projectCreator?.lastName}",
                            "$userProfilePath/${userDetails?.image}",
                            project?.projectDetails?.projectCreator?.id
                          ], then: () {
                            PusherHelper().disConnect();
                          });
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: context.dProvider.primaryColor,
                          child: SvgAssets.messageBold.toSVGSized(24,
                              color: context.dProvider.whiteColor),
                        ))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
