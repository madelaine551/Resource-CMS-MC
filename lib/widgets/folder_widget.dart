import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:resource_cms/models/folder.dart';
import 'package:resource_cms/widgets/buttons/box_button_icon.dart';
import 'package:resource_cms/widgets/buttons/long_button.dart';
import 'package:resource_cms/widgets/item_icon.dart';
import '../models/resource.dart';
import '../models/tag.dart';

class FolderWidget extends StatefulWidget {
  final Folder folder;
  const FolderWidget({super.key, required this.folder});

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget>
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

  _FolderWidgetState();

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
                  child: Stack(children: [
                    Container(
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(2, 4),
                              )
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 70),
                                          child: Text(widget.folder.title))),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 2),
                                  child: Column(
                                    children: [
                                      LongButton(
                                        action: () {},
                                        icon:
                                            'assets/icons/open_icon_white.png',
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
                                        icon:
                                            'assets/icons/expand_icon_white.png',
                                        text: 'Tags',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                      child: ItemIcon(
                          icon:
                              'assets/icons/${widget.folder.type.toLowerCase().replaceFirst('-', '')}_icon_white.png'),
                    ),
                  ]))
            ],
          ),
        ),
        Visibility(
          visible: isResourceTagsWidgetVisible,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: Stack(children: [
                  Container(
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
                                Expanded(
                                    child: Container(
                                  padding: const EdgeInsets.only(left: 70),
                                  child: Text(
                                    widget.folder.title,
                                    style: const TextStyle(color: Colors.white),
                                  ),
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
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
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
                                height: 100.0,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 5,
                                    direction: Axis.horizontal,
                                    children: widget.folder.tags
                                        .map((t) => Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              child: Text(t.name),
                                            )))
                                        .toList(),
                                  ),
                                )),
                          ],
                        )),
                  ),
                  Positioned(
                    child: ItemIcon(
                        icon:
                            'assets/icons/${widget.folder.type.toLowerCase().replaceFirst('-', '')}_icon_white.png'),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
