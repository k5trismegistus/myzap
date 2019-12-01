import 'package:algolia/algolia.dart';import 'package:flutter_dotenv/flutter_dotenv.dart';


Algolia algoliaClient = Algolia.init(
  applicationId: DotEnv().env['ALGOLIA_ADMIN_KEY'],
  apiKey: DotEnv().env['ALGOLIA_SEARCH_KEY'],
).instance;
