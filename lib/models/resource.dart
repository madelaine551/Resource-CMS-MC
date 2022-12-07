///------------------------------
///          Packages
///------------------------------

import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:resource_cms/services/datasources/tag_datasource.dart';

///------------------------------
///          Packages
///------------------------------

import 'tag.dart';

///------------------------------
///       Resource Class
///------------------------------

class Resource {
  final String id;
  final String name;
  final String link;
  final List<Tag> tags;

  ///------------------------------
  ///     Resource Constructor
  ///------------------------------

  Resource(
      {required this.id,
      required this.name,
      required this.link,
      required this.tags});

  ///------------------------------
  ///     Convert self to map
  ///------------------------------

  Map<String, dynamic> toMap() {
    return {
      '_id': ObjectId.fromHexString(id),
      'Name': name,
      'Link': link,
      'Tags': tags.map((t) => ObjectId.fromHexString(t.id)),
    };
  }

  ///------------------------------
  ///  Create self from Json map
  ///------------------------------

  factory Resource.fromJSON(Map<String, dynamic>? json) {
    return Resource(
        id: json!['_id'].toHexString(),
        name: json['Name'],
        link: json['Link'],
        tags: []);
  }
}
