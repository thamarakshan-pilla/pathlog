// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WalksTable extends Walks with TableInfo<$WalksTable, Walk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalkStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalkStatus>($WalksTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, endedAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'walks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Walk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Walk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Walk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: $WalksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $WalksTable createAlias(String alias) {
    return $WalksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalkStatus, String, String> $converterstatus =
      const EnumNameConverter<WalkStatus>(WalkStatus.values);
}

class Walk extends DataClass implements Insertable<Walk> {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final WalkStatus status;
  const Walk({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    {
      map['status'] = Variable<String>(
        $WalksTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  WalksCompanion toCompanion(bool nullToAbsent) {
    return WalksCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
    );
  }

  factory Walk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Walk(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: $WalksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(
        $WalksTable.$converterstatus.toJson(status),
      ),
    };
  }

  Walk copyWith({
    String? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    WalkStatus? status,
  }) => Walk(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
  );
  Walk copyWithCompanion(WalksCompanion data) {
    return Walk(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Walk(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Walk &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status);
}

class WalksCompanion extends UpdateCompanion<Walk> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<WalkStatus> status;
  final Value<int> rowid;
  const WalksCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalksCompanion.insert({
    required String id,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required WalkStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<Walk> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<WalkStatus>? status,
    Value<int>? rowid,
  }) {
    return WalksCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WalksTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalksCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GpsPointsTable extends GpsPoints
    with TableInfo<$GpsPointsTable, GpsPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GpsPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walkIdMeta = const VerificationMeta('walkId');
  @override
  late final GeneratedColumn<String> walkId = GeneratedColumn<String>(
    'walk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES walks (id)',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GpsMode, String> gpsMode =
      GeneratedColumn<String>(
        'gps_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GpsMode>($GpsPointsTable.$convertergpsMode);
  static const VerificationMeta _isMockedMeta = const VerificationMeta(
    'isMocked',
  );
  @override
  late final GeneratedColumn<bool> isMocked = GeneratedColumn<bool>(
    'is_mocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncStatus>($GpsPointsTable.$convertersyncStatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walkId,
    latitude,
    longitude,
    accuracy,
    speed,
    gpsMode,
    isMocked,
    capturedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gps_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<GpsPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('walk_id')) {
      context.handle(
        _walkIdMeta,
        walkId.isAcceptableOrUnknown(data['walk_id']!, _walkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walkIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('is_mocked')) {
      context.handle(
        _isMockedMeta,
        isMocked.isAcceptableOrUnknown(data['is_mocked']!, _isMockedMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GpsPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GpsPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      walkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}walk_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      )!,
      gpsMode: $GpsPointsTable.$convertergpsMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}gps_mode'],
        )!,
      ),
      isMocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mocked'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      syncStatus: $GpsPointsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
    );
  }

  @override
  $GpsPointsTable createAlias(String alias) {
    return $GpsPointsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GpsMode, String, String> $convertergpsMode =
      const EnumNameConverter<GpsMode>(GpsMode.values);
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class GpsPoint extends DataClass implements Insertable<GpsPoint> {
  final String id;
  final String walkId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final GpsMode gpsMode;
  final bool isMocked;
  final DateTime capturedAt;
  final SyncStatus syncStatus;
  const GpsPoint({
    required this.id,
    required this.walkId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.gpsMode,
    required this.isMocked,
    required this.capturedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['walk_id'] = Variable<String>(walkId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy'] = Variable<double>(accuracy);
    map['speed'] = Variable<double>(speed);
    {
      map['gps_mode'] = Variable<String>(
        $GpsPointsTable.$convertergpsMode.toSql(gpsMode),
      );
    }
    map['is_mocked'] = Variable<bool>(isMocked);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    {
      map['sync_status'] = Variable<String>(
        $GpsPointsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    return map;
  }

  GpsPointsCompanion toCompanion(bool nullToAbsent) {
    return GpsPointsCompanion(
      id: Value(id),
      walkId: Value(walkId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracy: Value(accuracy),
      speed: Value(speed),
      gpsMode: Value(gpsMode),
      isMocked: Value(isMocked),
      capturedAt: Value(capturedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory GpsPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GpsPoint(
      id: serializer.fromJson<String>(json['id']),
      walkId: serializer.fromJson<String>(json['walkId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      speed: serializer.fromJson<double>(json['speed']),
      gpsMode: $GpsPointsTable.$convertergpsMode.fromJson(
        serializer.fromJson<String>(json['gpsMode']),
      ),
      isMocked: serializer.fromJson<bool>(json['isMocked']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      syncStatus: $GpsPointsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'walkId': serializer.toJson<String>(walkId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracy': serializer.toJson<double>(accuracy),
      'speed': serializer.toJson<double>(speed),
      'gpsMode': serializer.toJson<String>(
        $GpsPointsTable.$convertergpsMode.toJson(gpsMode),
      ),
      'isMocked': serializer.toJson<bool>(isMocked),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'syncStatus': serializer.toJson<String>(
        $GpsPointsTable.$convertersyncStatus.toJson(syncStatus),
      ),
    };
  }

  GpsPoint copyWith({
    String? id,
    String? walkId,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? speed,
    GpsMode? gpsMode,
    bool? isMocked,
    DateTime? capturedAt,
    SyncStatus? syncStatus,
  }) => GpsPoint(
    id: id ?? this.id,
    walkId: walkId ?? this.walkId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracy: accuracy ?? this.accuracy,
    speed: speed ?? this.speed,
    gpsMode: gpsMode ?? this.gpsMode,
    isMocked: isMocked ?? this.isMocked,
    capturedAt: capturedAt ?? this.capturedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  GpsPoint copyWithCompanion(GpsPointsCompanion data) {
    return GpsPoint(
      id: data.id.present ? data.id.value : this.id,
      walkId: data.walkId.present ? data.walkId.value : this.walkId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      speed: data.speed.present ? data.speed.value : this.speed,
      gpsMode: data.gpsMode.present ? data.gpsMode.value : this.gpsMode,
      isMocked: data.isMocked.present ? data.isMocked.value : this.isMocked,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GpsPoint(')
          ..write('id: $id, ')
          ..write('walkId: $walkId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('speed: $speed, ')
          ..write('gpsMode: $gpsMode, ')
          ..write('isMocked: $isMocked, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walkId,
    latitude,
    longitude,
    accuracy,
    speed,
    gpsMode,
    isMocked,
    capturedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GpsPoint &&
          other.id == this.id &&
          other.walkId == this.walkId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.speed == this.speed &&
          other.gpsMode == this.gpsMode &&
          other.isMocked == this.isMocked &&
          other.capturedAt == this.capturedAt &&
          other.syncStatus == this.syncStatus);
}

class GpsPointsCompanion extends UpdateCompanion<GpsPoint> {
  final Value<String> id;
  final Value<String> walkId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracy;
  final Value<double> speed;
  final Value<GpsMode> gpsMode;
  final Value<bool> isMocked;
  final Value<DateTime> capturedAt;
  final Value<SyncStatus> syncStatus;
  final Value<int> rowid;
  const GpsPointsCompanion({
    this.id = const Value.absent(),
    this.walkId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.speed = const Value.absent(),
    this.gpsMode = const Value.absent(),
    this.isMocked = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GpsPointsCompanion.insert({
    required String id,
    required String walkId,
    required double latitude,
    required double longitude,
    required double accuracy,
    this.speed = const Value.absent(),
    required GpsMode gpsMode,
    this.isMocked = const Value.absent(),
    required DateTime capturedAt,
    required SyncStatus syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       walkId = Value(walkId),
       latitude = Value(latitude),
       longitude = Value(longitude),
       accuracy = Value(accuracy),
       gpsMode = Value(gpsMode),
       capturedAt = Value(capturedAt),
       syncStatus = Value(syncStatus);
  static Insertable<GpsPoint> custom({
    Expression<String>? id,
    Expression<String>? walkId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<double>? speed,
    Expression<String>? gpsMode,
    Expression<bool>? isMocked,
    Expression<DateTime>? capturedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walkId != null) 'walk_id': walkId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (speed != null) 'speed': speed,
      if (gpsMode != null) 'gps_mode': gpsMode,
      if (isMocked != null) 'is_mocked': isMocked,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GpsPointsCompanion copyWith({
    Value<String>? id,
    Value<String>? walkId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? accuracy,
    Value<double>? speed,
    Value<GpsMode>? gpsMode,
    Value<bool>? isMocked,
    Value<DateTime>? capturedAt,
    Value<SyncStatus>? syncStatus,
    Value<int>? rowid,
  }) {
    return GpsPointsCompanion(
      id: id ?? this.id,
      walkId: walkId ?? this.walkId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      gpsMode: gpsMode ?? this.gpsMode,
      isMocked: isMocked ?? this.isMocked,
      capturedAt: capturedAt ?? this.capturedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (walkId.present) {
      map['walk_id'] = Variable<String>(walkId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (gpsMode.present) {
      map['gps_mode'] = Variable<String>(
        $GpsPointsTable.$convertergpsMode.toSql(gpsMode.value),
      );
    }
    if (isMocked.present) {
      map['is_mocked'] = Variable<bool>(isMocked.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $GpsPointsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GpsPointsCompanion(')
          ..write('id: $id, ')
          ..write('walkId: $walkId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('speed: $speed, ')
          ..write('gpsMode: $gpsMode, ')
          ..write('isMocked: $isMocked, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventLogsTable extends EventLogs
    with TableInfo<$EventLogsTable, EventLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walkIdMeta = const VerificationMeta('walkId');
  @override
  late final GeneratedColumn<String> walkId = GeneratedColumn<String>(
    'walk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES walks (id)',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncStatus>($EventLogsTable.$convertersyncStatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walkId,
    eventType,
    payload,
    createdAt,
    retryCount,
    errorMessage,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('walk_id')) {
      context.handle(
        _walkIdMeta,
        walkId.isAcceptableOrUnknown(data['walk_id']!, _walkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walkIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      walkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}walk_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      syncStatus: $EventLogsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
    );
  }

  @override
  $EventLogsTable createAlias(String alias) {
    return $EventLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class EventLog extends DataClass implements Insertable<EventLog> {
  final String id;
  final String walkId;
  final String eventType;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String? errorMessage;
  final SyncStatus syncStatus;
  const EventLog({
    required this.id,
    required this.walkId,
    required this.eventType,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
    this.errorMessage,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['walk_id'] = Variable<String>(walkId);
    map['event_type'] = Variable<String>(eventType);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    {
      map['sync_status'] = Variable<String>(
        $EventLogsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    return map;
  }

  EventLogsCompanion toCompanion(bool nullToAbsent) {
    return EventLogsCompanion(
      id: Value(id),
      walkId: Value(walkId),
      eventType: Value(eventType),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      syncStatus: Value(syncStatus),
    );
  }

  factory EventLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventLog(
      id: serializer.fromJson<String>(json['id']),
      walkId: serializer.fromJson<String>(json['walkId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      syncStatus: $EventLogsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'walkId': serializer.toJson<String>(walkId),
      'eventType': serializer.toJson<String>(eventType),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'syncStatus': serializer.toJson<String>(
        $EventLogsTable.$convertersyncStatus.toJson(syncStatus),
      ),
    };
  }

  EventLog copyWith({
    String? id,
    String? walkId,
    String? eventType,
    String? payload,
    DateTime? createdAt,
    int? retryCount,
    Value<String?> errorMessage = const Value.absent(),
    SyncStatus? syncStatus,
  }) => EventLog(
    id: id ?? this.id,
    walkId: walkId ?? this.walkId,
    eventType: eventType ?? this.eventType,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  EventLog copyWithCompanion(EventLogsCompanion data) {
    return EventLog(
      id: data.id.present ? data.id.value : this.id,
      walkId: data.walkId.present ? data.walkId.value : this.walkId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventLog(')
          ..write('id: $id, ')
          ..write('walkId: $walkId, ')
          ..write('eventType: $eventType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walkId,
    eventType,
    payload,
    createdAt,
    retryCount,
    errorMessage,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventLog &&
          other.id == this.id &&
          other.walkId == this.walkId &&
          other.eventType == this.eventType &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage &&
          other.syncStatus == this.syncStatus);
}

class EventLogsCompanion extends UpdateCompanion<EventLog> {
  final Value<String> id;
  final Value<String> walkId;
  final Value<String> eventType;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<SyncStatus> syncStatus;
  final Value<int> rowid;
  const EventLogsCompanion({
    this.id = const Value.absent(),
    this.walkId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventLogsCompanion.insert({
    required String id,
    required String walkId,
    required String eventType,
    required String payload,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required SyncStatus syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       walkId = Value(walkId),
       eventType = Value(eventType),
       payload = Value(payload),
       createdAt = Value(createdAt),
       syncStatus = Value(syncStatus);
  static Insertable<EventLog> custom({
    Expression<String>? id,
    Expression<String>? walkId,
    Expression<String>? eventType,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walkId != null) 'walk_id': walkId,
      if (eventType != null) 'event_type': eventType,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? walkId,
    Value<String>? eventType,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String?>? errorMessage,
    Value<SyncStatus>? syncStatus,
    Value<int>? rowid,
  }) {
    return EventLogsCompanion(
      id: id ?? this.id,
      walkId: walkId ?? this.walkId,
      eventType: eventType ?? this.eventType,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (walkId.present) {
      map['walk_id'] = Variable<String>(walkId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $EventLogsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventLogsCompanion(')
          ..write('id: $id, ')
          ..write('walkId: $walkId, ')
          ..write('eventType: $eventType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WalksTable walks = $WalksTable(this);
  late final $GpsPointsTable gpsPoints = $GpsPointsTable(this);
  late final $EventLogsTable eventLogs = $EventLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    walks,
    gpsPoints,
    eventLogs,
  ];
}

typedef $$WalksTableCreateCompanionBuilder =
    WalksCompanion Function({
      required String id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required WalkStatus status,
      Value<int> rowid,
    });
typedef $$WalksTableUpdateCompanionBuilder =
    WalksCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<WalkStatus> status,
      Value<int> rowid,
    });

final class $$WalksTableReferences
    extends BaseReferences<_$AppDatabase, $WalksTable, Walk> {
  $$WalksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GpsPointsTable, List<GpsPoint>>
  _gpsPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gpsPoints,
    aliasName: $_aliasNameGenerator(db.walks.id, db.gpsPoints.walkId),
  );

  $$GpsPointsTableProcessedTableManager get gpsPointsRefs {
    final manager = $$GpsPointsTableTableManager(
      $_db,
      $_db.gpsPoints,
    ).filter((f) => f.walkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gpsPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventLogsTable, List<EventLog>>
  _eventLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventLogs,
    aliasName: $_aliasNameGenerator(db.walks.id, db.eventLogs.walkId),
  );

  $$EventLogsTableProcessedTableManager get eventLogsRefs {
    final manager = $$EventLogsTableTableManager(
      $_db,
      $_db.eventLogs,
    ).filter((f) => f.walkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WalksTableFilterComposer extends Composer<_$AppDatabase, $WalksTable> {
  $$WalksTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalkStatus, WalkStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> gpsPointsRefs(
    Expression<bool> Function($$GpsPointsTableFilterComposer f) f,
  ) {
    final $$GpsPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gpsPoints,
      getReferencedColumn: (t) => t.walkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsPointsTableFilterComposer(
            $db: $db,
            $table: $db.gpsPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventLogsRefs(
    Expression<bool> Function($$EventLogsTableFilterComposer f) f,
  ) {
    final $$EventLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventLogs,
      getReferencedColumn: (t) => t.walkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventLogsTableFilterComposer(
            $db: $db,
            $table: $db.eventLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WalksTableOrderingComposer
    extends Composer<_$AppDatabase, $WalksTable> {
  $$WalksTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalksTable> {
  $$WalksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalkStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> gpsPointsRefs<T extends Object>(
    Expression<T> Function($$GpsPointsTableAnnotationComposer a) f,
  ) {
    final $$GpsPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gpsPoints,
      getReferencedColumn: (t) => t.walkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.gpsPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventLogsRefs<T extends Object>(
    Expression<T> Function($$EventLogsTableAnnotationComposer a) f,
  ) {
    final $$EventLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventLogs,
      getReferencedColumn: (t) => t.walkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.eventLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WalksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalksTable,
          Walk,
          $$WalksTableFilterComposer,
          $$WalksTableOrderingComposer,
          $$WalksTableAnnotationComposer,
          $$WalksTableCreateCompanionBuilder,
          $$WalksTableUpdateCompanionBuilder,
          (Walk, $$WalksTableReferences),
          Walk,
          PrefetchHooks Function({bool gpsPointsRefs, bool eventLogsRefs})
        > {
  $$WalksTableTableManager(_$AppDatabase db, $WalksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<WalkStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalksCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required WalkStatus status,
                Value<int> rowid = const Value.absent(),
              }) => WalksCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$WalksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({gpsPointsRefs = false, eventLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gpsPointsRefs) db.gpsPoints,
                    if (eventLogsRefs) db.eventLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gpsPointsRefs)
                        await $_getPrefetchedData<Walk, $WalksTable, GpsPoint>(
                          currentTable: table,
                          referencedTable: $$WalksTableReferences
                              ._gpsPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WalksTableReferences(
                                db,
                                table,
                                p0,
                              ).gpsPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.walkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventLogsRefs)
                        await $_getPrefetchedData<Walk, $WalksTable, EventLog>(
                          currentTable: table,
                          referencedTable: $$WalksTableReferences
                              ._eventLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WalksTableReferences(
                                db,
                                table,
                                p0,
                              ).eventLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.walkId == item.id,
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

typedef $$WalksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalksTable,
      Walk,
      $$WalksTableFilterComposer,
      $$WalksTableOrderingComposer,
      $$WalksTableAnnotationComposer,
      $$WalksTableCreateCompanionBuilder,
      $$WalksTableUpdateCompanionBuilder,
      (Walk, $$WalksTableReferences),
      Walk,
      PrefetchHooks Function({bool gpsPointsRefs, bool eventLogsRefs})
    >;
typedef $$GpsPointsTableCreateCompanionBuilder =
    GpsPointsCompanion Function({
      required String id,
      required String walkId,
      required double latitude,
      required double longitude,
      required double accuracy,
      Value<double> speed,
      required GpsMode gpsMode,
      Value<bool> isMocked,
      required DateTime capturedAt,
      required SyncStatus syncStatus,
      Value<int> rowid,
    });
typedef $$GpsPointsTableUpdateCompanionBuilder =
    GpsPointsCompanion Function({
      Value<String> id,
      Value<String> walkId,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> accuracy,
      Value<double> speed,
      Value<GpsMode> gpsMode,
      Value<bool> isMocked,
      Value<DateTime> capturedAt,
      Value<SyncStatus> syncStatus,
      Value<int> rowid,
    });

final class $$GpsPointsTableReferences
    extends BaseReferences<_$AppDatabase, $GpsPointsTable, GpsPoint> {
  $$GpsPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WalksTable _walkIdTable(_$AppDatabase db) => db.walks.createAlias(
    $_aliasNameGenerator(db.gpsPoints.walkId, db.walks.id),
  );

  $$WalksTableProcessedTableManager get walkId {
    final $_column = $_itemColumn<String>('walk_id')!;

    final manager = $$WalksTableTableManager(
      $_db,
      $_db.walks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GpsPointsTableFilterComposer
    extends Composer<_$AppDatabase, $GpsPointsTable> {
  $$GpsPointsTableFilterComposer({
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

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GpsMode, GpsMode, String> get gpsMode =>
      $composableBuilder(
        column: $table.gpsMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isMocked => $composableBuilder(
    column: $table.isMocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$WalksTableFilterComposer get walkId {
    final $$WalksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walkId,
      referencedTable: $db.walks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalksTableFilterComposer(
            $db: $db,
            $table: $db.walks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GpsPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $GpsPointsTable> {
  $$GpsPointsTableOrderingComposer({
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

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpsMode => $composableBuilder(
    column: $table.gpsMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMocked => $composableBuilder(
    column: $table.isMocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$WalksTableOrderingComposer get walkId {
    final $$WalksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walkId,
      referencedTable: $db.walks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalksTableOrderingComposer(
            $db: $db,
            $table: $db.walks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GpsPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GpsPointsTable> {
  $$GpsPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GpsMode, String> get gpsMode =>
      $composableBuilder(column: $table.gpsMode, builder: (column) => column);

  GeneratedColumn<bool> get isMocked =>
      $composableBuilder(column: $table.isMocked, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  $$WalksTableAnnotationComposer get walkId {
    final $$WalksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walkId,
      referencedTable: $db.walks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalksTableAnnotationComposer(
            $db: $db,
            $table: $db.walks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GpsPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GpsPointsTable,
          GpsPoint,
          $$GpsPointsTableFilterComposer,
          $$GpsPointsTableOrderingComposer,
          $$GpsPointsTableAnnotationComposer,
          $$GpsPointsTableCreateCompanionBuilder,
          $$GpsPointsTableUpdateCompanionBuilder,
          (GpsPoint, $$GpsPointsTableReferences),
          GpsPoint,
          PrefetchHooks Function({bool walkId})
        > {
  $$GpsPointsTableTableManager(_$AppDatabase db, $GpsPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GpsPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GpsPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GpsPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> walkId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> accuracy = const Value.absent(),
                Value<double> speed = const Value.absent(),
                Value<GpsMode> gpsMode = const Value.absent(),
                Value<bool> isMocked = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GpsPointsCompanion(
                id: id,
                walkId: walkId,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                speed: speed,
                gpsMode: gpsMode,
                isMocked: isMocked,
                capturedAt: capturedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String walkId,
                required double latitude,
                required double longitude,
                required double accuracy,
                Value<double> speed = const Value.absent(),
                required GpsMode gpsMode,
                Value<bool> isMocked = const Value.absent(),
                required DateTime capturedAt,
                required SyncStatus syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => GpsPointsCompanion.insert(
                id: id,
                walkId: walkId,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                speed: speed,
                gpsMode: gpsMode,
                isMocked: isMocked,
                capturedAt: capturedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GpsPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({walkId = false}) {
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
                    if (walkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.walkId,
                                referencedTable: $$GpsPointsTableReferences
                                    ._walkIdTable(db),
                                referencedColumn: $$GpsPointsTableReferences
                                    ._walkIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$GpsPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GpsPointsTable,
      GpsPoint,
      $$GpsPointsTableFilterComposer,
      $$GpsPointsTableOrderingComposer,
      $$GpsPointsTableAnnotationComposer,
      $$GpsPointsTableCreateCompanionBuilder,
      $$GpsPointsTableUpdateCompanionBuilder,
      (GpsPoint, $$GpsPointsTableReferences),
      GpsPoint,
      PrefetchHooks Function({bool walkId})
    >;
typedef $$EventLogsTableCreateCompanionBuilder =
    EventLogsCompanion Function({
      required String id,
      required String walkId,
      required String eventType,
      required String payload,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<String?> errorMessage,
      required SyncStatus syncStatus,
      Value<int> rowid,
    });
typedef $$EventLogsTableUpdateCompanionBuilder =
    EventLogsCompanion Function({
      Value<String> id,
      Value<String> walkId,
      Value<String> eventType,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> errorMessage,
      Value<SyncStatus> syncStatus,
      Value<int> rowid,
    });

final class $$EventLogsTableReferences
    extends BaseReferences<_$AppDatabase, $EventLogsTable, EventLog> {
  $$EventLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WalksTable _walkIdTable(_$AppDatabase db) => db.walks.createAlias(
    $_aliasNameGenerator(db.eventLogs.walkId, db.walks.id),
  );

  $$WalksTableProcessedTableManager get walkId {
    final $_column = $_itemColumn<String>('walk_id')!;

    final manager = $$WalksTableTableManager(
      $_db,
      $_db.walks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventLogsTableFilterComposer
    extends Composer<_$AppDatabase, $EventLogsTable> {
  $$EventLogsTableFilterComposer({
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

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$WalksTableFilterComposer get walkId {
    final $$WalksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walkId,
      referencedTable: $db.walks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalksTableFilterComposer(
            $db: $db,
            $table: $db.walks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventLogsTable> {
  $$EventLogsTableOrderingComposer({
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

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$WalksTableOrderingComposer get walkId {
    final $$WalksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walkId,
      referencedTable: $db.walks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalksTableOrderingComposer(
            $db: $db,
            $table: $db.walks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventLogsTable> {
  $$EventLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  $$WalksTableAnnotationComposer get walkId {
    final $$WalksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walkId,
      referencedTable: $db.walks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalksTableAnnotationComposer(
            $db: $db,
            $table: $db.walks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventLogsTable,
          EventLog,
          $$EventLogsTableFilterComposer,
          $$EventLogsTableOrderingComposer,
          $$EventLogsTableAnnotationComposer,
          $$EventLogsTableCreateCompanionBuilder,
          $$EventLogsTableUpdateCompanionBuilder,
          (EventLog, $$EventLogsTableReferences),
          EventLog,
          PrefetchHooks Function({bool walkId})
        > {
  $$EventLogsTableTableManager(_$AppDatabase db, $EventLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> walkId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventLogsCompanion(
                id: id,
                walkId: walkId,
                eventType: eventType,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                errorMessage: errorMessage,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String walkId,
                required String eventType,
                required String payload,
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required SyncStatus syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => EventLogsCompanion.insert(
                id: id,
                walkId: walkId,
                eventType: eventType,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                errorMessage: errorMessage,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({walkId = false}) {
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
                    if (walkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.walkId,
                                referencedTable: $$EventLogsTableReferences
                                    ._walkIdTable(db),
                                referencedColumn: $$EventLogsTableReferences
                                    ._walkIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$EventLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventLogsTable,
      EventLog,
      $$EventLogsTableFilterComposer,
      $$EventLogsTableOrderingComposer,
      $$EventLogsTableAnnotationComposer,
      $$EventLogsTableCreateCompanionBuilder,
      $$EventLogsTableUpdateCompanionBuilder,
      (EventLog, $$EventLogsTableReferences),
      EventLog,
      PrefetchHooks Function({bool walkId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WalksTableTableManager get walks =>
      $$WalksTableTableManager(_db, _db.walks);
  $$GpsPointsTableTableManager get gpsPoints =>
      $$GpsPointsTableTableManager(_db, _db.gpsPoints);
  $$EventLogsTableTableManager get eventLogs =>
      $$EventLogsTableTableManager(_db, _db.eventLogs);
}
