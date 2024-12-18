import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/services/message_notification_count_service.dart';
import 'package:xilancer/services/push_notification_service.dart';

import '../../view_models/home_view_model/home_view_model.dart';
import '../home_view/components/home_app_bar.dart';
import '../projects_list/projects_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final hvm = HomeViewModel.instance;
    Provider.of<MessageNotificationCountService>(context, listen: false)
        .fetchMN();
    PushNotificationService().updateDeviceToken(forceUpdate: true);
    return Column(
      children: [
        const HomeAppBar(),
        Expanded(
          child: Container(
            color: context.dProvider.black9,
            child: const ProjectsList(),
          ),
        ),
      ],
    );
  }
}
