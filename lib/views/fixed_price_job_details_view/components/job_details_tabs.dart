import 'package:flutter/material.dart';

import '../../../view_models/fix_price_job_details_view_model/fix_price_job_details_view_model.dart';
import 'job_details_proposals.dart';

class JobDetailsTabs extends StatelessWidget {
  final orderHaveMilestone;
  const JobDetailsTabs({super.key, this.orderHaveMilestone = false});

  @override
  Widget build(BuildContext context) {
    final jdm = FixPriceJobDetailsViewModel.instance;
    return ValueListenableBuilder(
      valueListenable: jdm.selectedTitleIndex,
      builder: (context, value, child) => JobDetailsProposals(tabIndex: value),
    );
  }
}
