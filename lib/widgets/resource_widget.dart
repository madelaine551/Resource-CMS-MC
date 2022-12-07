import 'package:flutter/material.dart';
import 'package:resource_cms/widgets/buttons/long_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/resource.dart';
import '../models/tag.dart';
import 'buttons/box_button_icon.dart';

class ResourceWidget extends StatefulWidget {
  final Resource resource;
  const ResourceWidget({super.key, required this.resource});

  @override
  State<ResourceWidget> createState() => _ResourceWidgetState();
}

class _ResourceWidgetState extends State<ResourceWidget>
    with TickerProviderStateMixin {
  bool expanded = false;
  bool isResourceWidgetVisible = true;
  bool isResourceTagsWidgetVisible = false;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  _ResourceWidgetState();

  launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url,
          mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: isResourceWidgetVisible,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(2, 4),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/pdf.png'),
                              Expanded(child: Text(widget.resource.name)),
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: -0.5)
                                    .animate(animationController),
                                child: IconButton(
                                  icon: Image.asset(
                                      'assets/icons/l_arrow_icon_grey.png'),
                                  onPressed: () {
                                    setState(() {
                                      if (expanded) {
                                        animationController.reverse();
                                      } else {
                                        animationController.forward();
                                      }
                                      expanded = !expanded;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: expanded,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Column(
                                children: [
                                  LongButton(
                                    action: () {
                                      launchUrl(widget.resource.link);
                                    },
                                    icon: 'assets/icons/open_icon_white.png',
                                    text: 'Open',
                                  ),
                                  LongButton(
                                    action: () {
                                      setState(
                                        () {
                                          isResourceTagsWidgetVisible =
                                              !isResourceTagsWidgetVisible;
                                          isResourceWidgetVisible =
                                              !isResourceWidgetVisible;
                                        },
                                      );
                                    },
                                    icon: 'assets/icons/expand_icon_white.png',
                                    text: 'Tags',
                                  ),
                                  LongButton(
                                    action: () {
                                      setState(
                                        () {
                                          isResourceTagsWidgetVisible =
                                              !isResourceTagsWidgetVisible;
                                          isResourceWidgetVisible =
                                              !isResourceWidgetVisible;
                                        },
                                      );
                                    },
                                    icon: 'assets/icons/search_icon_white.png',
                                    text: 'Included In',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
        Visibility(
          visible: isResourceTagsWidgetVisible,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(2, 4),
                          )
                        ],
                        color: Color.fromRGBO(67, 67, 67, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/pdf.png'),
                              Expanded(
                                  child: Text(
                                widget.resource.name,
                                style: const TextStyle(color: Colors.white),
                              )),
                              IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        isResourceTagsWidgetVisible =
                                            !isResourceTagsWidgetVisible;
                                        isResourceWidgetVisible =
                                            !isResourceWidgetVisible;
                                      },
                                    );
                                  },
                                  icon: Image.asset(
                                      'assets/icons/minimise_icon_white.png')),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: const [
                                Text(
                                  'TAGS',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              height: 150.0,
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 5,
                                  direction: Axis.horizontal,
                                  children: widget.resource.tags
                                      .map((t) => Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 2, 10, 2),
                                            child: Text(t.name),
                                          )))
                                      .toList(),
                                ),
                              )),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
