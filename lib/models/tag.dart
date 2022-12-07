///------------------------------
///          Packages
///------------------------------

import 'package:mongo_dart/mongo_dart.dart';

///------------------------------
///         Tag Class
///------------------------------

class Tag {
  final String id;
  final String name;

  ///------------------------------
  ///       Tag Constructor
  ///------------------------------

  Tag({
    required this.id,
    required this.name,
  });

  ///------------------------------
  ///     Convert self to map
  ///------------------------------

  Map<String, dynamic> toMap() {
    return {
      '_id': ObjectId.fromHexString(id),
      'Name': name,
    };
  }

  ///------------------------------
  ///  Create self from Json map
  ///------------------------------

  factory Tag.fromJSON(Map<String, dynamic>? json) {
    return Tag(id: json!['_id'].toHexString(), name: json['Name']);
  }
}
