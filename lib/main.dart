import 'package:fl_query/fl_query.dart';
import 'package:fl_query_connectivity_plus_adapter/fl_query_connectivity_plus_adapter.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  await QueryClient.initialize(
    cachePrefix: 'clinic_app',
    connectivity: FlQueryConnectivityPlusAdapter(
      pollingDuration: const Duration(seconds: 15),
    ),
  );

  runApp(
    QueryClientProvider(
      refreshOnMount: true,
      child: const MainApp(),
    ),
  );
}
