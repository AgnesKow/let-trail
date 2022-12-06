import 'package:get_storage/get_storage.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class Persistent {
  static final box = GetStorage();

  static printUserObject() {
    print(box.read(Common.PersistentLoggedUser).runtimeType == UserModel
        ? "user model"
        : "from json");
  }

  static UserModel get getUser =>
      box.read(Common.PersistentLoggedUser).runtimeType == UserModel
          ? box.read(Common.PersistentLoggedUser)
          : UserModel.fromJson(box.read(Common.PersistentLoggedUser));

  static void persistUser(UserModel user) =>
      box.write(Common.PersistentLoggedUser, user);
}
