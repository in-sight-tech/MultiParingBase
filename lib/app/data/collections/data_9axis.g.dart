// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_9axis.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetData9AxisCollection on Isar {
  IsarCollection<SensorSignal> get data9Axis => this.collection();
}

const Data9AxisSchema = CollectionSchema(
  name: r'Data9Axis',
  id: 7592697079469065013,
  properties: {
    r'ax': PropertySchema(
      id: 0,
      name: r'ax',
      type: IsarType.double,
    ),
    r'ay': PropertySchema(
      id: 1,
      name: r'ay',
      type: IsarType.double,
    ),
    r'az': PropertySchema(
      id: 2,
      name: r'az',
      type: IsarType.double,
    ),
    r'pitch': PropertySchema(
      id: 3,
      name: r'pitch',
      type: IsarType.double,
    ),
    r'roll': PropertySchema(
      id: 4,
      name: r'roll',
      type: IsarType.double,
    ),
    r'time': PropertySchema(
      id: 5,
      name: r'time',
      type: IsarType.long,
    ),
    r'wx': PropertySchema(
      id: 6,
      name: r'wx',
      type: IsarType.double,
    ),
    r'wy': PropertySchema(
      id: 7,
      name: r'wy',
      type: IsarType.double,
    ),
    r'wz': PropertySchema(
      id: 8,
      name: r'wz',
      type: IsarType.double,
    ),
    r'yaw': PropertySchema(
      id: 9,
      name: r'yaw',
      type: IsarType.double,
    )
  },
  estimateSize: _data9AxisEstimateSize,
  serialize: _data9AxisSerialize,
  deserialize: _data9AxisDeserialize,
  deserializeProp: _data9AxisDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _data9AxisGetId,
  getLinks: _data9AxisGetLinks,
  attach: _data9AxisAttach,
  version: '3.0.4',
);

int _data9AxisEstimateSize(
  SensorSignal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _data9AxisSerialize(
  SensorSignal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.ax);
  writer.writeDouble(offsets[1], object.ay);
  writer.writeDouble(offsets[2], object.az);
  writer.writeDouble(offsets[3], object.pitch);
  writer.writeDouble(offsets[4], object.roll);
  writer.writeLong(offsets[5], object.time);
  writer.writeDouble(offsets[6], object.wx);
  writer.writeDouble(offsets[7], object.wy);
  writer.writeDouble(offsets[8], object.wz);
  writer.writeDouble(offsets[9], object.yaw);
}

SensorSignal _data9AxisDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SensorSignal(
    time: reader.readLongOrNull(offsets[5]),
  );
  object.ax = reader.readDoubleOrNull(offsets[0]);
  object.ay = reader.readDoubleOrNull(offsets[1]);
  object.az = reader.readDoubleOrNull(offsets[2]);
  object.id = id;
  object.pitch = reader.readDoubleOrNull(offsets[3]);
  object.roll = reader.readDoubleOrNull(offsets[4]);
  object.wx = reader.readDoubleOrNull(offsets[6]);
  object.wy = reader.readDoubleOrNull(offsets[7]);
  object.wz = reader.readDoubleOrNull(offsets[8]);
  object.yaw = reader.readDoubleOrNull(offsets[9]);
  return object;
}

P _data9AxisDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _data9AxisGetId(SensorSignal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _data9AxisGetLinks(SensorSignal object) {
  return [];
}

void _data9AxisAttach(IsarCollection<dynamic> col, Id id, SensorSignal object) {
  object.id = id;
}

extension Data9AxisQueryWhereSort on QueryBuilder<SensorSignal, SensorSignal, QWhere> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension Data9AxisQueryWhere on QueryBuilder<SensorSignal, SensorSignal, QWhereClause> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
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

extension Data9AxisQueryFilter on QueryBuilder<SensorSignal, SensorSignal, QFilterCondition> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> axIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ax',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> axIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ax',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> axEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> axGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> axLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> axBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> ayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ay',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> ayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ay',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> ayEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> ayGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> ayLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> ayBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> azIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'az',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> azIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'az',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> azEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'az',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> azGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'az',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> azLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'az',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> azBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'az',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> idEqualTo(Id value) {
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

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> pitchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pitch',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> pitchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pitch',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> pitchEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pitch',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> pitchGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pitch',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> pitchLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pitch',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> pitchBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pitch',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> rollIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'roll',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> rollIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'roll',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> rollEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roll',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> rollGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roll',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> rollLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roll',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> rollBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roll',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> timeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> timeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> timeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> timeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> timeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> timeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wx',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wx',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wxEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wxGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wxLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wxBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wx',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wy',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wy',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wzIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wz',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wzIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wz',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wzEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wz',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wzGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wz',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wzLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wz',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> wzBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wz',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> yawIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'yaw',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> yawIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'yaw',
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> yawEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yaw',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> yawGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yaw',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> yawLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yaw',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterFilterCondition> yawBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension Data9AxisQueryObject on QueryBuilder<SensorSignal, SensorSignal, QFilterCondition> {}

extension Data9AxisQueryLinks on QueryBuilder<SensorSignal, SensorSignal, QFilterCondition> {}

extension Data9AxisQuerySortBy on QueryBuilder<SensorSignal, SensorSignal, QSortBy> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByAx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByAxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByAy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByAyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByAz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByAzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByRoll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByRollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByWx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByWxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByWy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByWyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByWz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByWzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByYaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> sortByYawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.desc);
    });
  }
}

extension Data9AxisQuerySortThenBy on QueryBuilder<SensorSignal, SensorSignal, QSortThenBy> {
  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByAx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByAxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByAy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByAyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByAz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByAzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.desc);
    });
  }

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

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByRoll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByRollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByWx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByWxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByWy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByWyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByWz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByWzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.desc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByYaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.asc);
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QAfterSortBy> thenByYawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.desc);
    });
  }
}

extension Data9AxisQueryWhereDistinct on QueryBuilder<SensorSignal, SensorSignal, QDistinct> {
  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByAx() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ax');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByAy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ay');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByAz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'az');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pitch');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByRoll() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roll');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByWx() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wx');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByWy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wy');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByWz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wz');
    });
  }

  QueryBuilder<SensorSignal, SensorSignal, QDistinct> distinctByYaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yaw');
    });
  }
}

extension Data9AxisQueryProperty on QueryBuilder<SensorSignal, SensorSignal, QQueryProperty> {
  QueryBuilder<SensorSignal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> axProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ax');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> ayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ay');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> azProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'az');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> pitchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pitch');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> rollProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roll');
    });
  }

  QueryBuilder<SensorSignal, int?, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> wxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wx');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> wyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wy');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> wzProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wz');
    });
  }

  QueryBuilder<SensorSignal, double?, QQueryOperations> yawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yaw');
    });
  }
}
