import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

// ignore_for_file: public_member_api_docs

@Entity()
class TrudaHerEntity {
  /// In ObjectBox, entities must have one 64-bit integer ID property with non-private
  /// visibility (or non-private getter and setter method) to efficiently get or reference objects.
  /// Annotate with @Id() if name isn't "id" (case insensitive).
  int id;

  /// If you need to use another type for IDs (such as a string UID given by a server),
  /// model them as regular properties and use queries to look up objects by your application-specific ID.
  /// Also, make sure to index the property, and if it's a string use a case-sensitive condition, to speed up lookups.
  /// To prevent duplicates it is also possible to enforce a unique value for this secondary ID.

  @Unique()
  String uid;

  String name;

  String? portrait;

  /// Note: Stored in milliseconds without time zone info.
  @Property(type: PropertyType.date)
  DateTime date;

  // Not persisted:
  @Transient()
  int tempUsageCount = 0;

  TrudaHerEntity(this.name, this.uid,
      {this.id = 0, this.portrait, DateTime? date})
      : date = date ?? DateTime.now();

  String get dateFormat => DateFormat('dd.MM.yyyy HH:mm:ss').format(date);

  @override
  String toString() {
    return 'TrudaHerEntity={uid=$uid name=$name}';
  }
}
