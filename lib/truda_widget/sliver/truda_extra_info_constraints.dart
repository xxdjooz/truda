import 'package:flutter/widgets.dart';

/// A box constraints with extra information.
///
/// See also:
///   * [NewHitaSliverFlexibleHeader], which use [TrudaExtraInfoBoxConstraints].
///   * [NewHitaSliverPersistentHeaderToBox], which use [TrudaExtraInfoBoxConstraints].
class TrudaExtraInfoBoxConstraints<T> extends BoxConstraints {
  TrudaExtraInfoBoxConstraints(
    this.extra,
    BoxConstraints constraints,
  ) : super(
          minWidth: constraints.minWidth,
          minHeight: constraints.minHeight,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        );

  /// extra information
  final T extra;

  BoxConstraints asBoxConstraints() => copyWith();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrudaExtraInfoBoxConstraints &&
        super == other &&
        other.extra == extra;
  }

  @override
  int get hashCode {
    return hashValues(super.hashCode, extra);
  }
}
