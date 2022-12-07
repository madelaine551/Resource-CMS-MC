///------------------------------
///          Packages
///------------------------------

import 'package:resource_cms/models/tag.dart';
import 'tag_datasource.dart';
import 'package:mongo_dart/mongo_dart.dart';

///------------------------------
///      Datasource Class
///------------------------------

class MongodbTagDatasource implements TagDatasource {
  final url =
      "mongodb+srv://resource-cms:XGv6PUxXsIaIfTAz@resource-cms.ordbpx5.mongodb.net/ResourceCMS";
  late Future init;
  late Db db;
  late DbCollection collection;
  bool initialised = false;

  ///------------------------------
  ///    Datasource Constructor
  ///------------------------------

  MongodbTagDatasource() {
    // init = Future(() async {
    //   db = await Db.create(url);
    //   await db.open();
    //   collection = db.collection('Tags');
    // });
    // initialised = true;
  }

  @override
  connect() async {
    db = await Db.create(url);
    await db.open();
    collection = db.collection('Tags');

    initialised = true;
  }

  ///------------------------------
  ///      Add Tag Override
  ///------------------------------

  @override
  Future<bool> addTag(Tag t) async {
    await collection.insertOne(t.toMap());
    return true;
  }

  ///------------------------------
  ///    Get all Tags Override
  ///------------------------------

  @override
  Future<List<Tag>> all() async {
    if (!initialised) return <Tag>[];

    List<Map<String, dynamic>> all = await collection.find().toList();

    return all.cast();
  }

  ///------------------------------
  ///      Get Tag Override
  ///------------------------------

  @override
  Future<Tag> getTag(ObjectId id) async {
    Map<String, dynamic>? result =
        await collection.findOne(where.eq('_id', id));

    return Tag.fromJSON(result);
  }

  ///------------------------------
  ///  Get All Tags From Override
  ///------------------------------
  @override
  Future<List<Tag>> getAll(List<dynamic> ids) async {
    List<Tag> results = [];

    for (ObjectId id in ids) {
      results.add(await getTag(id));
    }

    return results;
  }
}
