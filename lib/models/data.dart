import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resource_cms/models/folder.dart';
import 'package:resource_cms/models/resource.dart';
import 'package:resource_cms/models/tag.dart';
import 'package:resource_cms/services/datasources/folder_datasource.dart';
import 'package:resource_cms/services/datasources/mongodb_resource_datasource.dart';
import 'package:resource_cms/services/datasources/resource_datasource.dart';
import 'package:resource_cms/services/datasources/tag_datasource.dart';

class Data extends ChangeNotifier {
  List<Folder> _folders = [];
  List<Resource> _rsrces = [];
  List<Tag> _tags = [];

  UnmodifiableListView<Folder> get folders => UnmodifiableListView(_folders);
  UnmodifiableListView<Resource> get resources => UnmodifiableListView(_rsrces);
  UnmodifiableListView<Tag> get tags => UnmodifiableListView(_tags);

  bool connected = false;

  Data() {
    refresh();
  }

  Future<void> refresh() async {
    FolderDatasource FD = GetIt.I<FolderDatasource>();
    ResourceDatasource RD = GetIt.I<ResourceDatasource>();
    TagDatasource TD = GetIt.I<TagDatasource>();

    await RD.connect();
    await TD.connect();

    _folders = await FD.all();
    _rsrces = await RD.all();
    _tags = await TD.all();

    connected = true;

    notifyListeners();
  }
}
