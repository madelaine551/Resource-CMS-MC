///------------------------------
///          Packages
///------------------------------

import 'package:get_it/get_it.dart';
import 'package:resource_cms/models/resource.dart';
import 'package:resource_cms/services/datasources/tag_datasource.dart';
import 'resource_datasource.dart';
import 'package:mongo_dart/mongo_dart.dart';

///------------------------------
///      Datasource Class
///------------------------------

class MongodbResourceDatasource implements ResourceDatasource {
  final url =
      "mongodb+srv://resource-cms:XGv6PUxXsIaIfTAz@resource-cms.ordbpx5.mongodb.net/ResourceCMS";
  late Future init;
  late Db db;
  late DbCollection collection;
  bool initialised = false;

  ///------------------------------
  ///    Datasource Constructor
  ///------------------------------

  MongodbResourceDatasource() {
    // init = Future(() async {
    //   db = await Db.create(url);
    //   await db.open();
    //   collection = db.collection('Resources');
    // });
    // initialised = false;
    connect();
  }

  @override
  connect() async {
    db = await Db.create(url);
    await db.open();
    collection = db.collection('Resources');

    initialised = true;
  }

  ///------------------------------
  ///    Add Resource Override
  ///------------------------------

  @override
  Future<bool> addResource(Resource r) async {
    await collection.insertOne(r.toMap());
    return true;
  }

  ///------------------------------
  ///  Get all Resources Override
  ///------------------------------

  @override
  Future<List<Resource>> all() async {
    if (!initialised) return <Resource>[];

    List<Map<String, dynamic>> allJson = await collection.find().toList();

    List<Resource> all = [];

    for (Map<String, dynamic> r in allJson) {
      all.add(Resource(
          id: r['_id'].toHexString(),
          name: r['Name'],
          link: r['Link'],
          tags: await GetIt.I<TagDatasource>().getAll(r['Tags'])));
    }

    return all.cast();
  }

  ///------------------------------
  ///    Get Resource Override
  ///------------------------------

  @override
  Future<Resource> getResource(ObjectId id) async {
    Map<String, dynamic>? result =
        await collection.findOne(where.eq('_id', id));

    if (result == null) {
      return Resource(
        id: '',
        name: '',
        link: '',
        tags: [],
      );
    }

    return Resource(
        id: result['_id'].toHexString(),
        name: result['Name'],
        link: result['Link'],
        tags: []);
    //tags: await GetIt.I<TagDatasource>().getAll(result['Tags']));
  }

  ///------------------------------
  ///Get All Resources From Override
  ///------------------------------

  @override
  Future<List<Resource>> getAll(List<dynamic> ids) async {
    List<Resource> results = [];

    for (ObjectId id in ids) {
      Resource result = await getResource(id);

      if (result.id != '') {
        results.add(result);
      }
    }

    return results;
  }
}
