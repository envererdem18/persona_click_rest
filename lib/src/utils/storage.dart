import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyDid = 'personaclick_did';
  static const String _keySeance = 'personaclick_seance';

  Future<void> saveDid(String did) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDid, did);
  }

  Future<String?> getDid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDid);
  }

  Future<void> saveSeance(String seance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySeance, seance);
  }

  Future<String?> getSeance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySeance);
  }

  static const String _keySource = 'personaclick_source';
  static const String _keySourceTime = 'personaclick_source_time';

  Future<void> saveSource(String source) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySource, source);
    await prefs.setInt(_keySourceTime, DateTime.now().millisecondsSinceEpoch);
  }

  Future<String?> getSource() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySource);
  }

  Future<int?> getSourceTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySourceTime);
  }

  Future<void> clearSource() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySource);
    await prefs.remove(_keySourceTime);
  }
}
