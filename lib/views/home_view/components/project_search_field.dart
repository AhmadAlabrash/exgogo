import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/helper/extension/string_extension.dart';
import 'package:xilancer/helper/local_keys.g.dart';
import 'package:xilancer/services/project_list_service.dart.dart';
import 'package:xilancer/view_models/home_drawer_view_model/home_drawer_view_model.dart';

import '../../../helper/svg_assets.dart';
import 'project_suggestions.dart';

class ProjectSearchField extends StatelessWidget {
  const ProjectSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final hdm = HomeDrawerViewModel.instance;
    return Consumer<ProjectListService>(builder: (context, pl, child) {
      return Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: context.dProvider.whiteColor,
        ),
        child: Autocomplete<String>(
          optionsBuilder: (tValue) async {
            hdm.timer?.cancel();
            if (tValue.text.isEmpty) {
              return [""];
            }
            debugPrint("option builder".toString());
            hdm.timer = Timer(1.seconds, () {
              hdm.suggestionLoading.value = true;
              pl.fetchSuggestionProjectList(tValue.text).then((v) {
                hdm.suggestionLoading.value = false;
              });
            });
            return pl.suggestionProjects.projects?.projects
                    ?.map((e) => e.id?.toString() ?? "")
                    .toList() ??
                [""];
          },
          onSelected: (value) {
            context.unFocus;
            pl.setSearchText(value);
            pl.fetchProjectList();
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              textInputAction: TextInputAction.search,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hdm.searchController.text.isEmpty
                    ? LocalKeys.searchProject
                    : hdm.searchController.text,
                prefix: 6.toWidth,
                prefixIcon: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgAssets.search.toSVGSized(24)),
                  ],
                ),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: hdm.suggestionLoading,
                  builder: (context, loading, child) {
                    return loading
                        ? Padding(
                            // height: 26,
                            // width: 26,
                            padding: const EdgeInsets.all(8),
                            child: FittedBox(
                                child: CircularProgressIndicator(
                              color: context.dProvider.primaryColor,
                            )))
                        : textEditingController.text.isEmpty &&
                                (pl.suggestionProjects.projects?.projects
                                            ?.length ??
                                        0) ==
                                    0
                            ? const SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  textEditingController.clear();
                                  pl.resetSuggestion();
                                  if (pl.searchText.isNotEmpty) {
                                    pl.setSearchText("");
                                    hdm.searchController.clear();
                                    pl.fetchProjectList();
                                  }
                                  context.unFocus;
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: context.dProvider.black5,
                                    )),
                              );
                  },
                ),
              ),
              onChanged: (value) {},
              onFieldSubmitted: (value) {
                context.unFocus;
                pl.setSearchText(value);
                pl.fetchProjectList();
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return const ProjectSuggestions();
          },
        ),
      );
    });
    // return Column(
    //   children: [
    //     Consumer<ProjectListService>(builder: (context, pl, child) {
    //       return CustomAutoComplete(
    //         optionsBuilder: (tValue) async {
    //           await Future.delayed(1.seconds);
    //           hdm.timer?.cancel();
    //           if (tValue.text.isEmpty &&
    //               (pl.suggestionProjects.projects?.projects ?? []).isEmpty) {
    //             return [];
    //           }
    //           hdm.timer = Timer(1.seconds, () {
    //             pl.fetchSuggestionProjectList(tValue.text);
    //           });
    //           return pl.suggestionProjects.projects?.projects
    //                   ?.map((e) => e.id?.toString() ?? "")
    //                   .toList() ??
    //               [];
    //         },
    //         onSelected: (value) {
    //           context.unFocus;
    //           pl.setSearchText(value);
    //           pl.fetchProjectList();
    //         },
    //         hintText: LocalKeys.searchProject,
    //         reset: () {},
    //       );
    //     }),
    //     // Container(
    //     //   height: 46,
    //     //   decoration: BoxDecoration(
    //     //     borderRadius: BorderRadius.circular(6),
    //     //     color: context.dProvider.whiteColor,
    //     //   ),
    //     //   child: TextFormField(
    //     //     controller: hdm.searchController,
    //     //     textInputAction: TextInputAction.search,
    //     //     decoration: InputDecoration(
    //     //       hintText: LocalKeys.searchProject,
    //     //       prefix: 6.toWidth,
    //     //       prefixIcon: Column(
    //     //         children: [
    //     //           Padding(
    //     //               padding: const EdgeInsets.all(8),
    //     //               child: SvgAssets.search.toSVGSized(24)),
    //     //         ],
    //     //       ),
    //     //       suffixIcon:
    //     //           Consumer<ProjectListService>(builder: (context, jl, child) {
    //     //         return pl.searchText.isEmpty
    //     //             ? const SizedBox()
    //     //             : GestureDetector(
    //     //                 onTap: () {
    //     //                   pl.setSearchText("");
    //     //                   hdm.searchController.clear();
    //     //                   pl.fetchProjectList();
    //     //                   context.unFocus;
    //     //                 },
    //     //                 child: Container(
    //     //                     padding: const EdgeInsets.all(6),
    //     //                     decoration: const BoxDecoration(
    //     //                       color: Colors.transparent,
    //     //                     ),
    //     //                     child: Icon(
    //     //                       Icons.close,
    //     //                       color: context.dProvider.black5,
    //     //                     )),
    //     //               );
    //     //       }),
    //     //     ),
    //     //     onFieldSubmitted: (value) {
    //     //       pl.setSearchText(hdm.searchController.text);
    //     //       pl.fetchProjectList();
    //     //     },
    //     //   ),
    //     // ),
    //   ],
    // );
  }
}
