// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_information.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSensorInformationCollection on Isar {
  IsarCollection<SensorInformation> get sensorInformations => this.collection();
}

const SensorInformationSchema = CollectionSchema(
  name: r'SensorInformation',
  id: 3020779261061262747,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'names': PropertySchema(
      id: 1,
      name: r'names',
      type: IsarType.stringList,
    ),
    r'type': PropertySchema(
      id: 2,
      name: r'type',
      type: IsarType.byte,
      enumMap: _SensorInformationtypeEnumValueMap,
    ),
    r'units': PropertySchema(
      id: 3,
      name: r'units',
      type: IsarType.stringList,
    )
  },
  estimateSize: _sensorInformationEstimateSize,
  serialize: _sensorInformationSerialize,
  deserialize: _sensorInformationDeserialize,
  deserializeProp: _sensorInformationDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sensorInformationGetId,
  getLinks: _sensorInformationGetLinks,
  attach: _sensorInformationAttach,
  version: '3.0.4',
);

int _sensorInformationEstimateSize(
  SensorInformation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.names.length * 3;
  {
    for (var i = 0; i < object.names.length; i++) {
      final value = object.names[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.units.length * 3;
  {
    for (var i = 0; i < object.units.length; i++) {
      final value = object.units[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _sensorInformationSerialize(
  SensorInformation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeStringList(offsets[1], object.names);
  writer.writeByte(offsets[2], object.type.index);
  writer.writeStringList(offsets[3], object.units);
}

SensorInformation _sensorInformationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SensorInformation(
    id: reader.readString(offsets[0]),
    names: reader.readStringList(offsets[1]) ?? [],
    type:
        _SensorInformationtypeValueEnumMap[reader.readByteOrNull(offsets[2])] ??
            SensorType.bwt901cl,
    units: reader.readStringList(offsets[3]) ?? [],
  );
  return object;
}

P _sensorInformationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (_SensorInformationtypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SensorType.bwt901cl) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SensorInformationtypeEnumValueMap = {
  'bwt901cl': 0,
  'strainGauge': 1,
  'imu': 2,
  'analog': 3,
};
const _SensorInformationtypeValueEnumMap = {
  0: SensorType.bwt901cl,
  1: SensorType.strainGauge,
  2: SensorType.imu,
  3: SensorType.analog,
};

Id _sensorInformationGetId(SensorInformation object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _sensorInformationGetLinks(
    SensorInformation object) {
  return [];
}

void _sensorInformationAttach(
    IsarCollection<dynamic> col, Id id, SensorInformation object) {}

extension SensorInformationQueryWhereSort
    on QueryBuilder<SensorInformation, SensorInformation, QWhere> {
  QueryBuilder<SensorInformation, SensorInformation, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SensorInformationQueryWhere
    on QueryBuilder<SensorInformation, SensorInformation, QWhereClause> {
  QueryBuilder<SensorInformation, SensorInformation, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SensorInformationQueryFilter
    on QueryBuilder<SensorInformation, SensorInformation, QFilterCondition> {
  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'names',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'names',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'names',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'names',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'names',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'names',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'names',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'names',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'names',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'names',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'names',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'names',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'names',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'names',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'names',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      namesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'names',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      typeEqualTo(SensorType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      typeGreaterThan(
    SensorType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      typeLessThan(
    SensorType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      typeBetween(
    SensorType lower,
    SensorType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'units',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'units',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'units',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'units',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'units',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'units',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'units',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'units',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'units',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'units',
        value: '',
      ));
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'units',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'units',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'units',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'units',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'units',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterFilterCondition>
      unitsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'units',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SensorInformationQueryObject
    on QueryBuilder<SensorInformation, SensorInformation, QFilterCondition> {}

extension SensorInformationQueryLinks
    on QueryBuilder<SensorInformation, SensorInformation, QFilterCondition> {}

extension SensorInformationQuerySortBy
    on QueryBuilder<SensorInformation, SensorInformation, QSortBy> {
  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SensorInformationQuerySortThenBy
    on QueryBuilder<SensorInformation, SensorInformation, QSortThenBy> {
  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SensorInformationQueryWhereDistinct
    on QueryBuilder<SensorInformation, SensorInformation, QDistinct> {
  QueryBuilder<SensorInformation, SensorInformation, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QDistinct>
      distinctByNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'names');
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QDistinct>
      distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<SensorInformation, SensorInformation, QDistinct>
      distinctByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'units');
    });
  }
}

extension SensorInformationQueryProperty
    on QueryBuilder<SensorInformation, SensorInformation, QQueryProperty> {
  QueryBuilder<SensorInformation, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SensorInformation, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SensorInformation, List<String>, QQueryOperations>
      namesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'names');
    });
  }

  QueryBuilder<SensorInformation, SensorType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<SensorInformation, List<String>, QQueryOperations>
      unitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'units');
    });
  }
}
