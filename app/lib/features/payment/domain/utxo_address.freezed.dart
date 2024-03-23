// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utxo_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UtxoAddress _$UtxoAddressFromJson(Map<String, dynamic> json) {
  return _UtxoAddress.fromJson(json);
}

/// @nodoc
mixin _$UtxoAddress {
  String get address => throw _privateConstructorUsedError;
  BigInt get balance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UtxoAddressCopyWith<UtxoAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UtxoAddressCopyWith<$Res> {
  factory $UtxoAddressCopyWith(
          UtxoAddress value, $Res Function(UtxoAddress) then) =
      _$UtxoAddressCopyWithImpl<$Res, UtxoAddress>;
  @useResult
  $Res call({String address, BigInt balance});
}

/// @nodoc
class _$UtxoAddressCopyWithImpl<$Res, $Val extends UtxoAddress>
    implements $UtxoAddressCopyWith<$Res> {
  _$UtxoAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UtxoAddressImplCopyWith<$Res>
    implements $UtxoAddressCopyWith<$Res> {
  factory _$$UtxoAddressImplCopyWith(
          _$UtxoAddressImpl value, $Res Function(_$UtxoAddressImpl) then) =
      __$$UtxoAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, BigInt balance});
}

/// @nodoc
class __$$UtxoAddressImplCopyWithImpl<$Res>
    extends _$UtxoAddressCopyWithImpl<$Res, _$UtxoAddressImpl>
    implements _$$UtxoAddressImplCopyWith<$Res> {
  __$$UtxoAddressImplCopyWithImpl(
      _$UtxoAddressImpl _value, $Res Function(_$UtxoAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? balance = null,
  }) {
    return _then(_$UtxoAddressImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UtxoAddressImpl implements _UtxoAddress {
  const _$UtxoAddressImpl({required this.address, required this.balance});

  factory _$UtxoAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UtxoAddressImplFromJson(json);

  @override
  final String address;
  @override
  final BigInt balance;

  @override
  String toString() {
    return 'UtxoAddress(address: $address, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UtxoAddressImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, address, balance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UtxoAddressImplCopyWith<_$UtxoAddressImpl> get copyWith =>
      __$$UtxoAddressImplCopyWithImpl<_$UtxoAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UtxoAddressImplToJson(
      this,
    );
  }
}

abstract class _UtxoAddress implements UtxoAddress {
  const factory _UtxoAddress(
      {required final String address,
      required final BigInt balance}) = _$UtxoAddressImpl;

  factory _UtxoAddress.fromJson(Map<String, dynamic> json) =
      _$UtxoAddressImpl.fromJson;

  @override
  String get address;
  @override
  BigInt get balance;
  @override
  @JsonKey(ignore: true)
  _$$UtxoAddressImplCopyWith<_$UtxoAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
