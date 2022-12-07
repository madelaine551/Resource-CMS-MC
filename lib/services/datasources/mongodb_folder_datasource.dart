///------------------------------
///          Packages
///------------------------------

import 'package:get_it/get_it.dart';
import 'package:resource_cms/models/folder.dart';
import 'package:resource_cms/services/datasources/resource_datasource.dart';
import 'package:resource_cms/services/datasources/tag_datasource.dart';
import 'folder_datasource.dart';
import 'mongodb_tag_datasource.dart';
import 'mongodb_resource_datasource.dart';
import 'package:mongo_dart/mongo_dart.dart';

///------------------------------
///      Datasource Class
///------------------------------

class MongodbFolderDatasource implements FolderDatasource {
  final url =
      "mongodb+srv://resource-cms:XGv6PUxXsIaIfTAz@resource-cms.ordbpx5.mongodb.net/ResourceCMS";
  late Future init;
  late Db db;
  late DbCollection collection;
  bool initialised = false;
  MongodbResourceDatasource MRD = MongodbResourceDatasource();
  MongodbTagDatasource MTD = MongodbTagDatasource();

  ///------------------------------
  ///    Datasource Constructor
  ///------------------------------

  MongodbFolderDatasource() {
    connect();
  }

  @override
  connect() async {
    db = await Db.create(url);
    await db.open();
    collection = db.collection('Folders');

    initialised = true;
  }

  ///------------------------------
  ///     Add Folder Override
  ///------------------------------

  @override
  Future<bool> addFolder(Folder f) async {
    await collection.insertOne(f.toMap());
    return true;
  }

  ///------------------------------
  ///   Get all Folders Override
  ///------------------------------

  @override
  Future<List<Folder>> all() async {
    if (!initialised) return <Folder>[];

    List<Map<String, dynamic>> allJson = await collection.find().toList();

    List<Folder> all = [];

    for (Map<String, dynamic> f in allJson) {
      List<dynamic> _resources = [];

      _resources
          .addAll(await GetIt.I<FolderDatasource>().getAll(f['Resources']));
      _resources
          .addAll(await GetIt.I<ResourceDatasource>().getAll(f['Resources']));

      all.add(Folder(
          id: f['_id'].toHexString(),
          title: f['Title'],
          type: f['Type'],
          description: f['Description'],
          tags: await GetIt.I<TagDatasource>().getAll(f['Tags']),
          resources: _resources));
    }

    return all;
  }

  ///------------------------------
  ///    Delete Folder Override
  ///------------------------------

  @override
  Future<bool> deleteFolder(Folder f) async {
    await collection.deleteOne(f);

    return true;
  }

  ///------------------------------
  ///     Get Folder Override
  ///------------------------------

  @override
  Future<Folder> getFolder(ObjectId id) async {
    Map<String, dynamic>? result =
        await collection.findOne(where.gt('_id', id));

    if (result == null) {
      return Folder(
          id: '',
          title: '',
          type: '',
          description: '',
          tags: [],
          resources: []);
    }

    // List<dynamic> _resources = [];

    // _resources
    //     .addAll(await GetIt.I<FolderDatasource>().getAll(result['Resources']));
    // _resources.addAll(
    //     await GetIt.I<ResourceDatasource>().getAll(result['Resources']));

    return Folder(
        id: result['_id'].toHexString(),
        title: result['Title'],
        type: result['Type'],
        description: result['Description'],
        tags: [],
        resources: []);
    // tags: await GetIt.I<TagDatasource>().getAll(result['Tags']),
    // resources: _resources);
  }

  ///------------------------------
  ///    Update Folder Override
  ///------------------------------

  @override
  Future<bool> updateFolder(Folder f) async {
    await collection.updateOne(
        where.eq('_id', f.id),
        modify
            .set('Title', f.title)
            .set('Type', f.type)
            .set('Description', f.description)
            .set('Tags', f.tags)
            .set('Resources', f.resources));

    return true;
  }

  ///------------------------------
  ///Get All Folders From Override
  ///------------------------------

  @override
  Future<List<Folder>> getAll(List<dynamic> ids) async {
    List<Folder> results = [];

    for (ObjectId id in ids) {
      Folder result = await getFolder(id);

      if (result.id != '') {
        results.add(result);
      }
    }

    return results;
  }
}
