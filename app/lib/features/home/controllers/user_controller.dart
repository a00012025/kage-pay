import 'package:app/features/home/domain/userdata.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@Riverpod(keepAlive: true)
class UserDataController extends _$UserDataController {
  void updateName(String name) {
    state = UserData(name: name);
  }

  @override
  UserData build() {
    return UserData(name: "");
  }
}
