// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_9axis.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetData9AxisCollection on Isar {
  IsarCollection<Data9Axis> get data9Axis => this.collection();
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
  Data9Axis object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _data9AxisSerialize(
  Data9Axis object,
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

Data9Axis _data9AxisDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Data9Axis(
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

Id _data9AxisGetId(Data9Axis object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _data9AxisGetLinks(Data9Axis object) {
  return [];
}

void _data9AxisAttach(IsarCollection<dynamic> col, Id id, Data9Axis object) {
  object.id = id;
}

extension Data9AxisQueryWhereSort
    on QueryBuilder<Data9Axis, Data9Axis, QWhere> {
  QueryBuilder<Data9Axis, Data9Axis, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension Data9AxisQueryWhere
    on QueryBuilder<Data9Axis, Data9Axis, QWhereClause> {
  QueryBuilder<Data9Axis, Data9Axis, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterWhereClause> idBetween(
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

extension Data9AxisQueryFilter
    on QueryBuilder<Data9Axis, Data9Axis, QFilterCondition> {
  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> axIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ax',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> axIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ax',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> axEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> axGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> axLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> axBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> ayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ay',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> ayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ay',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> ayEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> ayGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> ayLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> ayBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> azIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'az',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> azIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'az',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> azEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> azGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> azLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> azBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> pitchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pitch',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> pitchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pitch',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> pitchEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> pitchGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> pitchLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> pitchBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> rollIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'roll',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> rollIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'roll',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> rollEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> rollGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> rollLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> rollBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> timeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> timeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> timeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> timeGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> timeLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> timeBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wx',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wx',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wxEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wxGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wxLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wxBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wy',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wy',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wyEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wyGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wyLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wyBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wzIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wz',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wzIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wz',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wzEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wzGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wzLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> wzBetween(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> yawIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'yaw',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> yawIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'yaw',
      ));
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> yawEqualTo(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> yawGreaterThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> yawLessThan(
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

  QueryBuilder<Data9Axis, Data9Axis, QAfterFilterCondition> yawBetween(
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

extension Data9AxisQueryObject
    on QueryBuilder<Data9Axis, Data9Axis, QFilterCondition> {}

extension Data9AxisQueryLinks
    on QueryBuilder<Data9Axis, Data9Axis, QFilterCondition> {}

extension Data9AxisQuerySortBy on QueryBuilder<Data9Axis, Data9Axis, QSortBy> {
  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByAx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByAxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByAy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByAyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByAz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByAzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByRoll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByRollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByWx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByWxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByWy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByWyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByWz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByWzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByYaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> sortByYawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.desc);
    });
  }
}

extension Data9AxisQuerySortThenBy
    on QueryBuilder<Data9Axis, Data9Axis, QSortThenBy> {
  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByAx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByAxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ax', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByAy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByAyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ay', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByAz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByAzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'az', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pitch', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByRoll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByRollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roll', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByWx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByWxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wx', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByWy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByWyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wy', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByWz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByWzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wz', Sort.desc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByYaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.asc);
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QAfterSortBy> thenByYawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yaw', Sort.desc);
    });
  }
}

extension Data9AxisQueryWhereDistinct
    on QueryBuilder<Data9Axis, Data9Axis, QDistinct> {
  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByAx() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ax');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByAy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ay');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByAz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'az');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pitch');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByRoll() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roll');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByWx() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wx');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByWy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wy');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByWz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wz');
    });
  }

  QueryBuilder<Data9Axis, Data9Axis, QDistinct> distinctByYaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yaw');
    });
  }
}

extension Data9AxisQueryProperty
    on QueryBuilder<Data9Axis, Data9Axis, QQueryProperty> {
  QueryBuilder<Data9Axis, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> axProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ax');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> ayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ay');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> azProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'az');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> pitchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pitch');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> rollProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roll');
    });
  }

  QueryBuilder<Data9Axis, int?, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> wxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wx');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> wyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wy');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> wzProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wz');
    });
  }

  QueryBuilder<Data9Axis, double?, QQueryOperations> yawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yaw');
    });
  }
}
