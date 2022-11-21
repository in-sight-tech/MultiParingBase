// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_signal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSensorSignalCollection on Isar {
  IsarCollection<SensorSignal> get sensorSignals => this.collection();
}

const SensorSignalSchema = CollectionSchema(
  name: r'SensorSignal',
  id: -7235122058794533307,
  properties: {
    r'sensorId': PropertySchema(
      id: 0,
      name: r'sensorId',
      type: IsarType.string,
    ),
    r'signals': PropertySchema(
      id: 1,
      name: r'signals',
      type: IsarType.doubleList,
    )
  },
  estimateSize: _sensorSignalEstimateSize,
  serialize: _sensorSignalSerialize,
  deserialize: _sensorSignalDeserialize,
  deserializeProp: _sensorSignalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sensorSignalGetId,
  getLinks: _sensorSignalGetLinks,
  attach: _sensorSignalAttach,
  version: '3.0.4',
);

int _sensorSignalEstimateSize(
  SensorSignal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sensorId.length * 3;
  bytesCount += 3 + object.signals.length * 8;
  return bytesCount;
}

void _sensorSignalSerialize(
  SensorSignal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.sensorId);
  writer.writeDoubleList(offsets[1], object.signals);
}

SensorSignal _sensorSignalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SensorSignal(
    sensorId: reader.readString(offsets[0]),
    signals: reader.readDoubleOrNullList(offsets[1]) ?? [],
  );
  object.id = id;
  return object;
}

P _sensorSignalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDoubleOrNullList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sensorSignalGetId(SensorSignal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sensorSignalGetLinks(SensorSignal object) {
  return [];
}

void _sensorSignalAttach(
    IsarCollection<dynamic> col, Id id, SensorSignal object) {
  object.id = id;
}

extension SensorSignalQueryWhereSort
    on QueryBuilder<SensorSignal, SensorSignal, QWhere> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SensorSignalQueryWhere
    on QueryBuilder<SensorSignal, SensorSignal, QWhereClause> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idBetween(
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

extension SensorSignalQueryFilter
    on QueryBuilder<SensorSignal, SensorSignal, QFilterCondition> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sensorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sensorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sensorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sensorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sensorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sensorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sensorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sensorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sensorId',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      sensorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sensorId',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNull(
        property: r'signals',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsElementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNotNull(
        property: r'signals',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsElementEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signals',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsElementGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signals',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsElementLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signals',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsElementBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signals',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition>
      signalsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SensorSignalQueryObject
    on QueryBuilder<SensorSignal, SensorSignal, QFilterCondition> {}

extension SensorSignalQueryLinks
    on QueryBuilder<SensorSignal, SensorSignal, QFilterCondition> {}

extension SensorSignalQuerySortBy
    on QueryBuilder<SensorSignal, SensorSignal, QSortBy> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortBySensorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorId', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortBySensorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorId', Sort.desc);
    });
  }
}

extension SensorSignalQuerySortThenBy
    on QueryBuilder<SensorSignal, SensorSignal, QSortThenBy> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenBySensorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorId', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenBySensorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorId', Sort.desc);
    });
  }
}

extension SensorSignalQueryWhereDistinct
    on QueryBuilder<SensorSignal, SensorSignal, QDistinct> {
  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctBySensorId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sensorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctBySignals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signals');
    });
  }
}

extension SensorSignalQueryProperty
    on QueryBuilder<SensorSignal, SensorSignal, QQueryProperty> {
  QueryBuilder<SensorSignal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SensorSignal, String, QQueryOperations> sensorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sensorId');
    });
  }

  QueryBuilder<SensorSignal, List<double?>, QQueryOperations>
      signalsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signals');
    });
  }
}
