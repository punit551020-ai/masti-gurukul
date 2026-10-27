// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SchoolClassesTable extends SchoolClasses
    with TableInfo<$SchoolClassesTable, SchoolClass> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameHindiMeta = const VerificationMeta(
    'nameHindi',
  );
  @override
  late final GeneratedColumn<String> nameHindi = GeneratedColumn<String>(
    'name_hindi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    nameHindi,
    nameEnglish,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'school_classes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchoolClass> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('name_hindi')) {
      context.handle(
        _nameHindiMeta,
        nameHindi.isAcceptableOrUnknown(data['name_hindi']!, _nameHindiMeta),
      );
    } else if (isInserting) {
      context.missing(_nameHindiMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchoolClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolClass(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      nameHindi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_hindi'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $SchoolClassesTable createAlias(String alias) {
    return $SchoolClassesTable(attachedDatabase, alias);
  }
}

class SchoolClass extends DataClass implements Insertable<SchoolClass> {
  final String id;
  final int level;
  final String nameHindi;
  final String nameEnglish;
  final int displayOrder;
  const SchoolClass({
    required this.id,
    required this.level,
    required this.nameHindi,
    required this.nameEnglish,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level'] = Variable<int>(level);
    map['name_hindi'] = Variable<String>(nameHindi);
    map['name_english'] = Variable<String>(nameEnglish);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  SchoolClassesCompanion toCompanion(bool nullToAbsent) {
    return SchoolClassesCompanion(
      id: Value(id),
      level: Value(level),
      nameHindi: Value(nameHindi),
      nameEnglish: Value(nameEnglish),
      displayOrder: Value(displayOrder),
    );
  }

  factory SchoolClass.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolClass(
      id: serializer.fromJson<String>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      nameHindi: serializer.fromJson<String>(json['nameHindi']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'level': serializer.toJson<int>(level),
      'nameHindi': serializer.toJson<String>(nameHindi),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  SchoolClass copyWith({
    String? id,
    int? level,
    String? nameHindi,
    String? nameEnglish,
    int? displayOrder,
  }) => SchoolClass(
    id: id ?? this.id,
    level: level ?? this.level,
    nameHindi: nameHindi ?? this.nameHindi,
    nameEnglish: nameEnglish ?? this.nameEnglish,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  SchoolClass copyWithCompanion(SchoolClassesCompanion data) {
    return SchoolClass(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      nameHindi: data.nameHindi.present ? data.nameHindi.value : this.nameHindi,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolClass(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('nameHindi: $nameHindi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, level, nameHindi, nameEnglish, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolClass &&
          other.id == this.id &&
          other.level == this.level &&
          other.nameHindi == this.nameHindi &&
          other.nameEnglish == this.nameEnglish &&
          other.displayOrder == this.displayOrder);
}

class SchoolClassesCompanion extends UpdateCompanion<SchoolClass> {
  final Value<String> id;
  final Value<int> level;
  final Value<String> nameHindi;
  final Value<String> nameEnglish;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const SchoolClassesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.nameHindi = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolClassesCompanion.insert({
    required String id,
    required int level,
    required String nameHindi,
    required String nameEnglish,
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       level = Value(level),
       nameHindi = Value(nameHindi),
       nameEnglish = Value(nameEnglish);
  static Insertable<SchoolClass> custom({
    Expression<String>? id,
    Expression<int>? level,
    Expression<String>? nameHindi,
    Expression<String>? nameEnglish,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (nameHindi != null) 'name_hindi': nameHindi,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolClassesCompanion copyWith({
    Value<String>? id,
    Value<int>? level,
    Value<String>? nameHindi,
    Value<String>? nameEnglish,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return SchoolClassesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      nameHindi: nameHindi ?? this.nameHindi,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (nameHindi.present) {
      map['name_hindi'] = Variable<String>(nameHindi.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolClassesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('nameHindi: $nameHindi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BoardsTable extends Boards with TableInfo<$BoardsTable, Board> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameHindiMeta = const VerificationMeta(
    'nameHindi',
  );
  @override
  late final GeneratedColumn<String> nameHindi = GeneratedColumn<String>(
    'name_hindi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameHindi,
    nameEnglish,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'boards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Board> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_hindi')) {
      context.handle(
        _nameHindiMeta,
        nameHindi.isAcceptableOrUnknown(data['name_hindi']!, _nameHindiMeta),
      );
    } else if (isInserting) {
      context.missing(_nameHindiMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Board map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Board(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameHindi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_hindi'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $BoardsTable createAlias(String alias) {
    return $BoardsTable(attachedDatabase, alias);
  }
}

class Board extends DataClass implements Insertable<Board> {
  final String id;
  final String nameHindi;
  final String nameEnglish;
  final int displayOrder;
  const Board({
    required this.id,
    required this.nameHindi,
    required this.nameEnglish,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_hindi'] = Variable<String>(nameHindi);
    map['name_english'] = Variable<String>(nameEnglish);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  BoardsCompanion toCompanion(bool nullToAbsent) {
    return BoardsCompanion(
      id: Value(id),
      nameHindi: Value(nameHindi),
      nameEnglish: Value(nameEnglish),
      displayOrder: Value(displayOrder),
    );
  }

  factory Board.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Board(
      id: serializer.fromJson<String>(json['id']),
      nameHindi: serializer.fromJson<String>(json['nameHindi']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameHindi': serializer.toJson<String>(nameHindi),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Board copyWith({
    String? id,
    String? nameHindi,
    String? nameEnglish,
    int? displayOrder,
  }) => Board(
    id: id ?? this.id,
    nameHindi: nameHindi ?? this.nameHindi,
    nameEnglish: nameEnglish ?? this.nameEnglish,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  Board copyWithCompanion(BoardsCompanion data) {
    return Board(
      id: data.id.present ? data.id.value : this.id,
      nameHindi: data.nameHindi.present ? data.nameHindi.value : this.nameHindi,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Board(')
          ..write('id: $id, ')
          ..write('nameHindi: $nameHindi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameHindi, nameEnglish, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Board &&
          other.id == this.id &&
          other.nameHindi == this.nameHindi &&
          other.nameEnglish == this.nameEnglish &&
          other.displayOrder == this.displayOrder);
}

class BoardsCompanion extends UpdateCompanion<Board> {
  final Value<String> id;
  final Value<String> nameHindi;
  final Value<String> nameEnglish;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const BoardsCompanion({
    this.id = const Value.absent(),
    this.nameHindi = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BoardsCompanion.insert({
    required String id,
    required String nameHindi,
    required String nameEnglish,
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameHindi = Value(nameHindi),
       nameEnglish = Value(nameEnglish);
  static Insertable<Board> custom({
    Expression<String>? id,
    Expression<String>? nameHindi,
    Expression<String>? nameEnglish,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameHindi != null) 'name_hindi': nameHindi,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BoardsCompanion copyWith({
    Value<String>? id,
    Value<String>? nameHindi,
    Value<String>? nameEnglish,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return BoardsCompanion(
      id: id ?? this.id,
      nameHindi: nameHindi ?? this.nameHindi,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameHindi.present) {
      map['name_hindi'] = Variable<String>(nameHindi.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoardsCompanion(')
          ..write('id: $id, ')
          ..write('nameHindi: $nameHindi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES school_classes (id)',
    ),
  );
  static const VerificationMeta _boardIdMeta = const VerificationMeta(
    'boardId',
  );
  @override
  late final GeneratedColumn<String> boardId = GeneratedColumn<String>(
    'board_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES boards (id)',
    ),
  );
  static const VerificationMeta _nameHindiMeta = const VerificationMeta(
    'nameHindi',
  );
  @override
  late final GeneratedColumn<String> nameHindi = GeneratedColumn<String>(
    'name_hindi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accentColorMeta = const VerificationMeta(
    'accentColor',
  );
  @override
  late final GeneratedColumn<String> accentColor = GeneratedColumn<String>(
    'accent_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('F1951A'),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    classId,
    boardId,
    nameHindi,
    nameEnglish,
    accentColor,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('board_id')) {
      context.handle(
        _boardIdMeta,
        boardId.isAcceptableOrUnknown(data['board_id']!, _boardIdMeta),
      );
    }
    if (data.containsKey('name_hindi')) {
      context.handle(
        _nameHindiMeta,
        nameHindi.isAcceptableOrUnknown(data['name_hindi']!, _nameHindiMeta),
      );
    } else if (isInserting) {
      context.missing(_nameHindiMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('accent_color')) {
      context.handle(
        _accentColorMeta,
        accentColor.isAcceptableOrUnknown(
          data['accent_color']!,
          _accentColorMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      )!,
      boardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board_id'],
      ),
      nameHindi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_hindi'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      )!,
      accentColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_color'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String classId;

  /// Null means the subject belongs to every board - that is how the original
  /// seeded list keeps working. A board id pins it to one syllabus, which is
  /// what lets a Bihar Board Class 10 Science sit beside a CBSE one without the
  /// two mixing.
  final String? boardId;
  final String nameHindi;
  final String nameEnglish;
  final String accentColor;
  final int displayOrder;
  const Subject({
    required this.id,
    required this.classId,
    this.boardId,
    required this.nameHindi,
    required this.nameEnglish,
    required this.accentColor,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['class_id'] = Variable<String>(classId);
    if (!nullToAbsent || boardId != null) {
      map['board_id'] = Variable<String>(boardId);
    }
    map['name_hindi'] = Variable<String>(nameHindi);
    map['name_english'] = Variable<String>(nameEnglish);
    map['accent_color'] = Variable<String>(accentColor);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      classId: Value(classId),
      boardId: boardId == null && nullToAbsent
          ? const Value.absent()
          : Value(boardId),
      nameHindi: Value(nameHindi),
      nameEnglish: Value(nameEnglish),
      accentColor: Value(accentColor),
      displayOrder: Value(displayOrder),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      classId: serializer.fromJson<String>(json['classId']),
      boardId: serializer.fromJson<String?>(json['boardId']),
      nameHindi: serializer.fromJson<String>(json['nameHindi']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      accentColor: serializer.fromJson<String>(json['accentColor']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'classId': serializer.toJson<String>(classId),
      'boardId': serializer.toJson<String?>(boardId),
      'nameHindi': serializer.toJson<String>(nameHindi),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'accentColor': serializer.toJson<String>(accentColor),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Subject copyWith({
    String? id,
    String? classId,
    Value<String?> boardId = const Value.absent(),
    String? nameHindi,
    String? nameEnglish,
    String? accentColor,
    int? displayOrder,
  }) => Subject(
    id: id ?? this.id,
    classId: classId ?? this.classId,
    boardId: boardId.present ? boardId.value : this.boardId,
    nameHindi: nameHindi ?? this.nameHindi,
    nameEnglish: nameEnglish ?? this.nameEnglish,
    accentColor: accentColor ?? this.accentColor,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      classId: data.classId.present ? data.classId.value : this.classId,
      boardId: data.boardId.present ? data.boardId.value : this.boardId,
      nameHindi: data.nameHindi.present ? data.nameHindi.value : this.nameHindi,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      accentColor: data.accentColor.present
          ? data.accentColor.value
          : this.accentColor,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('boardId: $boardId, ')
          ..write('nameHindi: $nameHindi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('accentColor: $accentColor, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    classId,
    boardId,
    nameHindi,
    nameEnglish,
    accentColor,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.classId == this.classId &&
          other.boardId == this.boardId &&
          other.nameHindi == this.nameHindi &&
          other.nameEnglish == this.nameEnglish &&
          other.accentColor == this.accentColor &&
          other.displayOrder == this.displayOrder);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> classId;
  final Value<String?> boardId;
  final Value<String> nameHindi;
  final Value<String> nameEnglish;
  final Value<String> accentColor;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.boardId = const Value.absent(),
    this.nameHindi = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String classId,
    this.boardId = const Value.absent(),
    required String nameHindi,
    required String nameEnglish,
    this.accentColor = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       classId = Value(classId),
       nameHindi = Value(nameHindi),
       nameEnglish = Value(nameEnglish);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? classId,
    Expression<String>? boardId,
    Expression<String>? nameHindi,
    Expression<String>? nameEnglish,
    Expression<String>? accentColor,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classId != null) 'class_id': classId,
      if (boardId != null) 'board_id': boardId,
      if (nameHindi != null) 'name_hindi': nameHindi,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (accentColor != null) 'accent_color': accentColor,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? classId,
    Value<String?>? boardId,
    Value<String>? nameHindi,
    Value<String>? nameEnglish,
    Value<String>? accentColor,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      boardId: boardId ?? this.boardId,
      nameHindi: nameHindi ?? this.nameHindi,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      accentColor: accentColor ?? this.accentColor,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (boardId.present) {
      map['board_id'] = Variable<String>(boardId.value);
    }
    if (nameHindi.present) {
      map['name_hindi'] = Variable<String>(nameHindi.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<String>(accentColor.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('boardId: $boardId, ')
          ..write('nameHindi: $nameHindi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('accentColor: $accentColor, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleHindiMeta = const VerificationMeta(
    'titleHindi',
  );
  @override
  late final GeneratedColumn<String> titleHindi = GeneratedColumn<String>(
    'title_hindi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    number,
    title,
    titleHindi,
    summary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_hindi')) {
      context.handle(
        _titleHindiMeta,
        titleHindi.isAcceptableOrUnknown(data['title_hindi']!, _titleHindiMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleHindi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_hindi'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String subjectId;
  final int number;
  final String title;
  final String titleHindi;
  final String summary;
  const Chapter({
    required this.id,
    required this.subjectId,
    required this.number,
    required this.title,
    required this.titleHindi,
    required this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['number'] = Variable<int>(number);
    map['title'] = Variable<String>(title);
    map['title_hindi'] = Variable<String>(titleHindi);
    map['summary'] = Variable<String>(summary);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      number: Value(number),
      title: Value(title),
      titleHindi: Value(titleHindi),
      summary: Value(summary),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      number: serializer.fromJson<int>(json['number']),
      title: serializer.fromJson<String>(json['title']),
      titleHindi: serializer.fromJson<String>(json['titleHindi']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'number': serializer.toJson<int>(number),
      'title': serializer.toJson<String>(title),
      'titleHindi': serializer.toJson<String>(titleHindi),
      'summary': serializer.toJson<String>(summary),
    };
  }

  Chapter copyWith({
    String? id,
    String? subjectId,
    int? number,
    String? title,
    String? titleHindi,
    String? summary,
  }) => Chapter(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    number: number ?? this.number,
    title: title ?? this.title,
    titleHindi: titleHindi ?? this.titleHindi,
    summary: summary ?? this.summary,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      number: data.number.present ? data.number.value : this.number,
      title: data.title.present ? data.title.value : this.title,
      titleHindi: data.titleHindi.present
          ? data.titleHindi.value
          : this.titleHindi,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('titleHindi: $titleHindi, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, subjectId, number, title, titleHindi, summary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.number == this.number &&
          other.title == this.title &&
          other.titleHindi == this.titleHindi &&
          other.summary == this.summary);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<int> number;
  final Value<String> title;
  final Value<String> titleHindi;
  final Value<String> summary;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.number = const Value.absent(),
    this.title = const Value.absent(),
    this.titleHindi = const Value.absent(),
    this.summary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String subjectId,
    required int number,
    required String title,
    this.titleHindi = const Value.absent(),
    this.summary = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       number = Value(number),
       title = Value(title);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<int>? number,
    Expression<String>? title,
    Expression<String>? titleHindi,
    Expression<String>? summary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (number != null) 'number': number,
      if (title != null) 'title': title,
      if (titleHindi != null) 'title_hindi': titleHindi,
      if (summary != null) 'summary': summary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<int>? number,
    Value<String>? title,
    Value<String>? titleHindi,
    Value<String>? summary,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      number: number ?? this.number,
      title: title ?? this.title,
      titleHindi: titleHindi ?? this.titleHindi,
      summary: summary ?? this.summary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleHindi.present) {
      map['title_hindi'] = Variable<String>(titleHindi.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('titleHindi: $titleHindi, ')
          ..write('summary: $summary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _youtubeUrlMeta = const VerificationMeta(
    'youtubeUrl',
  );
  @override
  late final GeneratedColumn<String> youtubeUrl = GeneratedColumn<String>(
    'youtube_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localVideoPathMeta = const VerificationMeta(
    'localVideoPath',
  );
  @override
  late final GeneratedColumn<String> localVideoPath = GeneratedColumn<String>(
    'local_video_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    title,
    description,
    displayOrder,
    youtubeUrl,
    localVideoPath,
    durationSeconds,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('youtube_url')) {
      context.handle(
        _youtubeUrlMeta,
        youtubeUrl.isAcceptableOrUnknown(data['youtube_url']!, _youtubeUrlMeta),
      );
    }
    if (data.containsKey('local_video_path')) {
      context.handle(
        _localVideoPathMeta,
        localVideoPath.isAcceptableOrUnknown(
          data['local_video_path']!,
          _localVideoPathMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      youtubeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}youtube_url'],
      ),
      localVideoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_video_path'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final String id;
  final String chapterId;
  final String title;
  final String description;
  final int displayOrder;
  final String? youtubeUrl;
  final String? localVideoPath;
  final int durationSeconds;
  final bool isPublished;
  const Lesson({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.displayOrder,
    this.youtubeUrl,
    this.localVideoPath,
    required this.durationSeconds,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['display_order'] = Variable<int>(displayOrder);
    if (!nullToAbsent || youtubeUrl != null) {
      map['youtube_url'] = Variable<String>(youtubeUrl);
    }
    if (!nullToAbsent || localVideoPath != null) {
      map['local_video_path'] = Variable<String>(localVideoPath);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      title: Value(title),
      description: Value(description),
      displayOrder: Value(displayOrder),
      youtubeUrl: youtubeUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(youtubeUrl),
      localVideoPath: localVideoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localVideoPath),
      durationSeconds: Value(durationSeconds),
      isPublished: Value(isPublished),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      youtubeUrl: serializer.fromJson<String?>(json['youtubeUrl']),
      localVideoPath: serializer.fromJson<String?>(json['localVideoPath']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'youtubeUrl': serializer.toJson<String?>(youtubeUrl),
      'localVideoPath': serializer.toJson<String?>(localVideoPath),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  Lesson copyWith({
    String? id,
    String? chapterId,
    String? title,
    String? description,
    int? displayOrder,
    Value<String?> youtubeUrl = const Value.absent(),
    Value<String?> localVideoPath = const Value.absent(),
    int? durationSeconds,
    bool? isPublished,
  }) => Lesson(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    title: title ?? this.title,
    description: description ?? this.description,
    displayOrder: displayOrder ?? this.displayOrder,
    youtubeUrl: youtubeUrl.present ? youtubeUrl.value : this.youtubeUrl,
    localVideoPath: localVideoPath.present
        ? localVideoPath.value
        : this.localVideoPath,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    isPublished: isPublished ?? this.isPublished,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      youtubeUrl: data.youtubeUrl.present
          ? data.youtubeUrl.value
          : this.youtubeUrl,
      localVideoPath: data.localVideoPath.present
          ? data.localVideoPath.value
          : this.localVideoPath,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('localVideoPath: $localVideoPath, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chapterId,
    title,
    description,
    displayOrder,
    youtubeUrl,
    localVideoPath,
    durationSeconds,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.title == this.title &&
          other.description == this.description &&
          other.displayOrder == this.displayOrder &&
          other.youtubeUrl == this.youtubeUrl &&
          other.localVideoPath == this.localVideoPath &&
          other.durationSeconds == this.durationSeconds &&
          other.isPublished == this.isPublished);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> title;
  final Value<String> description;
  final Value<int> displayOrder;
  final Value<String?> youtubeUrl;
  final Value<String?> localVideoPath;
  final Value<int> durationSeconds;
  final Value<bool> isPublished;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.localVideoPath = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String chapterId,
    required String title,
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.localVideoPath = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       chapterId = Value(chapterId),
       title = Value(title);
  static Insertable<Lesson> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? displayOrder,
    Expression<String>? youtubeUrl,
    Expression<String>? localVideoPath,
    Expression<int>? durationSeconds,
    Expression<bool>? isPublished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (displayOrder != null) 'display_order': displayOrder,
      if (youtubeUrl != null) 'youtube_url': youtubeUrl,
      if (localVideoPath != null) 'local_video_path': localVideoPath,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (isPublished != null) 'is_published': isPublished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String>? title,
    Value<String>? description,
    Value<int>? displayOrder,
    Value<String?>? youtubeUrl,
    Value<String?>? localVideoPath,
    Value<int>? durationSeconds,
    Value<bool>? isPublished,
    Value<int>? rowid,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      localVideoPath: localVideoPath ?? this.localVideoPath,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isPublished: isPublished ?? this.isPublished,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (youtubeUrl.present) {
      map['youtube_url'] = Variable<String>(youtubeUrl.value);
    }
    if (localVideoPath.present) {
      map['local_video_path'] = Variable<String>(localVideoPath.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('localVideoPath: $localVideoPath, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('isPublished: $isPublished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResourcesTable extends Resources
    with TableInfo<$ResourcesTable, Resource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearLabelMeta = const VerificationMeta(
    'yearLabel',
  );
  @override
  late final GeneratedColumn<int> yearLabel = GeneratedColumn<int>(
    'year_label',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteUrlMeta = const VerificationMeta(
    'remoteUrl',
  );
  @override
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
    'remote_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    chapterId,
    title,
    description,
    kind,
    yearLabel,
    localFilePath,
    remoteUrl,
    fileSizeBytes,
    isPublished,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resources';
  @override
  VerificationContext validateIntegrity(
    Insertable<Resource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('year_label')) {
      context.handle(
        _yearLabelMeta,
        yearLabel.isAcceptableOrUnknown(data['year_label']!, _yearLabelMeta),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Resource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Resource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      yearLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_label'],
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      ),
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ResourcesTable createAlias(String alias) {
    return $ResourcesTable(attachedDatabase, alias);
  }
}

class Resource extends DataClass implements Insertable<Resource> {
  final String id;
  final String subjectId;
  final String? chapterId;
  final String title;
  final String description;
  final String kind;
  final int? yearLabel;
  final String? localFilePath;
  final String? remoteUrl;
  final int fileSizeBytes;
  final bool isPublished;
  final DateTime createdAt;
  const Resource({
    required this.id,
    required this.subjectId,
    this.chapterId,
    required this.title,
    required this.description,
    required this.kind,
    this.yearLabel,
    this.localFilePath,
    this.remoteUrl,
    required this.fileSizeBytes,
    required this.isPublished,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || yearLabel != null) {
      map['year_label'] = Variable<int>(yearLabel);
    }
    if (!nullToAbsent || localFilePath != null) {
      map['local_file_path'] = Variable<String>(localFilePath);
    }
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['is_published'] = Variable<bool>(isPublished);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ResourcesCompanion toCompanion(bool nullToAbsent) {
    return ResourcesCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      title: Value(title),
      description: Value(description),
      kind: Value(kind),
      yearLabel: yearLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(yearLabel),
      localFilePath: localFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localFilePath),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      fileSizeBytes: Value(fileSizeBytes),
      isPublished: Value(isPublished),
      createdAt: Value(createdAt),
    );
  }

  factory Resource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Resource(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      kind: serializer.fromJson<String>(json['kind']),
      yearLabel: serializer.fromJson<int?>(json['yearLabel']),
      localFilePath: serializer.fromJson<String?>(json['localFilePath']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'chapterId': serializer.toJson<String?>(chapterId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'kind': serializer.toJson<String>(kind),
      'yearLabel': serializer.toJson<int?>(yearLabel),
      'localFilePath': serializer.toJson<String?>(localFilePath),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'isPublished': serializer.toJson<bool>(isPublished),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Resource copyWith({
    String? id,
    String? subjectId,
    Value<String?> chapterId = const Value.absent(),
    String? title,
    String? description,
    String? kind,
    Value<int?> yearLabel = const Value.absent(),
    Value<String?> localFilePath = const Value.absent(),
    Value<String?> remoteUrl = const Value.absent(),
    int? fileSizeBytes,
    bool? isPublished,
    DateTime? createdAt,
  }) => Resource(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    chapterId: chapterId.present ? chapterId.value : this.chapterId,
    title: title ?? this.title,
    description: description ?? this.description,
    kind: kind ?? this.kind,
    yearLabel: yearLabel.present ? yearLabel.value : this.yearLabel,
    localFilePath: localFilePath.present
        ? localFilePath.value
        : this.localFilePath,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    isPublished: isPublished ?? this.isPublished,
    createdAt: createdAt ?? this.createdAt,
  );
  Resource copyWithCompanion(ResourcesCompanion data) {
    return Resource(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      kind: data.kind.present ? data.kind.value : this.kind,
      yearLabel: data.yearLabel.present ? data.yearLabel.value : this.yearLabel,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Resource(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('yearLabel: $yearLabel, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isPublished: $isPublished, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    chapterId,
    title,
    description,
    kind,
    yearLabel,
    localFilePath,
    remoteUrl,
    fileSizeBytes,
    isPublished,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Resource &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.chapterId == this.chapterId &&
          other.title == this.title &&
          other.description == this.description &&
          other.kind == this.kind &&
          other.yearLabel == this.yearLabel &&
          other.localFilePath == this.localFilePath &&
          other.remoteUrl == this.remoteUrl &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.isPublished == this.isPublished &&
          other.createdAt == this.createdAt);
}

class ResourcesCompanion extends UpdateCompanion<Resource> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String?> chapterId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> kind;
  final Value<int?> yearLabel;
  final Value<String?> localFilePath;
  final Value<String?> remoteUrl;
  final Value<int> fileSizeBytes;
  final Value<bool> isPublished;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ResourcesCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.kind = const Value.absent(),
    this.yearLabel = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResourcesCompanion.insert({
    required String id,
    required String subjectId,
    this.chapterId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String kind,
    this.yearLabel = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       title = Value(title),
       kind = Value(kind);
  static Insertable<Resource> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? chapterId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? kind,
    Expression<int>? yearLabel,
    Expression<String>? localFilePath,
    Expression<String>? remoteUrl,
    Expression<int>? fileSizeBytes,
    Expression<bool>? isPublished,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (kind != null) 'kind': kind,
      if (yearLabel != null) 'year_label': yearLabel,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (isPublished != null) 'is_published': isPublished,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String?>? chapterId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? kind,
    Value<int?>? yearLabel,
    Value<String?>? localFilePath,
    Value<String?>? remoteUrl,
    Value<int>? fileSizeBytes,
    Value<bool>? isPublished,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ResourcesCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      description: description ?? this.description,
      kind: kind ?? this.kind,
      yearLabel: yearLabel ?? this.yearLabel,
      localFilePath: localFilePath ?? this.localFilePath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (yearLabel.present) {
      map['year_label'] = Variable<int>(yearLabel.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResourcesCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('yearLabel: $yearLabel, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('isPublished: $isPublished, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestsTable extends Tests with TableInfo<$TestsTable, Test> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeLimitMinutesMeta = const VerificationMeta(
    'timeLimitMinutes',
  );
  @override
  late final GeneratedColumn<int> timeLimitMinutes = GeneratedColumn<int>(
    'time_limit_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _marksPerQuestionMeta = const VerificationMeta(
    'marksPerQuestion',
  );
  @override
  late final GeneratedColumn<double> marksPerQuestion = GeneratedColumn<double>(
    'marks_per_question',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _negativeMarkingMeta = const VerificationMeta(
    'negativeMarking',
  );
  @override
  late final GeneratedColumn<double> negativeMarking = GeneratedColumn<double>(
    'negative_marking',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    title,
    timeLimitMinutes,
    marksPerQuestion,
    negativeMarking,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tests';
  @override
  VerificationContext validateIntegrity(
    Insertable<Test> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('time_limit_minutes')) {
      context.handle(
        _timeLimitMinutesMeta,
        timeLimitMinutes.isAcceptableOrUnknown(
          data['time_limit_minutes']!,
          _timeLimitMinutesMeta,
        ),
      );
    }
    if (data.containsKey('marks_per_question')) {
      context.handle(
        _marksPerQuestionMeta,
        marksPerQuestion.isAcceptableOrUnknown(
          data['marks_per_question']!,
          _marksPerQuestionMeta,
        ),
      );
    }
    if (data.containsKey('negative_marking')) {
      context.handle(
        _negativeMarkingMeta,
        negativeMarking.isAcceptableOrUnknown(
          data['negative_marking']!,
          _negativeMarkingMeta,
        ),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Test map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Test(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      timeLimitMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_limit_minutes'],
      )!,
      marksPerQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}marks_per_question'],
      )!,
      negativeMarking: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}negative_marking'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $TestsTable createAlias(String alias) {
    return $TestsTable(attachedDatabase, alias);
  }
}

class Test extends DataClass implements Insertable<Test> {
  final String id;
  final String chapterId;
  final String title;
  final int timeLimitMinutes;
  final double marksPerQuestion;
  final double negativeMarking;
  final bool isPublished;
  const Test({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.timeLimitMinutes,
    required this.marksPerQuestion,
    required this.negativeMarking,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['title'] = Variable<String>(title);
    map['time_limit_minutes'] = Variable<int>(timeLimitMinutes);
    map['marks_per_question'] = Variable<double>(marksPerQuestion);
    map['negative_marking'] = Variable<double>(negativeMarking);
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  TestsCompanion toCompanion(bool nullToAbsent) {
    return TestsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      title: Value(title),
      timeLimitMinutes: Value(timeLimitMinutes),
      marksPerQuestion: Value(marksPerQuestion),
      negativeMarking: Value(negativeMarking),
      isPublished: Value(isPublished),
    );
  }

  factory Test.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Test(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      title: serializer.fromJson<String>(json['title']),
      timeLimitMinutes: serializer.fromJson<int>(json['timeLimitMinutes']),
      marksPerQuestion: serializer.fromJson<double>(json['marksPerQuestion']),
      negativeMarking: serializer.fromJson<double>(json['negativeMarking']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'title': serializer.toJson<String>(title),
      'timeLimitMinutes': serializer.toJson<int>(timeLimitMinutes),
      'marksPerQuestion': serializer.toJson<double>(marksPerQuestion),
      'negativeMarking': serializer.toJson<double>(negativeMarking),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  Test copyWith({
    String? id,
    String? chapterId,
    String? title,
    int? timeLimitMinutes,
    double? marksPerQuestion,
    double? negativeMarking,
    bool? isPublished,
  }) => Test(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    title: title ?? this.title,
    timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
    marksPerQuestion: marksPerQuestion ?? this.marksPerQuestion,
    negativeMarking: negativeMarking ?? this.negativeMarking,
    isPublished: isPublished ?? this.isPublished,
  );
  Test copyWithCompanion(TestsCompanion data) {
    return Test(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      title: data.title.present ? data.title.value : this.title,
      timeLimitMinutes: data.timeLimitMinutes.present
          ? data.timeLimitMinutes.value
          : this.timeLimitMinutes,
      marksPerQuestion: data.marksPerQuestion.present
          ? data.marksPerQuestion.value
          : this.marksPerQuestion,
      negativeMarking: data.negativeMarking.present
          ? data.negativeMarking.value
          : this.negativeMarking,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Test(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('timeLimitMinutes: $timeLimitMinutes, ')
          ..write('marksPerQuestion: $marksPerQuestion, ')
          ..write('negativeMarking: $negativeMarking, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chapterId,
    title,
    timeLimitMinutes,
    marksPerQuestion,
    negativeMarking,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Test &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.title == this.title &&
          other.timeLimitMinutes == this.timeLimitMinutes &&
          other.marksPerQuestion == this.marksPerQuestion &&
          other.negativeMarking == this.negativeMarking &&
          other.isPublished == this.isPublished);
}

class TestsCompanion extends UpdateCompanion<Test> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> title;
  final Value<int> timeLimitMinutes;
  final Value<double> marksPerQuestion;
  final Value<double> negativeMarking;
  final Value<bool> isPublished;
  final Value<int> rowid;
  const TestsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.title = const Value.absent(),
    this.timeLimitMinutes = const Value.absent(),
    this.marksPerQuestion = const Value.absent(),
    this.negativeMarking = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestsCompanion.insert({
    required String id,
    required String chapterId,
    required String title,
    this.timeLimitMinutes = const Value.absent(),
    this.marksPerQuestion = const Value.absent(),
    this.negativeMarking = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       chapterId = Value(chapterId),
       title = Value(title);
  static Insertable<Test> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? title,
    Expression<int>? timeLimitMinutes,
    Expression<double>? marksPerQuestion,
    Expression<double>? negativeMarking,
    Expression<bool>? isPublished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (title != null) 'title': title,
      if (timeLimitMinutes != null) 'time_limit_minutes': timeLimitMinutes,
      if (marksPerQuestion != null) 'marks_per_question': marksPerQuestion,
      if (negativeMarking != null) 'negative_marking': negativeMarking,
      if (isPublished != null) 'is_published': isPublished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestsCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String>? title,
    Value<int>? timeLimitMinutes,
    Value<double>? marksPerQuestion,
    Value<double>? negativeMarking,
    Value<bool>? isPublished,
    Value<int>? rowid,
  }) {
    return TestsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      marksPerQuestion: marksPerQuestion ?? this.marksPerQuestion,
      negativeMarking: negativeMarking ?? this.negativeMarking,
      isPublished: isPublished ?? this.isPublished,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (timeLimitMinutes.present) {
      map['time_limit_minutes'] = Variable<int>(timeLimitMinutes.value);
    }
    if (marksPerQuestion.present) {
      map['marks_per_question'] = Variable<double>(marksPerQuestion.value);
    }
    if (negativeMarking.present) {
      map['negative_marking'] = Variable<double>(negativeMarking.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('timeLimitMinutes: $timeLimitMinutes, ')
          ..write('marksPerQuestion: $marksPerQuestion, ')
          ..write('negativeMarking: $negativeMarking, ')
          ..write('isPublished: $isPublished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestQuestionsTable extends TestQuestions
    with TableInfo<$TestQuestionsTable, TestQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<String> testId = GeneratedColumn<String>(
    'test_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tests (id)',
    ),
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionAMeta = const VerificationMeta(
    'optionA',
  );
  @override
  late final GeneratedColumn<String> optionA = GeneratedColumn<String>(
    'option_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionBMeta = const VerificationMeta(
    'optionB',
  );
  @override
  late final GeneratedColumn<String> optionB = GeneratedColumn<String>(
    'option_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionCMeta = const VerificationMeta(
    'optionC',
  );
  @override
  late final GeneratedColumn<String> optionC = GeneratedColumn<String>(
    'option_c',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionDMeta = const VerificationMeta(
    'optionD',
  );
  @override
  late final GeneratedColumn<String> optionD = GeneratedColumn<String>(
    'option_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctOptionMeta = const VerificationMeta(
    'correctOption',
  );
  @override
  late final GeneratedColumn<String> correctOption = GeneratedColumn<String>(
    'correct_option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _marksMeta = const VerificationMeta('marks');
  @override
  late final GeneratedColumn<double> marks = GeneratedColumn<double>(
    'marks',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    testId,
    prompt,
    optionA,
    optionB,
    optionC,
    optionD,
    correctOption,
    explanation,
    marks,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('test_id')) {
      context.handle(
        _testIdMeta,
        testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta),
      );
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('option_a')) {
      context.handle(
        _optionAMeta,
        optionA.isAcceptableOrUnknown(data['option_a']!, _optionAMeta),
      );
    } else if (isInserting) {
      context.missing(_optionAMeta);
    }
    if (data.containsKey('option_b')) {
      context.handle(
        _optionBMeta,
        optionB.isAcceptableOrUnknown(data['option_b']!, _optionBMeta),
      );
    } else if (isInserting) {
      context.missing(_optionBMeta);
    }
    if (data.containsKey('option_c')) {
      context.handle(
        _optionCMeta,
        optionC.isAcceptableOrUnknown(data['option_c']!, _optionCMeta),
      );
    } else if (isInserting) {
      context.missing(_optionCMeta);
    }
    if (data.containsKey('option_d')) {
      context.handle(
        _optionDMeta,
        optionD.isAcceptableOrUnknown(data['option_d']!, _optionDMeta),
      );
    } else if (isInserting) {
      context.missing(_optionDMeta);
    }
    if (data.containsKey('correct_option')) {
      context.handle(
        _correctOptionMeta,
        correctOption.isAcceptableOrUnknown(
          data['correct_option']!,
          _correctOptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctOptionMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('marks')) {
      context.handle(
        _marksMeta,
        marks.isAcceptableOrUnknown(data['marks']!, _marksMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      testId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_id'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      optionA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_a'],
      )!,
      optionB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_b'],
      )!,
      optionC: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_c'],
      )!,
      optionD: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_d'],
      )!,
      correctOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_option'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      marks: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}marks'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $TestQuestionsTable createAlias(String alias) {
    return $TestQuestionsTable(attachedDatabase, alias);
  }
}

class TestQuestion extends DataClass implements Insertable<TestQuestion> {
  final String id;
  final String testId;
  final String prompt;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String explanation;
  final double marks;
  final int displayOrder;
  const TestQuestion({
    required this.id,
    required this.testId,
    required this.prompt,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.explanation,
    required this.marks,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['test_id'] = Variable<String>(testId);
    map['prompt'] = Variable<String>(prompt);
    map['option_a'] = Variable<String>(optionA);
    map['option_b'] = Variable<String>(optionB);
    map['option_c'] = Variable<String>(optionC);
    map['option_d'] = Variable<String>(optionD);
    map['correct_option'] = Variable<String>(correctOption);
    map['explanation'] = Variable<String>(explanation);
    map['marks'] = Variable<double>(marks);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  TestQuestionsCompanion toCompanion(bool nullToAbsent) {
    return TestQuestionsCompanion(
      id: Value(id),
      testId: Value(testId),
      prompt: Value(prompt),
      optionA: Value(optionA),
      optionB: Value(optionB),
      optionC: Value(optionC),
      optionD: Value(optionD),
      correctOption: Value(correctOption),
      explanation: Value(explanation),
      marks: Value(marks),
      displayOrder: Value(displayOrder),
    );
  }

  factory TestQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestQuestion(
      id: serializer.fromJson<String>(json['id']),
      testId: serializer.fromJson<String>(json['testId']),
      prompt: serializer.fromJson<String>(json['prompt']),
      optionA: serializer.fromJson<String>(json['optionA']),
      optionB: serializer.fromJson<String>(json['optionB']),
      optionC: serializer.fromJson<String>(json['optionC']),
      optionD: serializer.fromJson<String>(json['optionD']),
      correctOption: serializer.fromJson<String>(json['correctOption']),
      explanation: serializer.fromJson<String>(json['explanation']),
      marks: serializer.fromJson<double>(json['marks']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'testId': serializer.toJson<String>(testId),
      'prompt': serializer.toJson<String>(prompt),
      'optionA': serializer.toJson<String>(optionA),
      'optionB': serializer.toJson<String>(optionB),
      'optionC': serializer.toJson<String>(optionC),
      'optionD': serializer.toJson<String>(optionD),
      'correctOption': serializer.toJson<String>(correctOption),
      'explanation': serializer.toJson<String>(explanation),
      'marks': serializer.toJson<double>(marks),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  TestQuestion copyWith({
    String? id,
    String? testId,
    String? prompt,
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    String? correctOption,
    String? explanation,
    double? marks,
    int? displayOrder,
  }) => TestQuestion(
    id: id ?? this.id,
    testId: testId ?? this.testId,
    prompt: prompt ?? this.prompt,
    optionA: optionA ?? this.optionA,
    optionB: optionB ?? this.optionB,
    optionC: optionC ?? this.optionC,
    optionD: optionD ?? this.optionD,
    correctOption: correctOption ?? this.correctOption,
    explanation: explanation ?? this.explanation,
    marks: marks ?? this.marks,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  TestQuestion copyWithCompanion(TestQuestionsCompanion data) {
    return TestQuestion(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      optionA: data.optionA.present ? data.optionA.value : this.optionA,
      optionB: data.optionB.present ? data.optionB.value : this.optionB,
      optionC: data.optionC.present ? data.optionC.value : this.optionC,
      optionD: data.optionD.present ? data.optionD.value : this.optionD,
      correctOption: data.correctOption.present
          ? data.correctOption.value
          : this.correctOption,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      marks: data.marks.present ? data.marks.value : this.marks,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestQuestion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('prompt: $prompt, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctOption: $correctOption, ')
          ..write('explanation: $explanation, ')
          ..write('marks: $marks, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    testId,
    prompt,
    optionA,
    optionB,
    optionC,
    optionD,
    correctOption,
    explanation,
    marks,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestQuestion &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.prompt == this.prompt &&
          other.optionA == this.optionA &&
          other.optionB == this.optionB &&
          other.optionC == this.optionC &&
          other.optionD == this.optionD &&
          other.correctOption == this.correctOption &&
          other.explanation == this.explanation &&
          other.marks == this.marks &&
          other.displayOrder == this.displayOrder);
}

class TestQuestionsCompanion extends UpdateCompanion<TestQuestion> {
  final Value<String> id;
  final Value<String> testId;
  final Value<String> prompt;
  final Value<String> optionA;
  final Value<String> optionB;
  final Value<String> optionC;
  final Value<String> optionD;
  final Value<String> correctOption;
  final Value<String> explanation;
  final Value<double> marks;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const TestQuestionsCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.prompt = const Value.absent(),
    this.optionA = const Value.absent(),
    this.optionB = const Value.absent(),
    this.optionC = const Value.absent(),
    this.optionD = const Value.absent(),
    this.correctOption = const Value.absent(),
    this.explanation = const Value.absent(),
    this.marks = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestQuestionsCompanion.insert({
    required String id,
    required String testId,
    required String prompt,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String correctOption,
    this.explanation = const Value.absent(),
    this.marks = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       testId = Value(testId),
       prompt = Value(prompt),
       optionA = Value(optionA),
       optionB = Value(optionB),
       optionC = Value(optionC),
       optionD = Value(optionD),
       correctOption = Value(correctOption);
  static Insertable<TestQuestion> custom({
    Expression<String>? id,
    Expression<String>? testId,
    Expression<String>? prompt,
    Expression<String>? optionA,
    Expression<String>? optionB,
    Expression<String>? optionC,
    Expression<String>? optionD,
    Expression<String>? correctOption,
    Expression<String>? explanation,
    Expression<double>? marks,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (prompt != null) 'prompt': prompt,
      if (optionA != null) 'option_a': optionA,
      if (optionB != null) 'option_b': optionB,
      if (optionC != null) 'option_c': optionC,
      if (optionD != null) 'option_d': optionD,
      if (correctOption != null) 'correct_option': correctOption,
      if (explanation != null) 'explanation': explanation,
      if (marks != null) 'marks': marks,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? testId,
    Value<String>? prompt,
    Value<String>? optionA,
    Value<String>? optionB,
    Value<String>? optionC,
    Value<String>? optionD,
    Value<String>? correctOption,
    Value<String>? explanation,
    Value<double>? marks,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return TestQuestionsCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      prompt: prompt ?? this.prompt,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctOption: correctOption ?? this.correctOption,
      explanation: explanation ?? this.explanation,
      marks: marks ?? this.marks,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<String>(testId.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (optionA.present) {
      map['option_a'] = Variable<String>(optionA.value);
    }
    if (optionB.present) {
      map['option_b'] = Variable<String>(optionB.value);
    }
    if (optionC.present) {
      map['option_c'] = Variable<String>(optionC.value);
    }
    if (optionD.present) {
      map['option_d'] = Variable<String>(optionD.value);
    }
    if (correctOption.present) {
      map['correct_option'] = Variable<String>(correctOption.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (marks.present) {
      map['marks'] = Variable<double>(marks.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('prompt: $prompt, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctOption: $correctOption, ')
          ..write('explanation: $explanation, ')
          ..write('marks: $marks, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES school_classes (id)',
    ),
  );
  static const VerificationMeta _avatarEmojiMeta = const VerificationMeta(
    'avatarEmoji',
  );
  @override
  late final GeneratedColumn<String> avatarEmoji = GeneratedColumn<String>(
    'avatar_emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🎓'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    classId,
    avatarEmoji,
    themeMode,
    createdAt,
    lastSeenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    }
    if (data.containsKey('avatar_emoji')) {
      context.handle(
        _avatarEmojiMeta,
        avatarEmoji.isAcceptableOrUnknown(
          data['avatar_emoji']!,
          _avatarEmojiMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      ),
      avatarEmoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_emoji'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String displayName;
  final String? classId;
  final String avatarEmoji;
  final String themeMode;
  final DateTime createdAt;
  final DateTime lastSeenAt;
  const Student({
    required this.id,
    required this.displayName,
    this.classId,
    required this.avatarEmoji,
    required this.themeMode,
    required this.createdAt,
    required this.lastSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || classId != null) {
      map['class_id'] = Variable<String>(classId);
    }
    map['avatar_emoji'] = Variable<String>(avatarEmoji);
    map['theme_mode'] = Variable<String>(themeMode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      displayName: Value(displayName),
      classId: classId == null && nullToAbsent
          ? const Value.absent()
          : Value(classId),
      avatarEmoji: Value(avatarEmoji),
      themeMode: Value(themeMode),
      createdAt: Value(createdAt),
      lastSeenAt: Value(lastSeenAt),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      classId: serializer.fromJson<String?>(json['classId']),
      avatarEmoji: serializer.fromJson<String>(json['avatarEmoji']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'classId': serializer.toJson<String?>(classId),
      'avatarEmoji': serializer.toJson<String>(avatarEmoji),
      'themeMode': serializer.toJson<String>(themeMode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
    };
  }

  Student copyWith({
    String? id,
    String? displayName,
    Value<String?> classId = const Value.absent(),
    String? avatarEmoji,
    String? themeMode,
    DateTime? createdAt,
    DateTime? lastSeenAt,
  }) => Student(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    classId: classId.present ? classId.value : this.classId,
    avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    themeMode: themeMode ?? this.themeMode,
    createdAt: createdAt ?? this.createdAt,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      classId: data.classId.present ? data.classId.value : this.classId,
      avatarEmoji: data.avatarEmoji.present
          ? data.avatarEmoji.value
          : this.avatarEmoji,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('classId: $classId, ')
          ..write('avatarEmoji: $avatarEmoji, ')
          ..write('themeMode: $themeMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSeenAt: $lastSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    classId,
    avatarEmoji,
    themeMode,
    createdAt,
    lastSeenAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.classId == this.classId &&
          other.avatarEmoji == this.avatarEmoji &&
          other.themeMode == this.themeMode &&
          other.createdAt == this.createdAt &&
          other.lastSeenAt == this.lastSeenAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String?> classId;
  final Value<String> avatarEmoji;
  final Value<String> themeMode;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastSeenAt;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.classId = const Value.absent(),
    this.avatarEmoji = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String displayName,
    this.classId = const Value.absent(),
    this.avatarEmoji = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? classId,
    Expression<String>? avatarEmoji,
    Expression<String>? themeMode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSeenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (classId != null) 'class_id': classId,
      if (avatarEmoji != null) 'avatar_emoji': avatarEmoji,
      if (themeMode != null) 'theme_mode': themeMode,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String?>? classId,
    Value<String>? avatarEmoji,
    Value<String>? themeMode,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastSeenAt,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      classId: classId ?? this.classId,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (avatarEmoji.present) {
      map['avatar_emoji'] = Variable<String>(avatarEmoji.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('classId: $classId, ')
          ..write('avatarEmoji: $avatarEmoji, ')
          ..write('themeMode: $themeMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _targetKindMeta = const VerificationMeta(
    'targetKind',
  );
  @override
  late final GeneratedColumn<String> targetKind = GeneratedColumn<String>(
    'target_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    studentId,
    targetKind,
    targetId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('target_kind')) {
      context.handle(
        _targetKindMeta,
        targetKind.isAcceptableOrUnknown(data['target_kind']!, _targetKindMeta),
      );
    } else if (isInserting) {
      context.missing(_targetKindMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId, targetKind, targetId};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      targetKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_kind'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final String studentId;
  final String targetKind;
  final String targetId;
  final DateTime createdAt;
  const Bookmark({
    required this.studentId,
    required this.targetKind,
    required this.targetId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['target_kind'] = Variable<String>(targetKind);
    map['target_id'] = Variable<String>(targetId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      studentId: Value(studentId),
      targetKind: Value(targetKind),
      targetId: Value(targetId),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      studentId: serializer.fromJson<String>(json['studentId']),
      targetKind: serializer.fromJson<String>(json['targetKind']),
      targetId: serializer.fromJson<String>(json['targetId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'targetKind': serializer.toJson<String>(targetKind),
      'targetId': serializer.toJson<String>(targetId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith({
    String? studentId,
    String? targetKind,
    String? targetId,
    DateTime? createdAt,
  }) => Bookmark(
    studentId: studentId ?? this.studentId,
    targetKind: targetKind ?? this.targetKind,
    targetId: targetId ?? this.targetId,
    createdAt: createdAt ?? this.createdAt,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      targetKind: data.targetKind.present
          ? data.targetKind.value
          : this.targetKind,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('studentId: $studentId, ')
          ..write('targetKind: $targetKind, ')
          ..write('targetId: $targetId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(studentId, targetKind, targetId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.studentId == this.studentId &&
          other.targetKind == this.targetKind &&
          other.targetId == this.targetId &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<String> studentId;
  final Value<String> targetKind;
  final Value<String> targetId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.studentId = const Value.absent(),
    this.targetKind = const Value.absent(),
    this.targetId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String studentId,
    required String targetKind,
    required String targetId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       targetKind = Value(targetKind),
       targetId = Value(targetId);
  static Insertable<Bookmark> custom({
    Expression<String>? studentId,
    Expression<String>? targetKind,
    Expression<String>? targetId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (targetKind != null) 'target_kind': targetKind,
      if (targetId != null) 'target_id': targetId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    Value<String>? studentId,
    Value<String>? targetKind,
    Value<String>? targetId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BookmarksCompanion(
      studentId: studentId ?? this.studentId,
      targetKind: targetKind ?? this.targetKind,
      targetId: targetId ?? this.targetId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (targetKind.present) {
      map['target_kind'] = Variable<String>(targetKind.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('studentId: $studentId, ')
          ..write('targetKind: $targetKind, ')
          ..write('targetId: $targetId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentViewsTable extends RecentViews
    with TableInfo<$RecentViewsTable, RecentView> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentViewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _targetKindMeta = const VerificationMeta(
    'targetKind',
  );
  @override
  late final GeneratedColumn<String> targetKind = GeneratedColumn<String>(
    'target_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewedAtMeta = const VerificationMeta(
    'viewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> viewedAt = GeneratedColumn<DateTime>(
    'viewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    studentId,
    targetKind,
    targetId,
    viewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_views';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentView> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('target_kind')) {
      context.handle(
        _targetKindMeta,
        targetKind.isAcceptableOrUnknown(data['target_kind']!, _targetKindMeta),
      );
    } else if (isInserting) {
      context.missing(_targetKindMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('viewed_at')) {
      context.handle(
        _viewedAtMeta,
        viewedAt.isAcceptableOrUnknown(data['viewed_at']!, _viewedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId, targetKind, targetId};
  @override
  RecentView map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentView(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      targetKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_kind'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      viewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}viewed_at'],
      )!,
    );
  }

  @override
  $RecentViewsTable createAlias(String alias) {
    return $RecentViewsTable(attachedDatabase, alias);
  }
}

class RecentView extends DataClass implements Insertable<RecentView> {
  final String studentId;
  final String targetKind;
  final String targetId;
  final DateTime viewedAt;
  const RecentView({
    required this.studentId,
    required this.targetKind,
    required this.targetId,
    required this.viewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['target_kind'] = Variable<String>(targetKind);
    map['target_id'] = Variable<String>(targetId);
    map['viewed_at'] = Variable<DateTime>(viewedAt);
    return map;
  }

  RecentViewsCompanion toCompanion(bool nullToAbsent) {
    return RecentViewsCompanion(
      studentId: Value(studentId),
      targetKind: Value(targetKind),
      targetId: Value(targetId),
      viewedAt: Value(viewedAt),
    );
  }

  factory RecentView.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentView(
      studentId: serializer.fromJson<String>(json['studentId']),
      targetKind: serializer.fromJson<String>(json['targetKind']),
      targetId: serializer.fromJson<String>(json['targetId']),
      viewedAt: serializer.fromJson<DateTime>(json['viewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'targetKind': serializer.toJson<String>(targetKind),
      'targetId': serializer.toJson<String>(targetId),
      'viewedAt': serializer.toJson<DateTime>(viewedAt),
    };
  }

  RecentView copyWith({
    String? studentId,
    String? targetKind,
    String? targetId,
    DateTime? viewedAt,
  }) => RecentView(
    studentId: studentId ?? this.studentId,
    targetKind: targetKind ?? this.targetKind,
    targetId: targetId ?? this.targetId,
    viewedAt: viewedAt ?? this.viewedAt,
  );
  RecentView copyWithCompanion(RecentViewsCompanion data) {
    return RecentView(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      targetKind: data.targetKind.present
          ? data.targetKind.value
          : this.targetKind,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      viewedAt: data.viewedAt.present ? data.viewedAt.value : this.viewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentView(')
          ..write('studentId: $studentId, ')
          ..write('targetKind: $targetKind, ')
          ..write('targetId: $targetId, ')
          ..write('viewedAt: $viewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(studentId, targetKind, targetId, viewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentView &&
          other.studentId == this.studentId &&
          other.targetKind == this.targetKind &&
          other.targetId == this.targetId &&
          other.viewedAt == this.viewedAt);
}

class RecentViewsCompanion extends UpdateCompanion<RecentView> {
  final Value<String> studentId;
  final Value<String> targetKind;
  final Value<String> targetId;
  final Value<DateTime> viewedAt;
  final Value<int> rowid;
  const RecentViewsCompanion({
    this.studentId = const Value.absent(),
    this.targetKind = const Value.absent(),
    this.targetId = const Value.absent(),
    this.viewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentViewsCompanion.insert({
    required String studentId,
    required String targetKind,
    required String targetId,
    this.viewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       targetKind = Value(targetKind),
       targetId = Value(targetId);
  static Insertable<RecentView> custom({
    Expression<String>? studentId,
    Expression<String>? targetKind,
    Expression<String>? targetId,
    Expression<DateTime>? viewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (targetKind != null) 'target_kind': targetKind,
      if (targetId != null) 'target_id': targetId,
      if (viewedAt != null) 'viewed_at': viewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentViewsCompanion copyWith({
    Value<String>? studentId,
    Value<String>? targetKind,
    Value<String>? targetId,
    Value<DateTime>? viewedAt,
    Value<int>? rowid,
  }) {
    return RecentViewsCompanion(
      studentId: studentId ?? this.studentId,
      targetKind: targetKind ?? this.targetKind,
      targetId: targetId ?? this.targetId,
      viewedAt: viewedAt ?? this.viewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (targetKind.present) {
      map['target_kind'] = Variable<String>(targetKind.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (viewedAt.present) {
      map['viewed_at'] = Variable<DateTime>(viewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentViewsCompanion(')
          ..write('studentId: $studentId, ')
          ..write('targetKind: $targetKind, ')
          ..write('targetId: $targetId, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTable extends LessonProgress
    with TableInfo<$LessonProgressTable, LessonProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id)',
    ),
  );
  static const VerificationMeta _percentMeta = const VerificationMeta(
    'percent',
  );
  @override
  late final GeneratedColumn<double> percent = GeneratedColumn<double>(
    'percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    studentId,
    lessonId,
    percent,
    completed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('percent')) {
      context.handle(
        _percentMeta,
        percent.isAcceptableOrUnknown(data['percent']!, _percentMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId, lessonId};
  @override
  LessonProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressRow(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      percent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percent'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LessonProgressTable createAlias(String alias) {
    return $LessonProgressTable(attachedDatabase, alias);
  }
}

class LessonProgressRow extends DataClass
    implements Insertable<LessonProgressRow> {
  final String studentId;
  final String lessonId;
  final double percent;
  final bool completed;
  final DateTime updatedAt;
  const LessonProgressRow({
    required this.studentId,
    required this.lessonId,
    required this.percent,
    required this.completed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['percent'] = Variable<double>(percent);
    map['completed'] = Variable<bool>(completed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCompanion(
      studentId: Value(studentId),
      lessonId: Value(lessonId),
      percent: Value(percent),
      completed: Value(completed),
      updatedAt: Value(updatedAt),
    );
  }

  factory LessonProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressRow(
      studentId: serializer.fromJson<String>(json['studentId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      percent: serializer.fromJson<double>(json['percent']),
      completed: serializer.fromJson<bool>(json['completed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'lessonId': serializer.toJson<String>(lessonId),
      'percent': serializer.toJson<double>(percent),
      'completed': serializer.toJson<bool>(completed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LessonProgressRow copyWith({
    String? studentId,
    String? lessonId,
    double? percent,
    bool? completed,
    DateTime? updatedAt,
  }) => LessonProgressRow(
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
    percent: percent ?? this.percent,
    completed: completed ?? this.completed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LessonProgressRow copyWithCompanion(LessonProgressCompanion data) {
    return LessonProgressRow(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      percent: data.percent.present ? data.percent.value : this.percent,
      completed: data.completed.present ? data.completed.value : this.completed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressRow(')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('percent: $percent, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(studentId, lessonId, percent, completed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressRow &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId &&
          other.percent == this.percent &&
          other.completed == this.completed &&
          other.updatedAt == this.updatedAt);
}

class LessonProgressCompanion extends UpdateCompanion<LessonProgressRow> {
  final Value<String> studentId;
  final Value<String> lessonId;
  final Value<double> percent;
  final Value<bool> completed;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LessonProgressCompanion({
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.percent = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressCompanion.insert({
    required String studentId,
    required String lessonId,
    this.percent = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       lessonId = Value(lessonId);
  static Insertable<LessonProgressRow> custom({
    Expression<String>? studentId,
    Expression<String>? lessonId,
    Expression<double>? percent,
    Expression<bool>? completed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (percent != null) 'percent': percent,
      if (completed != null) 'completed': completed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressCompanion copyWith({
    Value<String>? studentId,
    Value<String>? lessonId,
    Value<double>? percent,
    Value<bool>? completed,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LessonProgressCompanion(
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      percent: percent ?? this.percent,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (percent.present) {
      map['percent'] = Variable<double>(percent.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCompanion(')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('percent: $percent, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadsTable extends Downloads
    with TableInfo<$DownloadsTable, Download> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _resourceIdMeta = const VerificationMeta(
    'resourceId',
  );
  @override
  late final GeneratedColumn<String> resourceId = GeneratedColumn<String>(
    'resource_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES resources (id)',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalBytesMeta = const VerificationMeta(
    'totalBytes',
  );
  @override
  late final GeneratedColumn<int> totalBytes = GeneratedColumn<int>(
    'total_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downloadedBytesMeta = const VerificationMeta(
    'downloadedBytes',
  );
  @override
  late final GeneratedColumn<int> downloadedBytes = GeneratedColumn<int>(
    'downloaded_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    resourceId,
    localPath,
    totalBytes,
    downloadedBytes,
    status,
    lastError,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Download> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('resource_id')) {
      context.handle(
        _resourceIdMeta,
        resourceId.isAcceptableOrUnknown(data['resource_id']!, _resourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_resourceIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('total_bytes')) {
      context.handle(
        _totalBytesMeta,
        totalBytes.isAcceptableOrUnknown(data['total_bytes']!, _totalBytesMeta),
      );
    }
    if (data.containsKey('downloaded_bytes')) {
      context.handle(
        _downloadedBytesMeta,
        downloadedBytes.isAcceptableOrUnknown(
          data['downloaded_bytes']!,
          _downloadedBytesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Download map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Download(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      resourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resource_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      totalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_bytes'],
      )!,
      downloadedBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_bytes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DownloadsTable createAlias(String alias) {
    return $DownloadsTable(attachedDatabase, alias);
  }
}

class Download extends DataClass implements Insertable<Download> {
  final String id;
  final String studentId;
  final String resourceId;
  final String? localPath;
  final int totalBytes;
  final int downloadedBytes;
  final String status;
  final String? lastError;
  final DateTime updatedAt;
  const Download({
    required this.id,
    required this.studentId,
    required this.resourceId,
    this.localPath,
    required this.totalBytes,
    required this.downloadedBytes,
    required this.status,
    this.lastError,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['resource_id'] = Variable<String>(resourceId);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['total_bytes'] = Variable<int>(totalBytes);
    map['downloaded_bytes'] = Variable<int>(downloadedBytes);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadsCompanion toCompanion(bool nullToAbsent) {
    return DownloadsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      resourceId: Value(resourceId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      totalBytes: Value(totalBytes),
      downloadedBytes: Value(downloadedBytes),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      updatedAt: Value(updatedAt),
    );
  }

  factory Download.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Download(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      resourceId: serializer.fromJson<String>(json['resourceId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      totalBytes: serializer.fromJson<int>(json['totalBytes']),
      downloadedBytes: serializer.fromJson<int>(json['downloadedBytes']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'resourceId': serializer.toJson<String>(resourceId),
      'localPath': serializer.toJson<String?>(localPath),
      'totalBytes': serializer.toJson<int>(totalBytes),
      'downloadedBytes': serializer.toJson<int>(downloadedBytes),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Download copyWith({
    String? id,
    String? studentId,
    String? resourceId,
    Value<String?> localPath = const Value.absent(),
    int? totalBytes,
    int? downloadedBytes,
    String? status,
    Value<String?> lastError = const Value.absent(),
    DateTime? updatedAt,
  }) => Download(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    resourceId: resourceId ?? this.resourceId,
    localPath: localPath.present ? localPath.value : this.localPath,
    totalBytes: totalBytes ?? this.totalBytes,
    downloadedBytes: downloadedBytes ?? this.downloadedBytes,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Download copyWithCompanion(DownloadsCompanion data) {
    return Download(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      resourceId: data.resourceId.present
          ? data.resourceId.value
          : this.resourceId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      totalBytes: data.totalBytes.present
          ? data.totalBytes.value
          : this.totalBytes,
      downloadedBytes: data.downloadedBytes.present
          ? data.downloadedBytes.value
          : this.downloadedBytes,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Download(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('resourceId: $resourceId, ')
          ..write('localPath: $localPath, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('downloadedBytes: $downloadedBytes, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    resourceId,
    localPath,
    totalBytes,
    downloadedBytes,
    status,
    lastError,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Download &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.resourceId == this.resourceId &&
          other.localPath == this.localPath &&
          other.totalBytes == this.totalBytes &&
          other.downloadedBytes == this.downloadedBytes &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.updatedAt == this.updatedAt);
}

class DownloadsCompanion extends UpdateCompanion<Download> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> resourceId;
  final Value<String?> localPath;
  final Value<int> totalBytes;
  final Value<int> downloadedBytes;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DownloadsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.resourceId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.downloadedBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadsCompanion.insert({
    required String id,
    required String studentId,
    required String resourceId,
    this.localPath = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.downloadedBytes = const Value.absent(),
    required String status,
    this.lastError = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       resourceId = Value(resourceId),
       status = Value(status);
  static Insertable<Download> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? resourceId,
    Expression<String>? localPath,
    Expression<int>? totalBytes,
    Expression<int>? downloadedBytes,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (resourceId != null) 'resource_id': resourceId,
      if (localPath != null) 'local_path': localPath,
      if (totalBytes != null) 'total_bytes': totalBytes,
      if (downloadedBytes != null) 'downloaded_bytes': downloadedBytes,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? resourceId,
    Value<String?>? localPath,
    Value<int>? totalBytes,
    Value<int>? downloadedBytes,
    Value<String>? status,
    Value<String?>? lastError,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DownloadsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      resourceId: resourceId ?? this.resourceId,
      localPath: localPath ?? this.localPath,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (resourceId.present) {
      map['resource_id'] = Variable<String>(resourceId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (totalBytes.present) {
      map['total_bytes'] = Variable<int>(totalBytes.value);
    }
    if (downloadedBytes.present) {
      map['downloaded_bytes'] = Variable<int>(downloadedBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('resourceId: $resourceId, ')
          ..write('localPath: $localPath, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('downloadedBytes: $downloadedBytes, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LiveClassesTable extends LiveClasses
    with TableInfo<$LiveClassesTable, LiveClass> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiveClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledStartMeta = const VerificationMeta(
    'scheduledStart',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledStart =
      GeneratedColumn<DateTime>(
        'scheduled_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _actualStartMeta = const VerificationMeta(
    'actualStart',
  );
  @override
  late final GeneratedColumn<DateTime> actualStart = GeneratedColumn<DateTime>(
    'actual_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualEndMeta = const VerificationMeta(
    'actualEnd',
  );
  @override
  late final GeneratedColumn<DateTime> actualEnd = GeneratedColumn<DateTime>(
    'actual_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _youtubeUrlMeta = const VerificationMeta(
    'youtubeUrl',
  );
  @override
  late final GeneratedColumn<String> youtubeUrl = GeneratedColumn<String>(
    'youtube_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    title,
    description,
    status,
    scheduledStart,
    actualStart,
    actualEnd,
    youtubeUrl,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'live_classes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LiveClass> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
        _scheduledStartMeta,
        scheduledStart.isAcceptableOrUnknown(
          data['scheduled_start']!,
          _scheduledStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledStartMeta);
    }
    if (data.containsKey('actual_start')) {
      context.handle(
        _actualStartMeta,
        actualStart.isAcceptableOrUnknown(
          data['actual_start']!,
          _actualStartMeta,
        ),
      );
    }
    if (data.containsKey('actual_end')) {
      context.handle(
        _actualEndMeta,
        actualEnd.isAcceptableOrUnknown(data['actual_end']!, _actualEndMeta),
      );
    }
    if (data.containsKey('youtube_url')) {
      context.handle(
        _youtubeUrlMeta,
        youtubeUrl.isAcceptableOrUnknown(data['youtube_url']!, _youtubeUrlMeta),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LiveClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiveClass(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      scheduledStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_start'],
      )!,
      actualStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_start'],
      ),
      actualEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_end'],
      ),
      youtubeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}youtube_url'],
      ),
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $LiveClassesTable createAlias(String alias) {
    return $LiveClassesTable(attachedDatabase, alias);
  }
}

class LiveClass extends DataClass implements Insertable<LiveClass> {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final String status;
  final DateTime scheduledStart;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final String? youtubeUrl;
  final bool isPublished;
  const LiveClass({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.status,
    required this.scheduledStart,
    this.actualStart,
    this.actualEnd,
    this.youtubeUrl,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    if (!nullToAbsent || actualStart != null) {
      map['actual_start'] = Variable<DateTime>(actualStart);
    }
    if (!nullToAbsent || actualEnd != null) {
      map['actual_end'] = Variable<DateTime>(actualEnd);
    }
    if (!nullToAbsent || youtubeUrl != null) {
      map['youtube_url'] = Variable<String>(youtubeUrl);
    }
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  LiveClassesCompanion toCompanion(bool nullToAbsent) {
    return LiveClassesCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      title: Value(title),
      description: Value(description),
      status: Value(status),
      scheduledStart: Value(scheduledStart),
      actualStart: actualStart == null && nullToAbsent
          ? const Value.absent()
          : Value(actualStart),
      actualEnd: actualEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEnd),
      youtubeUrl: youtubeUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(youtubeUrl),
      isPublished: Value(isPublished),
    );
  }

  factory LiveClass.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiveClass(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      scheduledStart: serializer.fromJson<DateTime>(json['scheduledStart']),
      actualStart: serializer.fromJson<DateTime?>(json['actualStart']),
      actualEnd: serializer.fromJson<DateTime?>(json['actualEnd']),
      youtubeUrl: serializer.fromJson<String?>(json['youtubeUrl']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
      'scheduledStart': serializer.toJson<DateTime>(scheduledStart),
      'actualStart': serializer.toJson<DateTime?>(actualStart),
      'actualEnd': serializer.toJson<DateTime?>(actualEnd),
      'youtubeUrl': serializer.toJson<String?>(youtubeUrl),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  LiveClass copyWith({
    String? id,
    String? subjectId,
    String? title,
    String? description,
    String? status,
    DateTime? scheduledStart,
    Value<DateTime?> actualStart = const Value.absent(),
    Value<DateTime?> actualEnd = const Value.absent(),
    Value<String?> youtubeUrl = const Value.absent(),
    bool? isPublished,
  }) => LiveClass(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    scheduledStart: scheduledStart ?? this.scheduledStart,
    actualStart: actualStart.present ? actualStart.value : this.actualStart,
    actualEnd: actualEnd.present ? actualEnd.value : this.actualEnd,
    youtubeUrl: youtubeUrl.present ? youtubeUrl.value : this.youtubeUrl,
    isPublished: isPublished ?? this.isPublished,
  );
  LiveClass copyWithCompanion(LiveClassesCompanion data) {
    return LiveClass(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      actualStart: data.actualStart.present
          ? data.actualStart.value
          : this.actualStart,
      actualEnd: data.actualEnd.present ? data.actualEnd.value : this.actualEnd,
      youtubeUrl: data.youtubeUrl.present
          ? data.youtubeUrl.value
          : this.youtubeUrl,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiveClass(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('actualStart: $actualStart, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    title,
    description,
    status,
    scheduledStart,
    actualStart,
    actualEnd,
    youtubeUrl,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiveClass &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.scheduledStart == this.scheduledStart &&
          other.actualStart == this.actualStart &&
          other.actualEnd == this.actualEnd &&
          other.youtubeUrl == this.youtubeUrl &&
          other.isPublished == this.isPublished);
}

class LiveClassesCompanion extends UpdateCompanion<LiveClass> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> status;
  final Value<DateTime> scheduledStart;
  final Value<DateTime?> actualStart;
  final Value<DateTime?> actualEnd;
  final Value<String?> youtubeUrl;
  final Value<bool> isPublished;
  final Value<int> rowid;
  const LiveClassesCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.actualStart = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LiveClassesCompanion.insert({
    required String id,
    required String subjectId,
    required String title,
    this.description = const Value.absent(),
    required String status,
    required DateTime scheduledStart,
    this.actualStart = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       title = Value(title),
       status = Value(status),
       scheduledStart = Value(scheduledStart);
  static Insertable<LiveClass> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<DateTime>? scheduledStart,
    Expression<DateTime>? actualStart,
    Expression<DateTime>? actualEnd,
    Expression<String>? youtubeUrl,
    Expression<bool>? isPublished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (actualStart != null) 'actual_start': actualStart,
      if (actualEnd != null) 'actual_end': actualEnd,
      if (youtubeUrl != null) 'youtube_url': youtubeUrl,
      if (isPublished != null) 'is_published': isPublished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LiveClassesCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? status,
    Value<DateTime>? scheduledStart,
    Value<DateTime?>? actualStart,
    Value<DateTime?>? actualEnd,
    Value<String?>? youtubeUrl,
    Value<bool>? isPublished,
    Value<int>? rowid,
  }) {
    return LiveClassesCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      actualStart: actualStart ?? this.actualStart,
      actualEnd: actualEnd ?? this.actualEnd,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      isPublished: isPublished ?? this.isPublished,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (actualStart.present) {
      map['actual_start'] = Variable<DateTime>(actualStart.value);
    }
    if (actualEnd.present) {
      map['actual_end'] = Variable<DateTime>(actualEnd.value);
    }
    if (youtubeUrl.present) {
      map['youtube_url'] = Variable<String>(youtubeUrl.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiveClassesCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('actualStart: $actualStart, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('isPublished: $isPublished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnouncementsTable extends Announcements
    with TableInfo<$AnnouncementsTable, Announcement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnouncementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES school_classes (id)',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NORMAL'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    classId,
    priority,
    isActive,
    publishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'announcements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Announcement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Announcement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Announcement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
    );
  }

  @override
  $AnnouncementsTable createAlias(String alias) {
    return $AnnouncementsTable(attachedDatabase, alias);
  }
}

class Announcement extends DataClass implements Insertable<Announcement> {
  final String id;
  final String title;
  final String body;
  final String? classId;
  final String priority;
  final bool isActive;
  final DateTime publishedAt;
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.classId,
    required this.priority,
    required this.isActive,
    required this.publishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || classId != null) {
      map['class_id'] = Variable<String>(classId);
    }
    map['priority'] = Variable<String>(priority);
    map['is_active'] = Variable<bool>(isActive);
    map['published_at'] = Variable<DateTime>(publishedAt);
    return map;
  }

  AnnouncementsCompanion toCompanion(bool nullToAbsent) {
    return AnnouncementsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      classId: classId == null && nullToAbsent
          ? const Value.absent()
          : Value(classId),
      priority: Value(priority),
      isActive: Value(isActive),
      publishedAt: Value(publishedAt),
    );
  }

  factory Announcement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Announcement(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      classId: serializer.fromJson<String?>(json['classId']),
      priority: serializer.fromJson<String>(json['priority']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'classId': serializer.toJson<String?>(classId),
      'priority': serializer.toJson<String>(priority),
      'isActive': serializer.toJson<bool>(isActive),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
    };
  }

  Announcement copyWith({
    String? id,
    String? title,
    String? body,
    Value<String?> classId = const Value.absent(),
    String? priority,
    bool? isActive,
    DateTime? publishedAt,
  }) => Announcement(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    classId: classId.present ? classId.value : this.classId,
    priority: priority ?? this.priority,
    isActive: isActive ?? this.isActive,
    publishedAt: publishedAt ?? this.publishedAt,
  );
  Announcement copyWithCompanion(AnnouncementsCompanion data) {
    return Announcement(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      classId: data.classId.present ? data.classId.value : this.classId,
      priority: data.priority.present ? data.priority.value : this.priority,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Announcement(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('classId: $classId, ')
          ..write('priority: $priority, ')
          ..write('isActive: $isActive, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, classId, priority, isActive, publishedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Announcement &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.classId == this.classId &&
          other.priority == this.priority &&
          other.isActive == this.isActive &&
          other.publishedAt == this.publishedAt);
}

class AnnouncementsCompanion extends UpdateCompanion<Announcement> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> classId;
  final Value<String> priority;
  final Value<bool> isActive;
  final Value<DateTime> publishedAt;
  final Value<int> rowid;
  const AnnouncementsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.classId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isActive = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnouncementsCompanion.insert({
    required String id,
    required String title,
    required String body,
    this.classId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isActive = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       body = Value(body);
  static Insertable<Announcement> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? classId,
    Expression<String>? priority,
    Expression<bool>? isActive,
    Expression<DateTime>? publishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (classId != null) 'class_id': classId,
      if (priority != null) 'priority': priority,
      if (isActive != null) 'is_active': isActive,
      if (publishedAt != null) 'published_at': publishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnouncementsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String?>? classId,
    Value<String>? priority,
    Value<bool>? isActive,
    Value<DateTime>? publishedAt,
    Value<int>? rowid,
  }) {
    return AnnouncementsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      classId: classId ?? this.classId,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      publishedAt: publishedAt ?? this.publishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnouncementsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('classId: $classId, ')
          ..write('priority: $priority, ')
          ..write('isActive: $isActive, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestAttemptsTable extends TestAttempts
    with TableInfo<$TestAttemptsTable, TestAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<String> testId = GeneratedColumn<String>(
    'test_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tests (id)',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMarksMeta = const VerificationMeta(
    'totalMarks',
  );
  @override
  late final GeneratedColumn<double> totalMarks = GeneratedColumn<double>(
    'total_marks',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wrongCountMeta = const VerificationMeta(
    'wrongCount',
  );
  @override
  late final GeneratedColumn<int> wrongCount = GeneratedColumn<int>(
    'wrong_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unansweredCountMeta = const VerificationMeta(
    'unansweredCount',
  );
  @override
  late final GeneratedColumn<int> unansweredCount = GeneratedColumn<int>(
    'unanswered_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeSpentSecondsMeta = const VerificationMeta(
    'timeSpentSeconds',
  );
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
    'time_spent_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    testId,
    studentId,
    score,
    totalMarks,
    correctCount,
    wrongCount,
    unansweredCount,
    timeSpentSeconds,
    submittedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('test_id')) {
      context.handle(
        _testIdMeta,
        testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta),
      );
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total_marks')) {
      context.handle(
        _totalMarksMeta,
        totalMarks.isAcceptableOrUnknown(data['total_marks']!, _totalMarksMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMarksMeta);
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctCountMeta);
    }
    if (data.containsKey('wrong_count')) {
      context.handle(
        _wrongCountMeta,
        wrongCount.isAcceptableOrUnknown(data['wrong_count']!, _wrongCountMeta),
      );
    } else if (isInserting) {
      context.missing(_wrongCountMeta);
    }
    if (data.containsKey('unanswered_count')) {
      context.handle(
        _unansweredCountMeta,
        unansweredCount.isAcceptableOrUnknown(
          data['unanswered_count']!,
          _unansweredCountMeta,
        ),
      );
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
        _timeSpentSecondsMeta,
        timeSpentSeconds.isAcceptableOrUnknown(
          data['time_spent_seconds']!,
          _timeSpentSecondsMeta,
        ),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      testId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      totalMarks: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_marks'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      wrongCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrong_count'],
      )!,
      unansweredCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unanswered_count'],
      )!,
      timeSpentSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent_seconds'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      )!,
    );
  }

  @override
  $TestAttemptsTable createAlias(String alias) {
    return $TestAttemptsTable(attachedDatabase, alias);
  }
}

class TestAttempt extends DataClass implements Insertable<TestAttempt> {
  final String id;
  final String testId;
  final String studentId;
  final double score;
  final double totalMarks;
  final int correctCount;
  final int wrongCount;
  final int unansweredCount;
  final int timeSpentSeconds;
  final DateTime submittedAt;
  const TestAttempt({
    required this.id,
    required this.testId,
    required this.studentId,
    required this.score,
    required this.totalMarks,
    required this.correctCount,
    required this.wrongCount,
    required this.unansweredCount,
    required this.timeSpentSeconds,
    required this.submittedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['test_id'] = Variable<String>(testId);
    map['student_id'] = Variable<String>(studentId);
    map['score'] = Variable<double>(score);
    map['total_marks'] = Variable<double>(totalMarks);
    map['correct_count'] = Variable<int>(correctCount);
    map['wrong_count'] = Variable<int>(wrongCount);
    map['unanswered_count'] = Variable<int>(unansweredCount);
    map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    return map;
  }

  TestAttemptsCompanion toCompanion(bool nullToAbsent) {
    return TestAttemptsCompanion(
      id: Value(id),
      testId: Value(testId),
      studentId: Value(studentId),
      score: Value(score),
      totalMarks: Value(totalMarks),
      correctCount: Value(correctCount),
      wrongCount: Value(wrongCount),
      unansweredCount: Value(unansweredCount),
      timeSpentSeconds: Value(timeSpentSeconds),
      submittedAt: Value(submittedAt),
    );
  }

  factory TestAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestAttempt(
      id: serializer.fromJson<String>(json['id']),
      testId: serializer.fromJson<String>(json['testId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      score: serializer.fromJson<double>(json['score']),
      totalMarks: serializer.fromJson<double>(json['totalMarks']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      wrongCount: serializer.fromJson<int>(json['wrongCount']),
      unansweredCount: serializer.fromJson<int>(json['unansweredCount']),
      timeSpentSeconds: serializer.fromJson<int>(json['timeSpentSeconds']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'testId': serializer.toJson<String>(testId),
      'studentId': serializer.toJson<String>(studentId),
      'score': serializer.toJson<double>(score),
      'totalMarks': serializer.toJson<double>(totalMarks),
      'correctCount': serializer.toJson<int>(correctCount),
      'wrongCount': serializer.toJson<int>(wrongCount),
      'unansweredCount': serializer.toJson<int>(unansweredCount),
      'timeSpentSeconds': serializer.toJson<int>(timeSpentSeconds),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
    };
  }

  TestAttempt copyWith({
    String? id,
    String? testId,
    String? studentId,
    double? score,
    double? totalMarks,
    int? correctCount,
    int? wrongCount,
    int? unansweredCount,
    int? timeSpentSeconds,
    DateTime? submittedAt,
  }) => TestAttempt(
    id: id ?? this.id,
    testId: testId ?? this.testId,
    studentId: studentId ?? this.studentId,
    score: score ?? this.score,
    totalMarks: totalMarks ?? this.totalMarks,
    correctCount: correctCount ?? this.correctCount,
    wrongCount: wrongCount ?? this.wrongCount,
    unansweredCount: unansweredCount ?? this.unansweredCount,
    timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    submittedAt: submittedAt ?? this.submittedAt,
  );
  TestAttempt copyWithCompanion(TestAttemptsCompanion data) {
    return TestAttempt(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      score: data.score.present ? data.score.value : this.score,
      totalMarks: data.totalMarks.present
          ? data.totalMarks.value
          : this.totalMarks,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      wrongCount: data.wrongCount.present
          ? data.wrongCount.value
          : this.wrongCount,
      unansweredCount: data.unansweredCount.present
          ? data.unansweredCount.value
          : this.unansweredCount,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestAttempt(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('studentId: $studentId, ')
          ..write('score: $score, ')
          ..write('totalMarks: $totalMarks, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('unansweredCount: $unansweredCount, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    testId,
    studentId,
    score,
    totalMarks,
    correctCount,
    wrongCount,
    unansweredCount,
    timeSpentSeconds,
    submittedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestAttempt &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.studentId == this.studentId &&
          other.score == this.score &&
          other.totalMarks == this.totalMarks &&
          other.correctCount == this.correctCount &&
          other.wrongCount == this.wrongCount &&
          other.unansweredCount == this.unansweredCount &&
          other.timeSpentSeconds == this.timeSpentSeconds &&
          other.submittedAt == this.submittedAt);
}

class TestAttemptsCompanion extends UpdateCompanion<TestAttempt> {
  final Value<String> id;
  final Value<String> testId;
  final Value<String> studentId;
  final Value<double> score;
  final Value<double> totalMarks;
  final Value<int> correctCount;
  final Value<int> wrongCount;
  final Value<int> unansweredCount;
  final Value<int> timeSpentSeconds;
  final Value<DateTime> submittedAt;
  final Value<int> rowid;
  const TestAttemptsCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.score = const Value.absent(),
    this.totalMarks = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.unansweredCount = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestAttemptsCompanion.insert({
    required String id,
    required String testId,
    required String studentId,
    required double score,
    required double totalMarks,
    required int correctCount,
    required int wrongCount,
    this.unansweredCount = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       testId = Value(testId),
       studentId = Value(studentId),
       score = Value(score),
       totalMarks = Value(totalMarks),
       correctCount = Value(correctCount),
       wrongCount = Value(wrongCount);
  static Insertable<TestAttempt> custom({
    Expression<String>? id,
    Expression<String>? testId,
    Expression<String>? studentId,
    Expression<double>? score,
    Expression<double>? totalMarks,
    Expression<int>? correctCount,
    Expression<int>? wrongCount,
    Expression<int>? unansweredCount,
    Expression<int>? timeSpentSeconds,
    Expression<DateTime>? submittedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (studentId != null) 'student_id': studentId,
      if (score != null) 'score': score,
      if (totalMarks != null) 'total_marks': totalMarks,
      if (correctCount != null) 'correct_count': correctCount,
      if (wrongCount != null) 'wrong_count': wrongCount,
      if (unansweredCount != null) 'unanswered_count': unansweredCount,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestAttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? testId,
    Value<String>? studentId,
    Value<double>? score,
    Value<double>? totalMarks,
    Value<int>? correctCount,
    Value<int>? wrongCount,
    Value<int>? unansweredCount,
    Value<int>? timeSpentSeconds,
    Value<DateTime>? submittedAt,
    Value<int>? rowid,
  }) {
    return TestAttemptsCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      studentId: studentId ?? this.studentId,
      score: score ?? this.score,
      totalMarks: totalMarks ?? this.totalMarks,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      unansweredCount: unansweredCount ?? this.unansweredCount,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      submittedAt: submittedAt ?? this.submittedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<String>(testId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (totalMarks.present) {
      map['total_marks'] = Variable<double>(totalMarks.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (wrongCount.present) {
      map['wrong_count'] = Variable<int>(wrongCount.value);
    }
    if (unansweredCount.present) {
      map['unanswered_count'] = Variable<int>(unansweredCount.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('studentId: $studentId, ')
          ..write('score: $score, ')
          ..write('totalMarks: $totalMarks, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('unansweredCount: $unansweredCount, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestAttemptAnswersTable extends TestAttemptAnswers
    with TableInfo<$TestAttemptAnswersTable, TestAttemptAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestAttemptAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES test_attempts (id)',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES test_questions (id)',
    ),
  );
  static const VerificationMeta _selectedOptionMeta = const VerificationMeta(
    'selectedOption',
  );
  @override
  late final GeneratedColumn<String> selectedOption = GeneratedColumn<String>(
    'selected_option',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    questionId,
    selectedOption,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_attempt_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestAttemptAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_option')) {
      context.handle(
        _selectedOptionMeta,
        selectedOption.isAcceptableOrUnknown(
          data['selected_option']!,
          _selectedOptionMeta,
        ),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId, questionId};
  @override
  TestAttemptAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestAttemptAnswer(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      selectedOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_option'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
    );
  }

  @override
  $TestAttemptAnswersTable createAlias(String alias) {
    return $TestAttemptAnswersTable(attachedDatabase, alias);
  }
}

class TestAttemptAnswer extends DataClass
    implements Insertable<TestAttemptAnswer> {
  final String attemptId;
  final String questionId;
  final String? selectedOption;
  final bool isCorrect;
  const TestAttemptAnswer({
    required this.attemptId,
    required this.questionId,
    this.selectedOption,
    required this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    map['question_id'] = Variable<String>(questionId);
    if (!nullToAbsent || selectedOption != null) {
      map['selected_option'] = Variable<String>(selectedOption);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  TestAttemptAnswersCompanion toCompanion(bool nullToAbsent) {
    return TestAttemptAnswersCompanion(
      attemptId: Value(attemptId),
      questionId: Value(questionId),
      selectedOption: selectedOption == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedOption),
      isCorrect: Value(isCorrect),
    );
  }

  factory TestAttemptAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestAttemptAnswer(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      selectedOption: serializer.fromJson<String?>(json['selectedOption']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'questionId': serializer.toJson<String>(questionId),
      'selectedOption': serializer.toJson<String?>(selectedOption),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  TestAttemptAnswer copyWith({
    String? attemptId,
    String? questionId,
    Value<String?> selectedOption = const Value.absent(),
    bool? isCorrect,
  }) => TestAttemptAnswer(
    attemptId: attemptId ?? this.attemptId,
    questionId: questionId ?? this.questionId,
    selectedOption: selectedOption.present
        ? selectedOption.value
        : this.selectedOption,
    isCorrect: isCorrect ?? this.isCorrect,
  );
  TestAttemptAnswer copyWithCompanion(TestAttemptAnswersCompanion data) {
    return TestAttemptAnswer(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedOption: data.selectedOption.present
          ? data.selectedOption.value
          : this.selectedOption,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestAttemptAnswer(')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedOption: $selectedOption, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(attemptId, questionId, selectedOption, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestAttemptAnswer &&
          other.attemptId == this.attemptId &&
          other.questionId == this.questionId &&
          other.selectedOption == this.selectedOption &&
          other.isCorrect == this.isCorrect);
}

class TestAttemptAnswersCompanion extends UpdateCompanion<TestAttemptAnswer> {
  final Value<String> attemptId;
  final Value<String> questionId;
  final Value<String?> selectedOption;
  final Value<bool> isCorrect;
  final Value<int> rowid;
  const TestAttemptAnswersCompanion({
    this.attemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedOption = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestAttemptAnswersCompanion.insert({
    required String attemptId,
    required String questionId,
    this.selectedOption = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       questionId = Value(questionId);
  static Insertable<TestAttemptAnswer> custom({
    Expression<String>? attemptId,
    Expression<String>? questionId,
    Expression<String>? selectedOption,
    Expression<bool>? isCorrect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionId != null) 'question_id': questionId,
      if (selectedOption != null) 'selected_option': selectedOption,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestAttemptAnswersCompanion copyWith({
    Value<String>? attemptId,
    Value<String>? questionId,
    Value<String?>? selectedOption,
    Value<bool>? isCorrect,
    Value<int>? rowid,
  }) {
    return TestAttemptAnswersCompanion(
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      selectedOption: selectedOption ?? this.selectedOption,
      isCorrect: isCorrect ?? this.isCorrect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (selectedOption.present) {
      map['selected_option'] = Variable<String>(selectedOption.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestAttemptAnswersCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedOption: $selectedOption, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchoolClassesTable schoolClasses = $SchoolClassesTable(this);
  late final $BoardsTable boards = $BoardsTable(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $ResourcesTable resources = $ResourcesTable(this);
  late final $TestsTable tests = $TestsTable(this);
  late final $TestQuestionsTable testQuestions = $TestQuestionsTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $RecentViewsTable recentViews = $RecentViewsTable(this);
  late final $LessonProgressTable lessonProgress = $LessonProgressTable(this);
  late final $DownloadsTable downloads = $DownloadsTable(this);
  late final $LiveClassesTable liveClasses = $LiveClassesTable(this);
  late final $AnnouncementsTable announcements = $AnnouncementsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $TestAttemptsTable testAttempts = $TestAttemptsTable(this);
  late final $TestAttemptAnswersTable testAttemptAnswers =
      $TestAttemptAnswersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    schoolClasses,
    boards,
    subjects,
    chapters,
    lessons,
    resources,
    tests,
    testQuestions,
    students,
    bookmarks,
    recentViews,
    lessonProgress,
    downloads,
    liveClasses,
    announcements,
    appSettings,
    testAttempts,
    testAttemptAnswers,
  ];
}

typedef $$SchoolClassesTableCreateCompanionBuilder =
    SchoolClassesCompanion Function({
      required String id,
      required int level,
      required String nameHindi,
      required String nameEnglish,
      Value<int> displayOrder,
      Value<int> rowid,
    });
typedef $$SchoolClassesTableUpdateCompanionBuilder =
    SchoolClassesCompanion Function({
      Value<String> id,
      Value<int> level,
      Value<String> nameHindi,
      Value<String> nameEnglish,
      Value<int> displayOrder,
      Value<int> rowid,
    });

final class $$SchoolClassesTableReferences
    extends BaseReferences<_$AppDatabase, $SchoolClassesTable, SchoolClass> {
  $$SchoolClassesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SubjectsTable, List<Subject>> _subjectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.subjects,
    aliasName: 'school_classes__id__subjects__class_id',
  );

  $$SubjectsTableProcessedTableManager get subjectsRefs {
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.classId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subjectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudentsTable, List<Student>> _studentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.students,
    aliasName: 'school_classes__id__students__class_id',
  );

  $$StudentsTableProcessedTableManager get studentsRefs {
    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.classId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnnouncementsTable, List<Announcement>>
  _announcementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.announcements,
    aliasName: 'school_classes__id__announcements__class_id',
  );

  $$AnnouncementsTableProcessedTableManager get announcementsRefs {
    final manager = $$AnnouncementsTableTableManager(
      $_db,
      $_db.announcements,
    ).filter((f) => f.classId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_announcementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SchoolClassesTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolClassesTable> {
  $$SchoolClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameHindi => $composableBuilder(
    column: $table.nameHindi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subjectsRefs(
    Expression<bool> Function($$SubjectsTableFilterComposer f) f,
  ) {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.classId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studentsRefs(
    Expression<bool> Function($$StudentsTableFilterComposer f) f,
  ) {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.classId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> announcementsRefs(
    Expression<bool> Function($$AnnouncementsTableFilterComposer f) f,
  ) {
    final $$AnnouncementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.announcements,
      getReferencedColumn: (t) => t.classId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnouncementsTableFilterComposer(
            $db: $db,
            $table: $db.announcements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchoolClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolClassesTable> {
  $$SchoolClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameHindi => $composableBuilder(
    column: $table.nameHindi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolClassesTable> {
  $$SchoolClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get nameHindi =>
      $composableBuilder(column: $table.nameHindi, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  Expression<T> subjectsRefs<T extends Object>(
    Expression<T> Function($$SubjectsTableAnnotationComposer a) f,
  ) {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.classId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studentsRefs<T extends Object>(
    Expression<T> Function($$StudentsTableAnnotationComposer a) f,
  ) {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.classId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> announcementsRefs<T extends Object>(
    Expression<T> Function($$AnnouncementsTableAnnotationComposer a) f,
  ) {
    final $$AnnouncementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.announcements,
      getReferencedColumn: (t) => t.classId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnouncementsTableAnnotationComposer(
            $db: $db,
            $table: $db.announcements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchoolClassesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolClassesTable,
          SchoolClass,
          $$SchoolClassesTableFilterComposer,
          $$SchoolClassesTableOrderingComposer,
          $$SchoolClassesTableAnnotationComposer,
          $$SchoolClassesTableCreateCompanionBuilder,
          $$SchoolClassesTableUpdateCompanionBuilder,
          (SchoolClass, $$SchoolClassesTableReferences),
          SchoolClass,
          PrefetchHooks Function({
            bool subjectsRefs,
            bool studentsRefs,
            bool announcementsRefs,
          })
        > {
  $$SchoolClassesTableTableManager(_$AppDatabase db, $SchoolClassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> nameHindi = const Value.absent(),
                Value<String> nameEnglish = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolClassesCompanion(
                id: id,
                level: level,
                nameHindi: nameHindi,
                nameEnglish: nameEnglish,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int level,
                required String nameHindi,
                required String nameEnglish,
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolClassesCompanion.insert(
                id: id,
                level: level,
                nameHindi: nameHindi,
                nameEnglish: nameEnglish,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SchoolClassesTable, SchoolClass>(table),
                  $$SchoolClassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subjectsRefs = false,
                studentsRefs = false,
                announcementsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subjectsRefs) db.subjects,
                    if (studentsRefs) db.students,
                    if (announcementsRefs) db.announcements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subjectsRefs)
                        await $_getPrefetchedData<
                          SchoolClass,
                          $SchoolClassesTable,
                          Subject
                        >(
                          currentTable: table,
                          referencedTable: $$SchoolClassesTableReferences
                              ._subjectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchoolClassesTableReferences(
                                db,
                                table,
                                p0,
                              ).subjectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.classId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studentsRefs)
                        await $_getPrefetchedData<
                          SchoolClass,
                          $SchoolClassesTable,
                          Student
                        >(
                          currentTable: table,
                          referencedTable: $$SchoolClassesTableReferences
                              ._studentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchoolClassesTableReferences(
                                db,
                                table,
                                p0,
                              ).studentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.classId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (announcementsRefs)
                        await $_getPrefetchedData<
                          SchoolClass,
                          $SchoolClassesTable,
                          Announcement
                        >(
                          currentTable: table,
                          referencedTable: $$SchoolClassesTableReferences
                              ._announcementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchoolClassesTableReferences(
                                db,
                                table,
                                p0,
                              ).announcementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.classId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SchoolClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolClassesTable,
      SchoolClass,
      $$SchoolClassesTableFilterComposer,
      $$SchoolClassesTableOrderingComposer,
      $$SchoolClassesTableAnnotationComposer,
      $$SchoolClassesTableCreateCompanionBuilder,
      $$SchoolClassesTableUpdateCompanionBuilder,
      (SchoolClass, $$SchoolClassesTableReferences),
      SchoolClass,
      PrefetchHooks Function({
        bool subjectsRefs,
        bool studentsRefs,
        bool announcementsRefs,
      })
    >;
typedef $$BoardsTableCreateCompanionBuilder = BoardsCompanion Function({
  required String id,
  required String nameHindi,
  required String nameEnglish,
  Value<int> displayOrder,
  Value<int> rowid,
});
typedef $$BoardsTableUpdateCompanionBuilder = BoardsCompanion Function({
  Value<String> id,
  Value<String> nameHindi,
  Value<String> nameEnglish,
  Value<int> displayOrder,
  Value<int> rowid,
});

final class $$BoardsTableReferences
    extends BaseReferences<_$AppDatabase, $BoardsTable, Board> {
  $$BoardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubjectsTable, List<Subject>> _subjectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.subjects,
    aliasName: 'boards__id__subjects__board_id',
  );

  $$SubjectsTableProcessedTableManager get subjectsRefs {
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.boardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subjectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BoardsTableFilterComposer
    extends Composer<_$AppDatabase, $BoardsTable> {
  $$BoardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameHindi => $composableBuilder(
    column: $table.nameHindi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subjectsRefs(
    Expression<bool> Function($$SubjectsTableFilterComposer f) f,
  ) {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.boardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BoardsTableOrderingComposer
    extends Composer<_$AppDatabase, $BoardsTable> {
  $$BoardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameHindi => $composableBuilder(
    column: $table.nameHindi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BoardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BoardsTable> {
  $$BoardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameHindi =>
      $composableBuilder(column: $table.nameHindi, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  Expression<T> subjectsRefs<T extends Object>(
    Expression<T> Function($$SubjectsTableAnnotationComposer a) f,
  ) {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.boardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BoardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BoardsTable,
          Board,
          $$BoardsTableFilterComposer,
          $$BoardsTableOrderingComposer,
          $$BoardsTableAnnotationComposer,
          $$BoardsTableCreateCompanionBuilder,
          $$BoardsTableUpdateCompanionBuilder,
          (Board, $$BoardsTableReferences),
          Board,
          PrefetchHooks Function({bool subjectsRefs})
        > {
  $$BoardsTableTableManager(_$AppDatabase db, $BoardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BoardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BoardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BoardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameHindi = const Value.absent(),
                Value<String> nameEnglish = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BoardsCompanion(
                id: id,
                nameHindi: nameHindi,
                nameEnglish: nameEnglish,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameHindi,
                required String nameEnglish,
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BoardsCompanion.insert(
                id: id,
                nameHindi: nameHindi,
                nameEnglish: nameEnglish,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BoardsTable, Board>(table),
                  $$BoardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (subjectsRefs) db.subjects],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subjectsRefs)
                    await $_getPrefetchedData<Board, $BoardsTable, Subject>(
                      currentTable: table,
                      referencedTable: $$BoardsTableReferences
                          ._subjectsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BoardsTableReferences(db, table, p0).subjectsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.boardId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BoardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BoardsTable,
      Board,
      $$BoardsTableFilterComposer,
      $$BoardsTableOrderingComposer,
      $$BoardsTableAnnotationComposer,
      $$BoardsTableCreateCompanionBuilder,
      $$BoardsTableUpdateCompanionBuilder,
      (Board, $$BoardsTableReferences),
      Board,
      PrefetchHooks Function({bool subjectsRefs})
    >;
typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String classId,
  Value<String?> boardId,
  required String nameHindi,
  required String nameEnglish,
  Value<String> accentColor,
  Value<int> displayOrder,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> classId,
  Value<String?> boardId,
  Value<String> nameHindi,
  Value<String> nameEnglish,
  Value<String> accentColor,
  Value<int> displayOrder,
  Value<int> rowid,
});

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SchoolClassesTable _classIdTable(_$AppDatabase db) =>
      db.schoolClasses.createAlias('subjects__class_id__school_classes__id');

  $$SchoolClassesTableProcessedTableManager get classId {
    final $_column = $_itemColumn<String>('class_id')!;

    final manager = $$SchoolClassesTableTableManager(
      $_db,
      $_db.schoolClasses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BoardsTable _boardIdTable(_$AppDatabase db) =>
      db.boards.createAlias('subjects__board_id__boards__id');

  $$BoardsTableProcessedTableManager? get boardId {
    final $_column = $_itemColumn<String>('board_id');
    if ($_column == null) return null;
    final manager = $$BoardsTableTableManager(
      $_db,
      $_db.boards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_boardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: 'subjects__id__chapters__subject_id',
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResourcesTable, List<Resource>>
  _resourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resources,
    aliasName: 'subjects__id__resources__subject_id',
  );

  $$ResourcesTableProcessedTableManager get resourcesRefs {
    final manager = $$ResourcesTableTableManager(
      $_db,
      $_db.resources,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_resourcesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LiveClassesTable, List<LiveClass>>
  _liveClassesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.liveClasses,
    aliasName: 'subjects__id__live_classes__subject_id',
  );

  $$LiveClassesTableProcessedTableManager get liveClassesRefs {
    final manager = $$LiveClassesTableTableManager(
      $_db,
      $_db.liveClasses,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_liveClassesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameHindi => $composableBuilder(
    column: $table.nameHindi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$SchoolClassesTableFilterComposer get classId {
    final $$SchoolClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableFilterComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BoardsTableFilterComposer get boardId {
    final $$BoardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.boardId,
      referencedTable: $db.boards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardsTableFilterComposer(
            $db: $db,
            $table: $db.boards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resourcesRefs(
    Expression<bool> Function($$ResourcesTableFilterComposer f) f,
  ) {
    final $$ResourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableFilterComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> liveClassesRefs(
    Expression<bool> Function($$LiveClassesTableFilterComposer f) f,
  ) {
    final $$LiveClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.liveClasses,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LiveClassesTableFilterComposer(
            $db: $db,
            $table: $db.liveClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameHindi => $composableBuilder(
    column: $table.nameHindi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$SchoolClassesTableOrderingComposer get classId {
    final $$SchoolClassesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableOrderingComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BoardsTableOrderingComposer get boardId {
    final $$BoardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.boardId,
      referencedTable: $db.boards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardsTableOrderingComposer(
            $db: $db,
            $table: $db.boards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameHindi =>
      $composableBuilder(column: $table.nameHindi, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  $$SchoolClassesTableAnnotationComposer get classId {
    final $$SchoolClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BoardsTableAnnotationComposer get boardId {
    final $$BoardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.boardId,
      referencedTable: $db.boards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardsTableAnnotationComposer(
            $db: $db,
            $table: $db.boards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resourcesRefs<T extends Object>(
    Expression<T> Function($$ResourcesTableAnnotationComposer a) f,
  ) {
    final $$ResourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> liveClassesRefs<T extends Object>(
    Expression<T> Function($$LiveClassesTableAnnotationComposer a) f,
  ) {
    final $$LiveClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.liveClasses,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LiveClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.liveClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({
            bool classId,
            bool boardId,
            bool chaptersRefs,
            bool resourcesRefs,
            bool liveClassesRefs,
          })
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> classId = const Value.absent(),
                Value<String?> boardId = const Value.absent(),
                Value<String> nameHindi = const Value.absent(),
                Value<String> nameEnglish = const Value.absent(),
                Value<String> accentColor = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                classId: classId,
                boardId: boardId,
                nameHindi: nameHindi,
                nameEnglish: nameEnglish,
                accentColor: accentColor,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String classId,
                Value<String?> boardId = const Value.absent(),
                required String nameHindi,
                required String nameEnglish,
                Value<String> accentColor = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                classId: classId,
                boardId: boardId,
                nameHindi: nameHindi,
                nameEnglish: nameEnglish,
                accentColor: accentColor,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubjectsTable, Subject>(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                classId = false,
                boardId = false,
                chaptersRefs = false,
                resourcesRefs = false,
                liveClassesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (resourcesRefs) db.resources,
                    if (liveClassesRefs) db.liveClasses,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (classId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.classId,
                            referencedTable: $$SubjectsTableReferences
                                ._classIdTable(db),
                            referencedColumn: $$SubjectsTableReferences
                                ._classIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (boardId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.boardId,
                            referencedTable: $$SubjectsTableReferences
                                ._boardIdTable(db),
                            referencedColumn: $$SubjectsTableReferences
                                ._boardIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          Chapter
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._chaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resourcesRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          Resource
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._resourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).resourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (liveClassesRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          LiveClass
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._liveClassesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).liveClassesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({
        bool classId,
        bool boardId,
        bool chaptersRefs,
        bool resourcesRefs,
        bool liveClassesRefs,
      })
    >;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  required String id,
  required String subjectId,
  required int number,
  required String title,
  Value<String> titleHindi,
  Value<String> summary,
  Value<int> rowid,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<String> id,
  Value<String> subjectId,
  Value<int> number,
  Value<String> title,
  Value<String> titleHindi,
  Value<String> summary,
  Value<int> rowid,
});

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias('chapters__subject_id__subjects__id');

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LessonsTable, List<Lesson>> _lessonsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lessons,
    aliasName: 'chapters__id__lessons__chapter_id',
  );

  $$LessonsTableProcessedTableManager get lessonsRefs {
    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResourcesTable, List<Resource>>
  _resourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resources,
    aliasName: 'chapters__id__resources__chapter_id',
  );

  $$ResourcesTableProcessedTableManager get resourcesRefs {
    final manager = $$ResourcesTableTableManager(
      $_db,
      $_db.resources,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_resourcesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TestsTable, List<Test>> _testsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tests,
    aliasName: 'chapters__id__tests__chapter_id',
  );

  $$TestsTableProcessedTableManager get testsRefs {
    final manager = $$TestsTableTableManager(
      $_db,
      $_db.tests,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_testsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleHindi => $composableBuilder(
    column: $table.titleHindi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lessonsRefs(
    Expression<bool> Function($$LessonsTableFilterComposer f) f,
  ) {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resourcesRefs(
    Expression<bool> Function($$ResourcesTableFilterComposer f) f,
  ) {
    final $$ResourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableFilterComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> testsRefs(
    Expression<bool> Function($$TestsTableFilterComposer f) f,
  ) {
    final $$TestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableFilterComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleHindi => $composableBuilder(
    column: $table.titleHindi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleHindi => $composableBuilder(
    column: $table.titleHindi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lessonsRefs<T extends Object>(
    Expression<T> Function($$LessonsTableAnnotationComposer a) f,
  ) {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resourcesRefs<T extends Object>(
    Expression<T> Function($$ResourcesTableAnnotationComposer a) f,
  ) {
    final $$ResourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> testsRefs<T extends Object>(
    Expression<T> Function($$TestsTableAnnotationComposer a) f,
  ) {
    final $$TestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableAnnotationComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, $$ChaptersTableReferences),
          Chapter,
          PrefetchHooks Function({
            bool subjectId,
            bool lessonsRefs,
            bool resourcesRefs,
            bool testsRefs,
          })
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleHindi = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                subjectId: subjectId,
                number: number,
                title: title,
                titleHindi: titleHindi,
                summary: summary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required int number,
                required String title,
                Value<String> titleHindi = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                subjectId: subjectId,
                number: number,
                title: title,
                titleHindi: titleHindi,
                summary: summary,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChaptersTable, Chapter>(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subjectId = false,
                lessonsRefs = false,
                resourcesRefs = false,
                testsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lessonsRefs) db.lessons,
                    if (resourcesRefs) db.resources,
                    if (testsRefs) db.tests,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.subjectId,
                            referencedTable: $$ChaptersTableReferences
                                ._subjectIdTable(db),
                            referencedColumn: $$ChaptersTableReferences
                                ._subjectIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lessonsRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Lesson
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._lessonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resourcesRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Resource
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._resourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).resourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (testsRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Test
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._testsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).testsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, $$ChaptersTableReferences),
      Chapter,
      PrefetchHooks Function({
        bool subjectId,
        bool lessonsRefs,
        bool resourcesRefs,
        bool testsRefs,
      })
    >;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String chapterId,
  required String title,
  Value<String> description,
  Value<int> displayOrder,
  Value<String?> youtubeUrl,
  Value<String?> localVideoPath,
  Value<int> durationSeconds,
  Value<bool> isPublished,
  Value<int> rowid,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> chapterId,
  Value<String> title,
  Value<String> description,
  Value<int> displayOrder,
  Value<String?> youtubeUrl,
  Value<String?> localVideoPath,
  Value<int> durationSeconds,
  Value<bool> isPublished,
  Value<int> rowid,
});

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias('lessons__chapter_id__chapters__id');

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LessonProgressTable, List<LessonProgressRow>>
  _lessonProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonProgress,
    aliasName: 'lessons__id__lesson_progress__lesson_id',
  );

  $$LessonProgressTableProcessedTableManager get lessonProgressRefs {
    final manager = $$LessonProgressTableTableManager(
      $_db,
      $_db.lessonProgress,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localVideoPath => $composableBuilder(
    column: $table.localVideoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lessonProgressRefs(
    Expression<bool> Function($$LessonProgressTableFilterComposer f) f,
  ) {
    final $$LessonProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableFilterComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localVideoPath => $composableBuilder(
    column: $table.localVideoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localVideoPath => $composableBuilder(
    column: $table.localVideoPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lessonProgressRefs<T extends Object>(
    Expression<T> Function($$LessonProgressTableAnnotationComposer a) f,
  ) {
    final $$LessonProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, $$LessonsTableReferences),
          Lesson,
          PrefetchHooks Function({bool chapterId, bool lessonProgressRefs})
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<String?> localVideoPath = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                chapterId: chapterId,
                title: title,
                description: description,
                displayOrder: displayOrder,
                youtubeUrl: youtubeUrl,
                localVideoPath: localVideoPath,
                durationSeconds: durationSeconds,
                isPublished: isPublished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                required String title,
                Value<String> description = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<String?> localVideoPath = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                chapterId: chapterId,
                title: title,
                description: description,
                displayOrder: displayOrder,
                youtubeUrl: youtubeUrl,
                localVideoPath: localVideoPath,
                durationSeconds: durationSeconds,
                isPublished: isPublished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LessonsTable, Lesson>(table),
                  $$LessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({chapterId = false, lessonProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lessonProgressRefs) db.lessonProgress,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (chapterId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.chapterId,
                            referencedTable: $$LessonsTableReferences
                                ._chapterIdTable(db),
                            referencedColumn: $$LessonsTableReferences
                                ._chapterIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lessonProgressRefs)
                        await $_getPrefetchedData<
                          Lesson,
                          $LessonsTable,
                          LessonProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._lessonProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, $$LessonsTableReferences),
      Lesson,
      PrefetchHooks Function({bool chapterId, bool lessonProgressRefs})
    >;
typedef $$ResourcesTableCreateCompanionBuilder = ResourcesCompanion Function({
  required String id,
  required String subjectId,
  Value<String?> chapterId,
  required String title,
  Value<String> description,
  required String kind,
  Value<int?> yearLabel,
  Value<String?> localFilePath,
  Value<String?> remoteUrl,
  Value<int> fileSizeBytes,
  Value<bool> isPublished,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ResourcesTableUpdateCompanionBuilder = ResourcesCompanion Function({
  Value<String> id,
  Value<String> subjectId,
  Value<String?> chapterId,
  Value<String> title,
  Value<String> description,
  Value<String> kind,
  Value<int?> yearLabel,
  Value<String?> localFilePath,
  Value<String?> remoteUrl,
  Value<int> fileSizeBytes,
  Value<bool> isPublished,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ResourcesTableReferences
    extends BaseReferences<_$AppDatabase, $ResourcesTable, Resource> {
  $$ResourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias('resources__subject_id__subjects__id');

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias('resources__chapter_id__chapters__id');

  $$ChaptersTableProcessedTableManager? get chapterId {
    final $_column = $_itemColumn<String>('chapter_id');
    if ($_column == null) return null;
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DownloadsTable, List<Download>>
  _downloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloads,
    aliasName: 'resources__id__downloads__resource_id',
  );

  $$DownloadsTableProcessedTableManager get downloadsRefs {
    final manager = $$DownloadsTableTableManager(
      $_db,
      $_db.downloads,
    ).filter((f) => f.resourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ResourcesTableFilterComposer
    extends Composer<_$AppDatabase, $ResourcesTable> {
  $$ResourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearLabel => $composableBuilder(
    column: $table.yearLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> downloadsRefs(
    Expression<bool> Function($$DownloadsTableFilterComposer f) f,
  ) {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.resourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableFilterComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ResourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $ResourcesTable> {
  $$ResourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearLabel => $composableBuilder(
    column: $table.yearLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResourcesTable> {
  $$ResourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get yearLabel =>
      $composableBuilder(column: $table.yearLabel, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> downloadsRefs<T extends Object>(
    Expression<T> Function($$DownloadsTableAnnotationComposer a) f,
  ) {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.resourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ResourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResourcesTable,
          Resource,
          $$ResourcesTableFilterComposer,
          $$ResourcesTableOrderingComposer,
          $$ResourcesTableAnnotationComposer,
          $$ResourcesTableCreateCompanionBuilder,
          $$ResourcesTableUpdateCompanionBuilder,
          (Resource, $$ResourcesTableReferences),
          Resource,
          PrefetchHooks Function({
            bool subjectId,
            bool chapterId,
            bool downloadsRefs,
          })
        > {
  $$ResourcesTableTableManager(_$AppDatabase db, $ResourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String?> chapterId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> yearLabel = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResourcesCompanion(
                id: id,
                subjectId: subjectId,
                chapterId: chapterId,
                title: title,
                description: description,
                kind: kind,
                yearLabel: yearLabel,
                localFilePath: localFilePath,
                remoteUrl: remoteUrl,
                fileSizeBytes: fileSizeBytes,
                isPublished: isPublished,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                Value<String?> chapterId = const Value.absent(),
                required String title,
                Value<String> description = const Value.absent(),
                required String kind,
                Value<int?> yearLabel = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResourcesCompanion.insert(
                id: id,
                subjectId: subjectId,
                chapterId: chapterId,
                title: title,
                description: description,
                kind: kind,
                yearLabel: yearLabel,
                localFilePath: localFilePath,
                remoteUrl: remoteUrl,
                fileSizeBytes: fileSizeBytes,
                isPublished: isPublished,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ResourcesTable, Resource>(table),
                  $$ResourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({subjectId = false, chapterId = false, downloadsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (downloadsRefs) db.downloads],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.subjectId,
                            referencedTable: $$ResourcesTableReferences
                                ._subjectIdTable(db),
                            referencedColumn: $$ResourcesTableReferences
                                ._subjectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (chapterId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.chapterId,
                            referencedTable: $$ResourcesTableReferences
                                ._chapterIdTable(db),
                            referencedColumn: $$ResourcesTableReferences
                                ._chapterIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (downloadsRefs)
                        await $_getPrefetchedData<
                          Resource,
                          $ResourcesTable,
                          Download
                        >(
                          currentTable: table,
                          referencedTable: $$ResourcesTableReferences
                              ._downloadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ResourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.resourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ResourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResourcesTable,
      Resource,
      $$ResourcesTableFilterComposer,
      $$ResourcesTableOrderingComposer,
      $$ResourcesTableAnnotationComposer,
      $$ResourcesTableCreateCompanionBuilder,
      $$ResourcesTableUpdateCompanionBuilder,
      (Resource, $$ResourcesTableReferences),
      Resource,
      PrefetchHooks Function({
        bool subjectId,
        bool chapterId,
        bool downloadsRefs,
      })
    >;
typedef $$TestsTableCreateCompanionBuilder = TestsCompanion Function({
  required String id,
  required String chapterId,
  required String title,
  Value<int> timeLimitMinutes,
  Value<double> marksPerQuestion,
  Value<double> negativeMarking,
  Value<bool> isPublished,
  Value<int> rowid,
});
typedef $$TestsTableUpdateCompanionBuilder = TestsCompanion Function({
  Value<String> id,
  Value<String> chapterId,
  Value<String> title,
  Value<int> timeLimitMinutes,
  Value<double> marksPerQuestion,
  Value<double> negativeMarking,
  Value<bool> isPublished,
  Value<int> rowid,
});

final class $$TestsTableReferences
    extends BaseReferences<_$AppDatabase, $TestsTable, Test> {
  $$TestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias('tests__chapter_id__chapters__id');

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TestQuestionsTable, List<TestQuestion>>
  _testQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.testQuestions,
    aliasName: 'tests__id__test_questions__test_id',
  );

  $$TestQuestionsTableProcessedTableManager get testQuestionsRefs {
    final manager = $$TestQuestionsTableTableManager(
      $_db,
      $_db.testQuestions,
    ).filter((f) => f.testId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_testQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TestAttemptsTable, List<TestAttempt>>
  _testAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.testAttempts,
    aliasName: 'tests__id__test_attempts__test_id',
  );

  $$TestAttemptsTableProcessedTableManager get testAttemptsRefs {
    final manager = $$TestAttemptsTableTableManager(
      $_db,
      $_db.testAttempts,
    ).filter((f) => f.testId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_testAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TestsTableFilterComposer extends Composer<_$AppDatabase, $TestsTable> {
  $$TestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeLimitMinutes => $composableBuilder(
    column: $table.timeLimitMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get marksPerQuestion => $composableBuilder(
    column: $table.marksPerQuestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get negativeMarking => $composableBuilder(
    column: $table.negativeMarking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> testQuestionsRefs(
    Expression<bool> Function($$TestQuestionsTableFilterComposer f) f,
  ) {
    final $$TestQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testQuestions,
      getReferencedColumn: (t) => t.testId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.testQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> testAttemptsRefs(
    Expression<bool> Function($$TestAttemptsTableFilterComposer f) f,
  ) {
    final $$TestAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.testId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TestsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestsTable> {
  $$TestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeLimitMinutes => $composableBuilder(
    column: $table.timeLimitMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get marksPerQuestion => $composableBuilder(
    column: $table.marksPerQuestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get negativeMarking => $composableBuilder(
    column: $table.negativeMarking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestsTable> {
  $$TestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get timeLimitMinutes => $composableBuilder(
    column: $table.timeLimitMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get marksPerQuestion => $composableBuilder(
    column: $table.marksPerQuestion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get negativeMarking => $composableBuilder(
    column: $table.negativeMarking,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> testQuestionsRefs<T extends Object>(
    Expression<T> Function($$TestQuestionsTableAnnotationComposer a) f,
  ) {
    final $$TestQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testQuestions,
      getReferencedColumn: (t) => t.testId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.testQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> testAttemptsRefs<T extends Object>(
    Expression<T> Function($$TestAttemptsTableAnnotationComposer a) f,
  ) {
    final $$TestAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.testId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestsTable,
          Test,
          $$TestsTableFilterComposer,
          $$TestsTableOrderingComposer,
          $$TestsTableAnnotationComposer,
          $$TestsTableCreateCompanionBuilder,
          $$TestsTableUpdateCompanionBuilder,
          (Test, $$TestsTableReferences),
          Test,
          PrefetchHooks Function({
            bool chapterId,
            bool testQuestionsRefs,
            bool testAttemptsRefs,
          })
        > {
  $$TestsTableTableManager(_$AppDatabase db, $TestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> timeLimitMinutes = const Value.absent(),
                Value<double> marksPerQuestion = const Value.absent(),
                Value<double> negativeMarking = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestsCompanion(
                id: id,
                chapterId: chapterId,
                title: title,
                timeLimitMinutes: timeLimitMinutes,
                marksPerQuestion: marksPerQuestion,
                negativeMarking: negativeMarking,
                isPublished: isPublished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                required String title,
                Value<int> timeLimitMinutes = const Value.absent(),
                Value<double> marksPerQuestion = const Value.absent(),
                Value<double> negativeMarking = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestsCompanion.insert(
                id: id,
                chapterId: chapterId,
                title: title,
                timeLimitMinutes: timeLimitMinutes,
                marksPerQuestion: marksPerQuestion,
                negativeMarking: negativeMarking,
                isPublished: isPublished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TestsTable, Test>(table),
                  $$TestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chapterId = false,
                testQuestionsRefs = false,
                testAttemptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (testQuestionsRefs) db.testQuestions,
                    if (testAttemptsRefs) db.testAttempts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (chapterId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.chapterId,
                            referencedTable: $$TestsTableReferences
                                ._chapterIdTable(db),
                            referencedColumn: $$TestsTableReferences
                                ._chapterIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (testQuestionsRefs)
                        await $_getPrefetchedData<
                          Test,
                          $TestsTable,
                          TestQuestion
                        >(
                          currentTable: table,
                          referencedTable: $$TestsTableReferences
                              ._testQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TestsTableReferences(
                                db,
                                table,
                                p0,
                              ).testQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.testId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (testAttemptsRefs)
                        await $_getPrefetchedData<
                          Test,
                          $TestsTable,
                          TestAttempt
                        >(
                          currentTable: table,
                          referencedTable: $$TestsTableReferences
                              ._testAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TestsTableReferences(
                                db,
                                table,
                                p0,
                              ).testAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.testId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestsTable,
      Test,
      $$TestsTableFilterComposer,
      $$TestsTableOrderingComposer,
      $$TestsTableAnnotationComposer,
      $$TestsTableCreateCompanionBuilder,
      $$TestsTableUpdateCompanionBuilder,
      (Test, $$TestsTableReferences),
      Test,
      PrefetchHooks Function({
        bool chapterId,
        bool testQuestionsRefs,
        bool testAttemptsRefs,
      })
    >;
typedef $$TestQuestionsTableCreateCompanionBuilder =
    TestQuestionsCompanion Function({
      required String id,
      required String testId,
      required String prompt,
      required String optionA,
      required String optionB,
      required String optionC,
      required String optionD,
      required String correctOption,
      Value<String> explanation,
      Value<double> marks,
      Value<int> displayOrder,
      Value<int> rowid,
    });
typedef $$TestQuestionsTableUpdateCompanionBuilder =
    TestQuestionsCompanion Function({
      Value<String> id,
      Value<String> testId,
      Value<String> prompt,
      Value<String> optionA,
      Value<String> optionB,
      Value<String> optionC,
      Value<String> optionD,
      Value<String> correctOption,
      Value<String> explanation,
      Value<double> marks,
      Value<int> displayOrder,
      Value<int> rowid,
    });

final class $$TestQuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $TestQuestionsTable, TestQuestion> {
  $$TestQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TestsTable _testIdTable(_$AppDatabase db) =>
      db.tests.createAlias('test_questions__test_id__tests__id');

  $$TestsTableProcessedTableManager get testId {
    final $_column = $_itemColumn<String>('test_id')!;

    final manager = $$TestsTableTableManager(
      $_db,
      $_db.tests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_testIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TestAttemptAnswersTable, List<TestAttemptAnswer>>
  _testAttemptAnswersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.testAttemptAnswers,
        aliasName: 'test_questions__id__test_attempt_answers__question_id',
      );

  $$TestAttemptAnswersTableProcessedTableManager get testAttemptAnswersRefs {
    final manager = $$TestAttemptAnswersTableTableManager(
      $_db,
      $_db.testAttemptAnswers,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _testAttemptAnswersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TestQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $TestQuestionsTable> {
  $$TestQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionA => $composableBuilder(
    column: $table.optionA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionB => $composableBuilder(
    column: $table.optionB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionC => $composableBuilder(
    column: $table.optionC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionD => $composableBuilder(
    column: $table.optionD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get marks => $composableBuilder(
    column: $table.marks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TestsTableFilterComposer get testId {
    final $$TestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableFilterComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> testAttemptAnswersRefs(
    Expression<bool> Function($$TestAttemptAnswersTableFilterComposer f) f,
  ) {
    final $$TestAttemptAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testAttemptAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptAnswersTableFilterComposer(
            $db: $db,
            $table: $db.testAttemptAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TestQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestQuestionsTable> {
  $$TestQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionA => $composableBuilder(
    column: $table.optionA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionB => $composableBuilder(
    column: $table.optionB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionC => $composableBuilder(
    column: $table.optionC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionD => $composableBuilder(
    column: $table.optionD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get marks => $composableBuilder(
    column: $table.marks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TestsTableOrderingComposer get testId {
    final $$TestsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableOrderingComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TestQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestQuestionsTable> {
  $$TestQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get optionA =>
      $composableBuilder(column: $table.optionA, builder: (column) => column);

  GeneratedColumn<String> get optionB =>
      $composableBuilder(column: $table.optionB, builder: (column) => column);

  GeneratedColumn<String> get optionC =>
      $composableBuilder(column: $table.optionC, builder: (column) => column);

  GeneratedColumn<String> get optionD =>
      $composableBuilder(column: $table.optionD, builder: (column) => column);

  GeneratedColumn<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<double> get marks =>
      $composableBuilder(column: $table.marks, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  $$TestsTableAnnotationComposer get testId {
    final $$TestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableAnnotationComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> testAttemptAnswersRefs<T extends Object>(
    Expression<T> Function($$TestAttemptAnswersTableAnnotationComposer a) f,
  ) {
    final $$TestAttemptAnswersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.testAttemptAnswers,
          getReferencedColumn: (t) => t.questionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TestAttemptAnswersTableAnnotationComposer(
                $db: $db,
                $table: $db.testAttemptAnswers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TestQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestQuestionsTable,
          TestQuestion,
          $$TestQuestionsTableFilterComposer,
          $$TestQuestionsTableOrderingComposer,
          $$TestQuestionsTableAnnotationComposer,
          $$TestQuestionsTableCreateCompanionBuilder,
          $$TestQuestionsTableUpdateCompanionBuilder,
          (TestQuestion, $$TestQuestionsTableReferences),
          TestQuestion,
          PrefetchHooks Function({bool testId, bool testAttemptAnswersRefs})
        > {
  $$TestQuestionsTableTableManager(_$AppDatabase db, $TestQuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> testId = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> optionA = const Value.absent(),
                Value<String> optionB = const Value.absent(),
                Value<String> optionC = const Value.absent(),
                Value<String> optionD = const Value.absent(),
                Value<String> correctOption = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<double> marks = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestQuestionsCompanion(
                id: id,
                testId: testId,
                prompt: prompt,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                correctOption: correctOption,
                explanation: explanation,
                marks: marks,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String testId,
                required String prompt,
                required String optionA,
                required String optionB,
                required String optionC,
                required String optionD,
                required String correctOption,
                Value<String> explanation = const Value.absent(),
                Value<double> marks = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestQuestionsCompanion.insert(
                id: id,
                testId: testId,
                prompt: prompt,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                correctOption: correctOption,
                explanation: explanation,
                marks: marks,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TestQuestionsTable, TestQuestion>(table),
                  $$TestQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({testId = false, testAttemptAnswersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (testAttemptAnswersRefs) db.testAttemptAnswers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (testId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.testId,
                            referencedTable: $$TestQuestionsTableReferences
                                ._testIdTable(db),
                            referencedColumn: $$TestQuestionsTableReferences
                                ._testIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (testAttemptAnswersRefs)
                        await $_getPrefetchedData<
                          TestQuestion,
                          $TestQuestionsTable,
                          TestAttemptAnswer
                        >(
                          currentTable: table,
                          referencedTable: $$TestQuestionsTableReferences
                              ._testAttemptAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TestQuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).testAttemptAnswersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TestQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestQuestionsTable,
      TestQuestion,
      $$TestQuestionsTableFilterComposer,
      $$TestQuestionsTableOrderingComposer,
      $$TestQuestionsTableAnnotationComposer,
      $$TestQuestionsTableCreateCompanionBuilder,
      $$TestQuestionsTableUpdateCompanionBuilder,
      (TestQuestion, $$TestQuestionsTableReferences),
      TestQuestion,
      PrefetchHooks Function({bool testId, bool testAttemptAnswersRefs})
    >;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  required String id,
  required String displayName,
  Value<String?> classId,
  Value<String> avatarEmoji,
  Value<String> themeMode,
  Value<DateTime> createdAt,
  Value<DateTime> lastSeenAt,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> id,
  Value<String> displayName,
  Value<String?> classId,
  Value<String> avatarEmoji,
  Value<String> themeMode,
  Value<DateTime> createdAt,
  Value<DateTime> lastSeenAt,
  Value<int> rowid,
});

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SchoolClassesTable _classIdTable(_$AppDatabase db) =>
      db.schoolClasses.createAlias('students__class_id__school_classes__id');

  $$SchoolClassesTableProcessedTableManager? get classId {
    final $_column = $_itemColumn<String>('class_id');
    if ($_column == null) return null;
    final manager = $$SchoolClassesTableTableManager(
      $_db,
      $_db.schoolClasses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BookmarksTable, List<Bookmark>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: 'students__id__bookmarks__student_id',
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecentViewsTable, List<RecentView>>
  _recentViewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recentViews,
    aliasName: 'students__id__recent_views__student_id',
  );

  $$RecentViewsTableProcessedTableManager get recentViewsRefs {
    final manager = $$RecentViewsTableTableManager(
      $_db,
      $_db.recentViews,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recentViewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LessonProgressTable, List<LessonProgressRow>>
  _lessonProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonProgress,
    aliasName: 'students__id__lesson_progress__student_id',
  );

  $$LessonProgressTableProcessedTableManager get lessonProgressRefs {
    final manager = $$LessonProgressTableTableManager(
      $_db,
      $_db.lessonProgress,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DownloadsTable, List<Download>>
  _downloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloads,
    aliasName: 'students__id__downloads__student_id',
  );

  $$DownloadsTableProcessedTableManager get downloadsRefs {
    final manager = $$DownloadsTableTableManager(
      $_db,
      $_db.downloads,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TestAttemptsTable, List<TestAttempt>>
  _testAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.testAttempts,
    aliasName: 'students__id__test_attempts__student_id',
  );

  $$TestAttemptsTableProcessedTableManager get testAttemptsRefs {
    final manager = $$TestAttemptsTableTableManager(
      $_db,
      $_db.testAttempts,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_testAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarEmoji => $composableBuilder(
    column: $table.avatarEmoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SchoolClassesTableFilterComposer get classId {
    final $$SchoolClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableFilterComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recentViewsRefs(
    Expression<bool> Function($$RecentViewsTableFilterComposer f) f,
  ) {
    final $$RecentViewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recentViews,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecentViewsTableFilterComposer(
            $db: $db,
            $table: $db.recentViews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lessonProgressRefs(
    Expression<bool> Function($$LessonProgressTableFilterComposer f) f,
  ) {
    final $$LessonProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableFilterComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadsRefs(
    Expression<bool> Function($$DownloadsTableFilterComposer f) f,
  ) {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableFilterComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> testAttemptsRefs(
    Expression<bool> Function($$TestAttemptsTableFilterComposer f) f,
  ) {
    final $$TestAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarEmoji => $composableBuilder(
    column: $table.avatarEmoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SchoolClassesTableOrderingComposer get classId {
    final $$SchoolClassesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableOrderingComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarEmoji => $composableBuilder(
    column: $table.avatarEmoji,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  $$SchoolClassesTableAnnotationComposer get classId {
    final $$SchoolClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recentViewsRefs<T extends Object>(
    Expression<T> Function($$RecentViewsTableAnnotationComposer a) f,
  ) {
    final $$RecentViewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recentViews,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecentViewsTableAnnotationComposer(
            $db: $db,
            $table: $db.recentViews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lessonProgressRefs<T extends Object>(
    Expression<T> Function($$LessonProgressTableAnnotationComposer a) f,
  ) {
    final $$LessonProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadsRefs<T extends Object>(
    Expression<T> Function($$DownloadsTableAnnotationComposer a) f,
  ) {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> testAttemptsRefs<T extends Object>(
    Expression<T> Function($$TestAttemptsTableAnnotationComposer a) f,
  ) {
    final $$TestAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, $$StudentsTableReferences),
          Student,
          PrefetchHooks Function({
            bool classId,
            bool bookmarksRefs,
            bool recentViewsRefs,
            bool lessonProgressRefs,
            bool downloadsRefs,
            bool testAttemptsRefs,
          })
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> classId = const Value.absent(),
                Value<String> avatarEmoji = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                displayName: displayName,
                classId: classId,
                avatarEmoji: avatarEmoji,
                themeMode: themeMode,
                createdAt: createdAt,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                Value<String?> classId = const Value.absent(),
                Value<String> avatarEmoji = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                displayName: displayName,
                classId: classId,
                avatarEmoji: avatarEmoji,
                themeMode: themeMode,
                createdAt: createdAt,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudentsTable, Student>(table),
                  $$StudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                classId = false,
                bookmarksRefs = false,
                recentViewsRefs = false,
                lessonProgressRefs = false,
                downloadsRefs = false,
                testAttemptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bookmarksRefs) db.bookmarks,
                    if (recentViewsRefs) db.recentViews,
                    if (lessonProgressRefs) db.lessonProgress,
                    if (downloadsRefs) db.downloads,
                    if (testAttemptsRefs) db.testAttempts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (classId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.classId,
                            referencedTable: $$StudentsTableReferences
                                ._classIdTable(db),
                            referencedColumn: $$StudentsTableReferences
                                ._classIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bookmarksRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          Bookmark
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._bookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recentViewsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          RecentView
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._recentViewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).recentViewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lessonProgressRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          LessonProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._lessonProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (downloadsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          Download
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._downloadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (testAttemptsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          TestAttempt
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._testAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).testAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, $$StudentsTableReferences),
      Student,
      PrefetchHooks Function({
        bool classId,
        bool bookmarksRefs,
        bool recentViewsRefs,
        bool lessonProgressRefs,
        bool downloadsRefs,
        bool testAttemptsRefs,
      })
    >;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String studentId,
  required String targetKind,
  required String targetId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> studentId,
  Value<String> targetKind,
  Value<String> targetId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('bookmarks__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, $$BookmarksTableReferences),
          Bookmark,
          PrefetchHooks Function({bool studentId})
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> studentId = const Value.absent(),
                Value<String> targetKind = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion(
                studentId: studentId,
                targetKind: targetKind,
                targetId: targetId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String studentId,
                required String targetKind,
                required String targetId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion.insert(
                studentId: studentId,
                targetKind: targetKind,
                targetId: targetId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, Bookmark>(table),
                  $$BookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.studentId,
                        referencedTable: $$BookmarksTableReferences
                            ._studentIdTable(db),
                        referencedColumn: $$BookmarksTableReferences
                            ._studentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, $$BookmarksTableReferences),
      Bookmark,
      PrefetchHooks Function({bool studentId})
    >;
typedef $$RecentViewsTableCreateCompanionBuilder =
    RecentViewsCompanion Function({
      required String studentId,
      required String targetKind,
      required String targetId,
      Value<DateTime> viewedAt,
      Value<int> rowid,
    });
typedef $$RecentViewsTableUpdateCompanionBuilder =
    RecentViewsCompanion Function({
      Value<String> studentId,
      Value<String> targetKind,
      Value<String> targetId,
      Value<DateTime> viewedAt,
      Value<int> rowid,
    });

final class $$RecentViewsTableReferences
    extends BaseReferences<_$AppDatabase, $RecentViewsTable, RecentView> {
  $$RecentViewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('recent_views__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecentViewsTableFilterComposer
    extends Composer<_$AppDatabase, $RecentViewsTable> {
  $$RecentViewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecentViewsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentViewsTable> {
  $$RecentViewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecentViewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentViewsTable> {
  $$RecentViewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<DateTime> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecentViewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentViewsTable,
          RecentView,
          $$RecentViewsTableFilterComposer,
          $$RecentViewsTableOrderingComposer,
          $$RecentViewsTableAnnotationComposer,
          $$RecentViewsTableCreateCompanionBuilder,
          $$RecentViewsTableUpdateCompanionBuilder,
          (RecentView, $$RecentViewsTableReferences),
          RecentView,
          PrefetchHooks Function({bool studentId})
        > {
  $$RecentViewsTableTableManager(_$AppDatabase db, $RecentViewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentViewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentViewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentViewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> studentId = const Value.absent(),
                Value<String> targetKind = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<DateTime> viewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentViewsCompanion(
                studentId: studentId,
                targetKind: targetKind,
                targetId: targetId,
                viewedAt: viewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String studentId,
                required String targetKind,
                required String targetId,
                Value<DateTime> viewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentViewsCompanion.insert(
                studentId: studentId,
                targetKind: targetKind,
                targetId: targetId,
                viewedAt: viewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecentViewsTable, RecentView>(table),
                  $$RecentViewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.studentId,
                        referencedTable: $$RecentViewsTableReferences
                            ._studentIdTable(db),
                        referencedColumn: $$RecentViewsTableReferences
                            ._studentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecentViewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentViewsTable,
      RecentView,
      $$RecentViewsTableFilterComposer,
      $$RecentViewsTableOrderingComposer,
      $$RecentViewsTableAnnotationComposer,
      $$RecentViewsTableCreateCompanionBuilder,
      $$RecentViewsTableUpdateCompanionBuilder,
      (RecentView, $$RecentViewsTableReferences),
      RecentView,
      PrefetchHooks Function({bool studentId})
    >;
typedef $$LessonProgressTableCreateCompanionBuilder =
    LessonProgressCompanion Function({
      required String studentId,
      required String lessonId,
      Value<double> percent,
      Value<bool> completed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LessonProgressTableUpdateCompanionBuilder =
    LessonProgressCompanion Function({
      Value<String> studentId,
      Value<String> lessonId,
      Value<double> percent,
      Value<bool> completed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$LessonProgressTableReferences
    extends
        BaseReferences<_$AppDatabase, $LessonProgressTable, LessonProgressRow> {
  $$LessonProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('lesson_progress__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('lesson_progress__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LessonProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonProgressTable,
          LessonProgressRow,
          $$LessonProgressTableFilterComposer,
          $$LessonProgressTableOrderingComposer,
          $$LessonProgressTableAnnotationComposer,
          $$LessonProgressTableCreateCompanionBuilder,
          $$LessonProgressTableUpdateCompanionBuilder,
          (LessonProgressRow, $$LessonProgressTableReferences),
          LessonProgressRow,
          PrefetchHooks Function({bool studentId, bool lessonId})
        > {
  $$LessonProgressTableTableManager(
    _$AppDatabase db,
    $LessonProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> studentId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<double> percent = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressCompanion(
                studentId: studentId,
                lessonId: lessonId,
                percent: percent,
                completed: completed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String studentId,
                required String lessonId,
                Value<double> percent = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressCompanion.insert(
                studentId: studentId,
                lessonId: lessonId,
                percent: percent,
                completed: completed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LessonProgressTable, LessonProgressRow>(table),
                  $$LessonProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false, lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.studentId,
                        referencedTable: $$LessonProgressTableReferences
                            ._studentIdTable(db),
                        referencedColumn: $$LessonProgressTableReferences
                            ._studentIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (lessonId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.lessonId,
                        referencedTable: $$LessonProgressTableReferences
                            ._lessonIdTable(db),
                        referencedColumn: $$LessonProgressTableReferences
                            ._lessonIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LessonProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonProgressTable,
      LessonProgressRow,
      $$LessonProgressTableFilterComposer,
      $$LessonProgressTableOrderingComposer,
      $$LessonProgressTableAnnotationComposer,
      $$LessonProgressTableCreateCompanionBuilder,
      $$LessonProgressTableUpdateCompanionBuilder,
      (LessonProgressRow, $$LessonProgressTableReferences),
      LessonProgressRow,
      PrefetchHooks Function({bool studentId, bool lessonId})
    >;
typedef $$DownloadsTableCreateCompanionBuilder = DownloadsCompanion Function({
  required String id,
  required String studentId,
  required String resourceId,
  Value<String?> localPath,
  Value<int> totalBytes,
  Value<int> downloadedBytes,
  required String status,
  Value<String?> lastError,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DownloadsTableUpdateCompanionBuilder = DownloadsCompanion Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> resourceId,
  Value<String?> localPath,
  Value<int> totalBytes,
  Value<int> downloadedBytes,
  Value<String> status,
  Value<String?> lastError,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$DownloadsTableReferences
    extends BaseReferences<_$AppDatabase, $DownloadsTable, Download> {
  $$DownloadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('downloads__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ResourcesTable _resourceIdTable(_$AppDatabase db) =>
      db.resources.createAlias('downloads__resource_id__resources__id');

  $$ResourcesTableProcessedTableManager get resourceId {
    final $_column = $_itemColumn<String>('resource_id')!;

    final manager = $$ResourcesTableTableManager(
      $_db,
      $_db.resources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_resourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DownloadsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalBytes => $composableBuilder(
    column: $table.totalBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downloadedBytes => $composableBuilder(
    column: $table.downloadedBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ResourcesTableFilterComposer get resourceId {
    final $$ResourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resourceId,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableFilterComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalBytes => $composableBuilder(
    column: $table.totalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedBytes => $composableBuilder(
    column: $table.downloadedBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ResourcesTableOrderingComposer get resourceId {
    final $$ResourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resourceId,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableOrderingComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get totalBytes => $composableBuilder(
    column: $table.totalBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get downloadedBytes => $composableBuilder(
    column: $table.downloadedBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ResourcesTableAnnotationComposer get resourceId {
    final $$ResourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resourceId,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadsTable,
          Download,
          $$DownloadsTableFilterComposer,
          $$DownloadsTableOrderingComposer,
          $$DownloadsTableAnnotationComposer,
          $$DownloadsTableCreateCompanionBuilder,
          $$DownloadsTableUpdateCompanionBuilder,
          (Download, $$DownloadsTableReferences),
          Download,
          PrefetchHooks Function({bool studentId, bool resourceId})
        > {
  $$DownloadsTableTableManager(_$AppDatabase db, $DownloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> resourceId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<int> totalBytes = const Value.absent(),
                Value<int> downloadedBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadsCompanion(
                id: id,
                studentId: studentId,
                resourceId: resourceId,
                localPath: localPath,
                totalBytes: totalBytes,
                downloadedBytes: downloadedBytes,
                status: status,
                lastError: lastError,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String resourceId,
                Value<String?> localPath = const Value.absent(),
                Value<int> totalBytes = const Value.absent(),
                Value<int> downloadedBytes = const Value.absent(),
                required String status,
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadsCompanion.insert(
                id: id,
                studentId: studentId,
                resourceId: resourceId,
                localPath: localPath,
                totalBytes: totalBytes,
                downloadedBytes: downloadedBytes,
                status: status,
                lastError: lastError,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DownloadsTable, Download>(table),
                  $$DownloadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false, resourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.studentId,
                        referencedTable: $$DownloadsTableReferences
                            ._studentIdTable(db),
                        referencedColumn: $$DownloadsTableReferences
                            ._studentIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (resourceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.resourceId,
                        referencedTable: $$DownloadsTableReferences
                            ._resourceIdTable(db),
                        referencedColumn: $$DownloadsTableReferences
                            ._resourceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DownloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadsTable,
      Download,
      $$DownloadsTableFilterComposer,
      $$DownloadsTableOrderingComposer,
      $$DownloadsTableAnnotationComposer,
      $$DownloadsTableCreateCompanionBuilder,
      $$DownloadsTableUpdateCompanionBuilder,
      (Download, $$DownloadsTableReferences),
      Download,
      PrefetchHooks Function({bool studentId, bool resourceId})
    >;
typedef $$LiveClassesTableCreateCompanionBuilder =
    LiveClassesCompanion Function({
      required String id,
      required String subjectId,
      required String title,
      Value<String> description,
      required String status,
      required DateTime scheduledStart,
      Value<DateTime?> actualStart,
      Value<DateTime?> actualEnd,
      Value<String?> youtubeUrl,
      Value<bool> isPublished,
      Value<int> rowid,
    });
typedef $$LiveClassesTableUpdateCompanionBuilder =
    LiveClassesCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> title,
      Value<String> description,
      Value<String> status,
      Value<DateTime> scheduledStart,
      Value<DateTime?> actualStart,
      Value<DateTime?> actualEnd,
      Value<String?> youtubeUrl,
      Value<bool> isPublished,
      Value<int> rowid,
    });

final class $$LiveClassesTableReferences
    extends BaseReferences<_$AppDatabase, $LiveClassesTable, LiveClass> {
  $$LiveClassesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias('live_classes__subject_id__subjects__id');

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LiveClassesTableFilterComposer
    extends Composer<_$AppDatabase, $LiveClassesTable> {
  $$LiveClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LiveClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $LiveClassesTable> {
  $$LiveClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LiveClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiveClassesTable> {
  $$LiveClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualEnd =>
      $composableBuilder(column: $table.actualEnd, builder: (column) => column);

  GeneratedColumn<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LiveClassesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LiveClassesTable,
          LiveClass,
          $$LiveClassesTableFilterComposer,
          $$LiveClassesTableOrderingComposer,
          $$LiveClassesTableAnnotationComposer,
          $$LiveClassesTableCreateCompanionBuilder,
          $$LiveClassesTableUpdateCompanionBuilder,
          (LiveClass, $$LiveClassesTableReferences),
          LiveClass,
          PrefetchHooks Function({bool subjectId})
        > {
  $$LiveClassesTableTableManager(_$AppDatabase db, $LiveClassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiveClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiveClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiveClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> scheduledStart = const Value.absent(),
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LiveClassesCompanion(
                id: id,
                subjectId: subjectId,
                title: title,
                description: description,
                status: status,
                scheduledStart: scheduledStart,
                actualStart: actualStart,
                actualEnd: actualEnd,
                youtubeUrl: youtubeUrl,
                isPublished: isPublished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String title,
                Value<String> description = const Value.absent(),
                required String status,
                required DateTime scheduledStart,
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LiveClassesCompanion.insert(
                id: id,
                subjectId: subjectId,
                title: title,
                description: description,
                status: status,
                scheduledStart: scheduledStart,
                actualStart: actualStart,
                actualEnd: actualEnd,
                youtubeUrl: youtubeUrl,
                isPublished: isPublished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LiveClassesTable, LiveClass>(table),
                  $$LiveClassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.subjectId,
                        referencedTable: $$LiveClassesTableReferences
                            ._subjectIdTable(db),
                        referencedColumn: $$LiveClassesTableReferences
                            ._subjectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LiveClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LiveClassesTable,
      LiveClass,
      $$LiveClassesTableFilterComposer,
      $$LiveClassesTableOrderingComposer,
      $$LiveClassesTableAnnotationComposer,
      $$LiveClassesTableCreateCompanionBuilder,
      $$LiveClassesTableUpdateCompanionBuilder,
      (LiveClass, $$LiveClassesTableReferences),
      LiveClass,
      PrefetchHooks Function({bool subjectId})
    >;
typedef $$AnnouncementsTableCreateCompanionBuilder =
    AnnouncementsCompanion Function({
      required String id,
      required String title,
      required String body,
      Value<String?> classId,
      Value<String> priority,
      Value<bool> isActive,
      Value<DateTime> publishedAt,
      Value<int> rowid,
    });
typedef $$AnnouncementsTableUpdateCompanionBuilder =
    AnnouncementsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> body,
      Value<String?> classId,
      Value<String> priority,
      Value<bool> isActive,
      Value<DateTime> publishedAt,
      Value<int> rowid,
    });

final class $$AnnouncementsTableReferences
    extends BaseReferences<_$AppDatabase, $AnnouncementsTable, Announcement> {
  $$AnnouncementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SchoolClassesTable _classIdTable(_$AppDatabase db) => db.schoolClasses
      .createAlias('announcements__class_id__school_classes__id');

  $$SchoolClassesTableProcessedTableManager? get classId {
    final $_column = $_itemColumn<String>('class_id');
    if ($_column == null) return null;
    final manager = $$SchoolClassesTableTableManager(
      $_db,
      $_db.schoolClasses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnouncementsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnouncementsTable> {
  $$AnnouncementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SchoolClassesTableFilterComposer get classId {
    final $$SchoolClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableFilterComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnouncementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnouncementsTable> {
  $$AnnouncementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SchoolClassesTableOrderingComposer get classId {
    final $$SchoolClassesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableOrderingComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnouncementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnouncementsTable> {
  $$AnnouncementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  $$SchoolClassesTableAnnotationComposer get classId {
    final $$SchoolClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classId,
      referencedTable: $db.schoolClasses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchoolClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.schoolClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnouncementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnouncementsTable,
          Announcement,
          $$AnnouncementsTableFilterComposer,
          $$AnnouncementsTableOrderingComposer,
          $$AnnouncementsTableAnnotationComposer,
          $$AnnouncementsTableCreateCompanionBuilder,
          $$AnnouncementsTableUpdateCompanionBuilder,
          (Announcement, $$AnnouncementsTableReferences),
          Announcement,
          PrefetchHooks Function({bool classId})
        > {
  $$AnnouncementsTableTableManager(_$AppDatabase db, $AnnouncementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnouncementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnouncementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnouncementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> classId = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnouncementsCompanion(
                id: id,
                title: title,
                body: body,
                classId: classId,
                priority: priority,
                isActive: isActive,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String body,
                Value<String?> classId = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnouncementsCompanion.insert(
                id: id,
                title: title,
                body: body,
                classId: classId,
                priority: priority,
                isActive: isActive,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnnouncementsTable, Announcement>(table),
                  $$AnnouncementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({classId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (classId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.classId,
                        referencedTable: $$AnnouncementsTableReferences
                            ._classIdTable(db),
                        referencedColumn: $$AnnouncementsTableReferences
                            ._classIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnnouncementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnouncementsTable,
      Announcement,
      $$AnnouncementsTableFilterComposer,
      $$AnnouncementsTableOrderingComposer,
      $$AnnouncementsTableAnnotationComposer,
      $$AnnouncementsTableCreateCompanionBuilder,
      $$AnnouncementsTableUpdateCompanionBuilder,
      (Announcement, $$AnnouncementsTableReferences),
      Announcement,
      PrefetchHooks Function({bool classId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$TestAttemptsTableCreateCompanionBuilder =
    TestAttemptsCompanion Function({
      required String id,
      required String testId,
      required String studentId,
      required double score,
      required double totalMarks,
      required int correctCount,
      required int wrongCount,
      Value<int> unansweredCount,
      Value<int> timeSpentSeconds,
      Value<DateTime> submittedAt,
      Value<int> rowid,
    });
typedef $$TestAttemptsTableUpdateCompanionBuilder =
    TestAttemptsCompanion Function({
      Value<String> id,
      Value<String> testId,
      Value<String> studentId,
      Value<double> score,
      Value<double> totalMarks,
      Value<int> correctCount,
      Value<int> wrongCount,
      Value<int> unansweredCount,
      Value<int> timeSpentSeconds,
      Value<DateTime> submittedAt,
      Value<int> rowid,
    });

final class $$TestAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $TestAttemptsTable, TestAttempt> {
  $$TestAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TestsTable _testIdTable(_$AppDatabase db) =>
      db.tests.createAlias('test_attempts__test_id__tests__id');

  $$TestsTableProcessedTableManager get testId {
    final $_column = $_itemColumn<String>('test_id')!;

    final manager = $$TestsTableTableManager(
      $_db,
      $_db.tests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_testIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('test_attempts__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TestAttemptAnswersTable, List<TestAttemptAnswer>>
  _testAttemptAnswersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.testAttemptAnswers,
        aliasName: 'test_attempts__id__test_attempt_answers__attempt_id',
      );

  $$TestAttemptAnswersTableProcessedTableManager get testAttemptAnswersRefs {
    final manager = $$TestAttemptAnswersTableTableManager(
      $_db,
      $_db.testAttemptAnswers,
    ).filter((f) => f.attemptId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _testAttemptAnswersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TestAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $TestAttemptsTable> {
  $$TestAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalMarks => $composableBuilder(
    column: $table.totalMarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unansweredCount => $composableBuilder(
    column: $table.unansweredCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TestsTableFilterComposer get testId {
    final $$TestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableFilterComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> testAttemptAnswersRefs(
    Expression<bool> Function($$TestAttemptAnswersTableFilterComposer f) f,
  ) {
    final $$TestAttemptAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.testAttemptAnswers,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptAnswersTableFilterComposer(
            $db: $db,
            $table: $db.testAttemptAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TestAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestAttemptsTable> {
  $$TestAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalMarks => $composableBuilder(
    column: $table.totalMarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unansweredCount => $composableBuilder(
    column: $table.unansweredCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TestsTableOrderingComposer get testId {
    final $$TestsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableOrderingComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TestAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestAttemptsTable> {
  $$TestAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get totalMarks => $composableBuilder(
    column: $table.totalMarks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unansweredCount => $composableBuilder(
    column: $table.unansweredCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  $$TestsTableAnnotationComposer get testId {
    final $$TestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.tests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestsTableAnnotationComposer(
            $db: $db,
            $table: $db.tests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> testAttemptAnswersRefs<T extends Object>(
    Expression<T> Function($$TestAttemptAnswersTableAnnotationComposer a) f,
  ) {
    final $$TestAttemptAnswersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.testAttemptAnswers,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TestAttemptAnswersTableAnnotationComposer(
                $db: $db,
                $table: $db.testAttemptAnswers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TestAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestAttemptsTable,
          TestAttempt,
          $$TestAttemptsTableFilterComposer,
          $$TestAttemptsTableOrderingComposer,
          $$TestAttemptsTableAnnotationComposer,
          $$TestAttemptsTableCreateCompanionBuilder,
          $$TestAttemptsTableUpdateCompanionBuilder,
          (TestAttempt, $$TestAttemptsTableReferences),
          TestAttempt,
          PrefetchHooks Function({
            bool testId,
            bool studentId,
            bool testAttemptAnswersRefs,
          })
        > {
  $$TestAttemptsTableTableManager(_$AppDatabase db, $TestAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> testId = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<double> totalMarks = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> wrongCount = const Value.absent(),
                Value<int> unansweredCount = const Value.absent(),
                Value<int> timeSpentSeconds = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestAttemptsCompanion(
                id: id,
                testId: testId,
                studentId: studentId,
                score: score,
                totalMarks: totalMarks,
                correctCount: correctCount,
                wrongCount: wrongCount,
                unansweredCount: unansweredCount,
                timeSpentSeconds: timeSpentSeconds,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String testId,
                required String studentId,
                required double score,
                required double totalMarks,
                required int correctCount,
                required int wrongCount,
                Value<int> unansweredCount = const Value.absent(),
                Value<int> timeSpentSeconds = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestAttemptsCompanion.insert(
                id: id,
                testId: testId,
                studentId: studentId,
                score: score,
                totalMarks: totalMarks,
                correctCount: correctCount,
                wrongCount: wrongCount,
                unansweredCount: unansweredCount,
                timeSpentSeconds: timeSpentSeconds,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TestAttemptsTable, TestAttempt>(table),
                  $$TestAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                testId = false,
                studentId = false,
                testAttemptAnswersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (testAttemptAnswersRefs) db.testAttemptAnswers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (testId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.testId,
                            referencedTable: $$TestAttemptsTableReferences
                                ._testIdTable(db),
                            referencedColumn: $$TestAttemptsTableReferences
                                ._testIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (studentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.studentId,
                            referencedTable: $$TestAttemptsTableReferences
                                ._studentIdTable(db),
                            referencedColumn: $$TestAttemptsTableReferences
                                ._studentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (testAttemptAnswersRefs)
                        await $_getPrefetchedData<
                          TestAttempt,
                          $TestAttemptsTable,
                          TestAttemptAnswer
                        >(
                          currentTable: table,
                          referencedTable: $$TestAttemptsTableReferences
                              ._testAttemptAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TestAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).testAttemptAnswersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.attemptId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TestAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestAttemptsTable,
      TestAttempt,
      $$TestAttemptsTableFilterComposer,
      $$TestAttemptsTableOrderingComposer,
      $$TestAttemptsTableAnnotationComposer,
      $$TestAttemptsTableCreateCompanionBuilder,
      $$TestAttemptsTableUpdateCompanionBuilder,
      (TestAttempt, $$TestAttemptsTableReferences),
      TestAttempt,
      PrefetchHooks Function({
        bool testId,
        bool studentId,
        bool testAttemptAnswersRefs,
      })
    >;
typedef $$TestAttemptAnswersTableCreateCompanionBuilder =
    TestAttemptAnswersCompanion Function({
      required String attemptId,
      required String questionId,
      Value<String?> selectedOption,
      Value<bool> isCorrect,
      Value<int> rowid,
    });
typedef $$TestAttemptAnswersTableUpdateCompanionBuilder =
    TestAttemptAnswersCompanion Function({
      Value<String> attemptId,
      Value<String> questionId,
      Value<String?> selectedOption,
      Value<bool> isCorrect,
      Value<int> rowid,
    });

final class $$TestAttemptAnswersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TestAttemptAnswersTable,
          TestAttemptAnswer
        > {
  $$TestAttemptAnswersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TestAttemptsTable _attemptIdTable(_$AppDatabase db) => db.testAttempts
      .createAlias('test_attempt_answers__attempt_id__test_attempts__id');

  $$TestAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<String>('attempt_id')!;

    final manager = $$TestAttemptsTableTableManager(
      $_db,
      $_db.testAttempts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TestQuestionsTable _questionIdTable(_$AppDatabase db) => db
      .testQuestions
      .createAlias('test_attempt_answers__question_id__test_questions__id');

  $$TestQuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<String>('question_id')!;

    final manager = $$TestQuestionsTableTableManager(
      $_db,
      $_db.testQuestions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TestAttemptAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $TestAttemptAnswersTable> {
  $$TestAttemptAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get selectedOption => $composableBuilder(
    column: $table.selectedOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$TestAttemptsTableFilterComposer get attemptId {
    final $$TestAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TestQuestionsTableFilterComposer get questionId {
    final $$TestQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.testQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.testQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TestAttemptAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $TestAttemptAnswersTable> {
  $$TestAttemptAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get selectedOption => $composableBuilder(
    column: $table.selectedOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$TestAttemptsTableOrderingComposer get attemptId {
    final $$TestAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TestQuestionsTableOrderingComposer get questionId {
    final $$TestQuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.testQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestQuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.testQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TestAttemptAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestAttemptAnswersTable> {
  $$TestAttemptAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get selectedOption => $composableBuilder(
    column: $table.selectedOption,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$TestAttemptsTableAnnotationComposer get attemptId {
    final $$TestAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.testAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.testAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TestQuestionsTableAnnotationComposer get questionId {
    final $$TestQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.testQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.testQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TestAttemptAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestAttemptAnswersTable,
          TestAttemptAnswer,
          $$TestAttemptAnswersTableFilterComposer,
          $$TestAttemptAnswersTableOrderingComposer,
          $$TestAttemptAnswersTableAnnotationComposer,
          $$TestAttemptAnswersTableCreateCompanionBuilder,
          $$TestAttemptAnswersTableUpdateCompanionBuilder,
          (TestAttemptAnswer, $$TestAttemptAnswersTableReferences),
          TestAttemptAnswer,
          PrefetchHooks Function({bool attemptId, bool questionId})
        > {
  $$TestAttemptAnswersTableTableManager(
    _$AppDatabase db,
    $TestAttemptAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestAttemptAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestAttemptAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestAttemptAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<String?> selectedOption = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestAttemptAnswersCompanion(
                attemptId: attemptId,
                questionId: questionId,
                selectedOption: selectedOption,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                required String questionId,
                Value<String?> selectedOption = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TestAttemptAnswersCompanion.insert(
                attemptId: attemptId,
                questionId: questionId,
                selectedOption: selectedOption,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TestAttemptAnswersTable, TestAttemptAnswer>(
                    table,
                  ),
                  $$TestAttemptAnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptId = false, questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (attemptId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.attemptId,
                        referencedTable: $$TestAttemptAnswersTableReferences
                            ._attemptIdTable(db),
                        referencedColumn: $$TestAttemptAnswersTableReferences
                            ._attemptIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (questionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.questionId,
                        referencedTable: $$TestAttemptAnswersTableReferences
                            ._questionIdTable(db),
                        referencedColumn: $$TestAttemptAnswersTableReferences
                            ._questionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TestAttemptAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestAttemptAnswersTable,
      TestAttemptAnswer,
      $$TestAttemptAnswersTableFilterComposer,
      $$TestAttemptAnswersTableOrderingComposer,
      $$TestAttemptAnswersTableAnnotationComposer,
      $$TestAttemptAnswersTableCreateCompanionBuilder,
      $$TestAttemptAnswersTableUpdateCompanionBuilder,
      (TestAttemptAnswer, $$TestAttemptAnswersTableReferences),
      TestAttemptAnswer,
      PrefetchHooks Function({bool attemptId, bool questionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchoolClassesTableTableManager get schoolClasses =>
      $$SchoolClassesTableTableManager(_db, _db.schoolClasses);
  $$BoardsTableTableManager get boards =>
      $$BoardsTableTableManager(_db, _db.boards);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$ResourcesTableTableManager get resources =>
      $$ResourcesTableTableManager(_db, _db.resources);
  $$TestsTableTableManager get tests =>
      $$TestsTableTableManager(_db, _db.tests);
  $$TestQuestionsTableTableManager get testQuestions =>
      $$TestQuestionsTableTableManager(_db, _db.testQuestions);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$RecentViewsTableTableManager get recentViews =>
      $$RecentViewsTableTableManager(_db, _db.recentViews);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(_db, _db.lessonProgress);
  $$DownloadsTableTableManager get downloads =>
      $$DownloadsTableTableManager(_db, _db.downloads);
  $$LiveClassesTableTableManager get liveClasses =>
      $$LiveClassesTableTableManager(_db, _db.liveClasses);
  $$AnnouncementsTableTableManager get announcements =>
      $$AnnouncementsTableTableManager(_db, _db.announcements);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$TestAttemptsTableTableManager get testAttempts =>
      $$TestAttemptsTableTableManager(_db, _db.testAttempts);
  $$TestAttemptAnswersTableTableManager get testAttemptAnswers =>
      $$TestAttemptAnswersTableTableManager(_db, _db.testAttemptAnswers);
}
