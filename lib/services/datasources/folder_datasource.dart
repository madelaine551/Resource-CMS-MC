///------------------------------
///          Packages
///------------------------------

import 'package:mongo_dart/mongo_dart.dart';
import 'package:resource_cms/models/folder.dart';

///------------------------------
///      Datasource Class
///------------------------------

abstract class FolderDatasource {
  Future<List<Folder>> all();
  Future<bool> addFolder(Folder f);
  Future<bool> deleteFolder(Folder f);
  Future<Folder>? getFolder(ObjectId id);
  Future<List<Folder>> getAll(List<dynamic> ids);
  Future<bool> updateFolder(Folder f);
}
