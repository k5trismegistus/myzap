import 'package:algolia/algolia.dart';import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlgoliaStore {
  static final Algolia algolia = Algolia.init(
    applicationId: DotEnv().env['ALGOLIA_ID'],
    apiKey: DotEnv().env['ALGOLIA_ADMIN_KEY'],
  );


  static Algolia getInstance() {
    return algolia.instance;
  }
}

