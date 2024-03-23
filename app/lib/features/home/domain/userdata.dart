import 'package:freezed_annotation/freezed_annotation.dart';

part 'userdata.freezed.dart';
part 'userdata.g.dart';

@freezed
class UserData with _$UserData {
  factory UserData({
    required String name,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
