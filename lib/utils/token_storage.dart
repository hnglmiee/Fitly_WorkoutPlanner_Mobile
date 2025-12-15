class TokenStorage {
  static String? _token;
  static String? _refreshToken;

  static void setToken(String token) {
    _token = token;
  }

  static void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
  }

  static String? get token => _token;

  static Future<String?> getAccessToken() async {
    return _token;
  }

  // ✅ LẤY REFRESH TOKEN
  static Future<String?> getRefreshToken() async {
    return _refreshToken;
  }

  // ✅ CLEAR ALL TOKEN
  static Future<void> clear() async {
    _token = null;
    _refreshToken = null;
  }
}
