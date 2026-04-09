// 缓存管理类
import 'package:shared_preferences/shared_preferences.dart';

class HiCacke {
  SharedPreferences? prefs;
  HiCacke._() {
    init();
  }

  static HiCacke? _instance;
  static HiCacke? getInstance() {
    _instance ??= HiCacke._();
    return _instance;
  }

  HiCacke._pre(SharedPreferences this.prefs);
  // 预初始化，防止使用get时为进行初始化
  static Future<HiCacke?> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCacke._pre(prefs);
    }
    return _instance;
  }

  void init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  T? get<T>(String key){
    return prefs?.get(key) as T;
  }
}
