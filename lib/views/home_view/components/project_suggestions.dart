import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xilancer/helper/extension/context_extension.dart';
import 'package:xilancer/helper/extension/int_extension.dart';
import 'package:xilancer/services/project_list_service.dart.dart';

import '../../../services/project_details_service.dart';
import '../../../utils/components/image_pl_widget.dart';
import '../../../view_models/project_details_view_model/project_details_view_model.dart';
import '../../project_details_view/project_details_view.dart';

class ProjectSuggestions extends StatelessWidget {
  const ProjectSuggestions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectListService>(builder: (context, pl, child) {
      return Material(
        color: context.dProvider.whiteColor.withOpacity(.70),
        child: Column(
          children: [
            SizedBox(
              height: (context.height) - 80,
              child: ListView(
                padding: EdgeInsets.zero,
                children: ((pl.suggestionProjects.projects?.projects?.length ??
                                    0) <
                                6
                            ? pl.suggestionProjects.projects?.projects
                            : pl.suggestionProjects.projects?.projects
                                ?.sublist(0, 5))
                        ?.map((e) => GestureDetector(
                              onTap: () async {
                                ProjectDetailsViewModel.dispose;
                                context.toNamed(ProjectDetailsView.routeName,
                                    arguments: [e.id], then: () {
                                  Provider.of<ProjectDetailsService>(context,
                                          listen: false)
                                      .removeProject(id: e.id);
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.all(4),
                                    width: context.width - 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: context.dProvider.whiteColor,
                                        border: Border.all(
                                          color: context.dProvider.primaryColor
                                              .withOpacity(.40),
                                        )),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "${pl.suggestionProjects.projectFilePath}/${e.image}",
                                                placeholder: (context, url) =>
                                                    const ImagePLWidget(
                                                        size: 60),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const ImagePLWidget(
                                                            size: 60),
                                              ),
                                            )),
                                        12.toWidth,
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              e.title ?? "--",
                                              maxLines: 2,
                                              style:
                                                  context.titleSmall?.copyWith(
                                                height: 1.1,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList() ??
                    [],
              ),
            ),
          ],
        ),
      );
    });
  }
}
