import 'package:algolia/algolia.dart';

class AlgoliaClient {
  static AlgoliaClient _cachedInstance;
  Algolia _client;

  factory AlgoliaClient() {
    if (_cachedInstance == null) {
      Algolia _algolia = Algolia.init(
        applicationId: String.fromEnvironment('ALGOLIA_ADMIN_KEY'),
        apiKey: String.fromEnvironment('ALGOLIA_SEARCH_KEY'),
      );
      _cachedInstance = AlgoliaClient._internal();
      _cachedInstance._client = _algolia;
      return _cachedInstance;
    }
    return _cachedInstance;
  }
  AlgoliaClient._internal();
}
