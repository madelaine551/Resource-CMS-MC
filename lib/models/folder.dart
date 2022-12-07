///------------------------------
///          Packages
///------------------------------

import 'package:resource_cms/services/datasources/tag_datasource.dart';

import 'tag.dart';
import 'resource.dart';
import 'package:mongo_dart/mongo_dart.dart';

///------------------------------
///        Folder Class
///------------------------------

class Folder {
  final String id;
  final String title;
  final String type;
  final String description;
  final List<Tag> tags;
  final List<dynamic> resources;

  ///------------------------------
  ///      Folder Constructor
  ///------------------------------

  Folder(
      {required this.id,
      required this.title,
      required this.type,
      required this.description,
      required this.tags,
      required this.resources});

  ///------------------------------
  ///     Convert self to map
  ///------------------------------

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'Title': title,
      'Type': type,
      'Description': description,
      'Tags': tags.map((t) => ObjectId.fromHexString(t.id)),
      'Resources': resources.map((r) => ObjectId.fromHexString(r.id)),
    };
  }

  ///------------------------------
  ///  Create self from Json map
  ///------------------------------

  factory Folder.fromJSON(Map<String, dynamic> json) {
    // TODO: replace json['Tags'] with some way of retrieving all tags
    return Folder(
        id: json['_id'].toHexString(),
        title: json['Title'],
        type: json['Type'],
        description: json['Description'],
        tags: [],
        resources: []);
  }
}
