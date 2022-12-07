///------------------------------
///          Packages
///------------------------------

import 'package:mongo_dart/mongo_dart.dart';
import 'package:resource_cms/models/resource.dart';

///------------------------------
///      Datasource Class
///------------------------------

abstract class ResourceDatasource {
  Future<List<Resource>> all();
  Future<bool> addResource(Resource r);
  Future<List<Resource>> getAll(List<dynamic> ids);
  Future<Resource> getResource(ObjectId id);
  connect();
}
