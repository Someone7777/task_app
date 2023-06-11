import 'package:task_app/config/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:task_app/config/local_db_client.dart';
import 'package:task_app/config/local_preferences_client.dart';
import 'package:task_app/src/features/auth/infrastructure/datasources/local/user_local_data_source.dart';

///
/// Infrastructure dependencies
///
///
/// Exposes [LocalPreferencesClient] instance
final localPreferencesClientProvider =
    Provider((ref) => LocalPreferencesClient());

/// Exposes [LocalDbClient] instance
final localDbClientProvider =
    Provider((ref) => LocalDbClient(
      tableNames: {
          UserLocalDataSource.tableName,
      }, 
      dbName: 'taskDb'
    ));

/// Exposes [ApiClient] instance
final apiClientProvider = Provider((ref) => ApiClient());

/// Triggered from bootstrap() to complete futures
Future<void> initializeProviders(ProviderContainer container) async {
  usePathUrlStrategy();

  /// Core
  container.read(localPreferencesClientProvider);
  //container.read(localDbClientProvider);
  container.read(apiClientProvider);
}