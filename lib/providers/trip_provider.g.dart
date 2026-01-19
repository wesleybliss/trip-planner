// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripDetailsHash() => r'2ee9fec03f2952b14e903ba7a22a20147542f1df';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TripDetails extends BuildlessAutoDisposeAsyncNotifier<Trip?> {
  late final int tripId;

  FutureOr<Trip?> build(int tripId);
}

/// See also [TripDetails].
@ProviderFor(TripDetails)
const tripDetailsProvider = TripDetailsFamily();

/// See also [TripDetails].
class TripDetailsFamily extends Family<AsyncValue<Trip?>> {
  /// See also [TripDetails].
  const TripDetailsFamily();

  /// See also [TripDetails].
  TripDetailsProvider call(int tripId) {
    return TripDetailsProvider(tripId);
  }

  @override
  TripDetailsProvider getProviderOverride(
    covariant TripDetailsProvider provider,
  ) {
    return call(provider.tripId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tripDetailsProvider';
}

/// See also [TripDetails].
class TripDetailsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TripDetails, Trip?> {
  /// See also [TripDetails].
  TripDetailsProvider(int tripId)
    : this._internal(
        () => TripDetails()..tripId = tripId,
        from: tripDetailsProvider,
        name: r'tripDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tripDetailsHash,
        dependencies: TripDetailsFamily._dependencies,
        allTransitiveDependencies: TripDetailsFamily._allTransitiveDependencies,
        tripId: tripId,
      );

  TripDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final int tripId;

  @override
  FutureOr<Trip?> runNotifierBuild(covariant TripDetails notifier) {
    return notifier.build(tripId);
  }

  @override
  Override overrideWith(TripDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: TripDetailsProvider._internal(
        () => create()..tripId = tripId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TripDetails, Trip?> createElement() {
    return _TripDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripDetailsProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripDetailsRef on AutoDisposeAsyncNotifierProviderRef<Trip?> {
  /// The parameter `tripId` of this provider.
  int get tripId;
}

class _TripDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TripDetails, Trip?>
    with TripDetailsRef {
  _TripDetailsProviderElement(super.provider);

  @override
  int get tripId => (origin as TripDetailsProvider).tripId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
