// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPairCollection on Isar {
  IsarCollection<Pair> get pairs => this.collection();
}

const PairSchema = CollectionSchema(
  name: r'Pair',
  id: -3124465371488267306,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'lastHighfiveAt': PropertySchema(
      id: 2,
      name: r'lastHighfiveAt',
      type: IsarType.dateTime,
    ),
    r'members': PropertySchema(
      id: 3,
      name: r'members',
      type: IsarType.stringList,
    )
  },
  estimateSize: _pairEstimateSize,
  serialize: _pairSerialize,
  deserialize: _pairDeserialize,
  deserializeProp: _pairDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _pairGetId,
  getLinks: _pairGetLinks,
  attach: _pairAttach,
  version: '3.1.0+1',
);

int _pairEstimateSize(
  Pair object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.members.length * 3;
  {
    for (var i = 0; i < object.members.length; i++) {
      final value = object.members[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _pairSerialize(
  Pair object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.lastHighfiveAt);
  writer.writeStringList(offsets[3], object.members);
}

Pair _pairDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Pair();
  object.category = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.lastHighfiveAt = reader.readDateTimeOrNull(offsets[2]);
  object.members = reader.readStringList(offsets[3]) ?? [];
  return object;
}

P _pairDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pairGetId(Pair object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pairGetLinks(Pair object) {
  return [];
}

void _pairAttach(IsarCollection<dynamic> col, Id id, Pair object) {
  object.id = id;
}

extension PairQueryWhereSort on QueryBuilder<Pair, Pair, QWhere> {
  QueryBuilder<Pair, Pair, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PairQueryWhere on QueryBuilder<Pair, Pair, QWhereClause> {
  QueryBuilder<Pair, Pair, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Pair, Pair, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PairQueryFilter on QueryBuilder<Pair, Pair, QFilterCondition> {
  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> lastHighfiveAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastHighfiveAt',
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> lastHighfiveAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastHighfiveAt',
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> lastHighfiveAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastHighfiveAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> lastHighfiveAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastHighfiveAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> lastHighfiveAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastHighfiveAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> lastHighfiveAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastHighfiveAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'members',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'members',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'members',
        value: '',
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'members',
        value: '',
      ));
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Pair, Pair, QAfterFilterCondition> membersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PairQueryObject on QueryBuilder<Pair, Pair, QFilterCondition> {}

extension PairQueryLinks on QueryBuilder<Pair, Pair, QFilterCondition> {}

extension PairQuerySortBy on QueryBuilder<Pair, Pair, QSortBy> {
  QueryBuilder<Pair, Pair, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> sortByLastHighfiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHighfiveAt', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> sortByLastHighfiveAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHighfiveAt', Sort.desc);
    });
  }
}

extension PairQuerySortThenBy on QueryBuilder<Pair, Pair, QSortThenBy> {
  QueryBuilder<Pair, Pair, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenByLastHighfiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHighfiveAt', Sort.asc);
    });
  }

  QueryBuilder<Pair, Pair, QAfterSortBy> thenByLastHighfiveAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHighfiveAt', Sort.desc);
    });
  }
}

extension PairQueryWhereDistinct on QueryBuilder<Pair, Pair, QDistinct> {
  QueryBuilder<Pair, Pair, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pair, Pair, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Pair, Pair, QDistinct> distinctByLastHighfiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastHighfiveAt');
    });
  }

  QueryBuilder<Pair, Pair, QDistinct> distinctByMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'members');
    });
  }
}

extension PairQueryProperty on QueryBuilder<Pair, Pair, QQueryProperty> {
  QueryBuilder<Pair, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Pair, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<Pair, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Pair, DateTime?, QQueryOperations> lastHighfiveAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastHighfiveAt');
    });
  }

  QueryBuilder<Pair, List<String>, QQueryOperations> membersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'members');
    });
  }
}
