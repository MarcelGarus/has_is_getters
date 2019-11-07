import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';

import 'src/plugin.dart';

void start(List<String> args, SendPort sendPort) {
  ServerPluginStarter(
          HasIsGettersAnalyzerPlugin(PhysicalResourceProvider.INSTANCE))
      .start(sendPort);
}
