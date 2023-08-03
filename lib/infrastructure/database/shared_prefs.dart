import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal() {
    init(); // Call the init() method inside the constructor
  }

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> set(String key, dynamic value) async {
    assert(
      value is bool || value is double || value is int || value is String,
      'Unsupported type',
    );

    final Map<Type, Function> typeResolvers = {
      bool: _sharedPrefs!.setBool,
      double: _sharedPrefs!.setDouble,
      int: _sharedPrefs!.setInt,
      String: _sharedPrefs!.setString,
    };

    await init(); // Ensure that _sharedPrefs is initialized before using it

    return typeResolvers[value.runtimeType]!(key, value);
  }

  dynamic get(String key) => _sharedPrefs?.get(key);

  Future<bool> remove(String key) async {
    await init(); // Ensure that _sharedPrefs is initialized before using it
    return _sharedPrefs!.remove(key);
  }
}
// By adding the init() method call in the constructor, the _sharedPrefs instance will be initialized when the SharedPrefs object is created, and the "Null check operator used on a null value" error should be resolved.





