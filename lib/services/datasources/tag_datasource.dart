///------------------------------
///          Packages
///------------------------------

import 'package:mongo_dart/mongo_dart.dart';
import 'package:resource_cms/models/tag.dart';

///------------------------------
///      Datasource Class
///------------------------------

abstract class TagDatasource {
  Future<List<Tag>> all();
  Future<bool> addTag(Tag t);
  Future<Tag> getTag(ObjectId id);
  Future<List<Tag>> getAll(List<dynamic> ids);
  connect();
}
