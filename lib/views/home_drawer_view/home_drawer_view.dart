import 'package:flutter/material.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';
import 'package:xilancer/utils/components/field_label.dart';
import 'package:xilancer/utils/components/navigation_pop_icon.dart';
import 'package:xilancer/views/home_drawer_view/components/filter_buttons.dart';
import 'package:xilancer/views/home_drawer_view/components/filter_ratings.dart';

import '../../view_models/home_drawer_view_model/home_drawer_view_model.dart';
import 'components/filter_budget_range.dart';
import 'components/filter_categories.dart';
import 'components/filter_experience_level.dart';
import 'components/filter_lengths.dart';
import 'components/filter_place.dart';

class HomeDrawerView extends StatelessWidget {
  const HomeDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final hdm = HomeDrawerViewModel.instance;
    return Container(
      child: Column(
        children: [
          AppBar(
            leading: const NavigationPopIcon(),
            title: Text(LocalKeys.filter),
          ),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ValueListenableBuilder(
                valueListenable: hdm.proProjects,
                builder: (context, value, child) => ListTile(
                  tileColor: context.dProvider.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: FieldLabel(label: LocalKeys.proProjects),
                  trailing: Transform.scale(
                    scale: .7,
                    child: Switch(
                        value: value,
                        onChanged: (_) {
                          hdm.proProjects.value = !value;
                        }),
                  ),
                ),
              ),
              12.toHeight,
              const FilterCategories(),
              12.toHeight,
              const FilterPlace(),
              12.toHeight,
              const FilterExp(),
              12.toHeight,
              const FilterBudgetRange(),
              12.toHeight,
              const FilterLengths(),
              12.toHeight,
              const FilterRatings(),
            ],
          )),
          Divider(
            color: context.dProvider.black8,
            thickness: 2,
            height: 2,
          ),
          const FilterButtons()
        ],
      ),
    );
  }
}
