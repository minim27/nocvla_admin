import 'dart:io';

class HealthReport {
  int hardcodedTexts = 0;
  int snakeCaseViolations = 0;

  int getPutCount = 0;
  int getDeleteCount = 0;

  int hardcodedSecrets = 0;
  int directRouteStrings = 0;

  final List<String> issues = [];
}

Future<void> main() async {
  final report = HealthReport();

  final dartFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((e) => e.path.endsWith('.dart'))
      .toList();

  print('');
  print('═══════════════════════════════════════');
  print('        FLUTTER HEALTH CHECK');
  print('═══════════════════════════════════════');
  print('');

  await _checkSnakeCase(dartFiles, report);
  await _checkHardcodedText(dartFiles, report);
  await _checkGetXDI(dartFiles, report);
  await _checkSecrets(dartFiles, report);
  await _checkRoutes(dartFiles, report);

  _printReport(report);
}

Future<void> _checkSnakeCase(List<File> files, HealthReport report) async {
  for (final file in files) {
    final name = file.uri.pathSegments.last;

    final valid = RegExp(r'^[a-z0-9_]+\.dart$').hasMatch(name);

    if (!valid) {
      report.snakeCaseViolations++;
      report.issues.add('File not snake_case: ${file.path}');
    }
  }
}

Future<void> _checkHardcodedText(List<File> files, HealthReport report) async {
  for (final file in files) {
    final content = await file.readAsString();

    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();

      if (!trimmed.contains('Text(')) continue;

      final hasHardcodedString =
          trimmed.contains('Text("') || trimmed.contains("Text('");

      if (hasHardcodedString) {
        report.hardcodedTexts++;
      }
    }
  }
}

Future<void> _checkGetXDI(List<File> files, HealthReport report) async {
  for (final file in files) {
    final content = await file.readAsString();

    report.getPutCount += RegExp(
      r'Get\.(put|lazyPut|putAsync)\(',
    ).allMatches(content).length;

    report.getDeleteCount += RegExp(
      r'Get\.delete\(',
    ).allMatches(content).length;
  }
}

Future<void> _checkSecrets(List<File> files, HealthReport report) async {
  final keywords = [
    'xnd_development_',
    'xnd_production_',
    'secret_key',
    'api_key',
    'bearer ',
    'authorization:',
  ];

  for (final file in files) {
    final content = (await file.readAsString()).toLowerCase();

    for (final keyword in keywords) {
      if (content.contains(keyword)) {
        report.hardcodedSecrets++;
      }
    }
  }
}

Future<void> _checkRoutes(List<File> files, HealthReport report) async {
  for (final file in files) {
    final content = await file.readAsString();

    report.directRouteStrings += "Get.toNamed('".allMatches(content).length;

    report.directRouteStrings += 'Get.toNamed("'.allMatches(content).length;
  }
}

void _printReport(HealthReport report) {
  double codeQuality = 100;

  codeQuality -= report.hardcodedTexts * 0.2;
  codeQuality -= report.snakeCaseViolations * 3;
  codeQuality -= report.hardcodedSecrets * 15;
  codeQuality -= report.directRouteStrings * 1;

  codeQuality = codeQuality.clamp(0, 100);

  double architecture = 100;

  if (report.getPutCount > 0) {
    architecture -=
        ((report.getPutCount - report.getDeleteCount) / report.getPutCount) *
        100;
  }

  architecture = architecture.clamp(0, 100);

  final overall = ((codeQuality * 0.6) + (architecture * 0.4)).round();

  final grade = _grade(overall);

  print('6. Style / Convention Conformance');
  print('');

  if (report.snakeCaseViolations > 0) {
    print('⚠ ${report.snakeCaseViolations} file(s) not snake_case');
  }

  if (report.getPutCount > 0) {
    print(
      '⚠ DI: ${report.getPutCount} registrations '
      'but only ${report.getDeleteCount} unregister calls',
    );
  }

  if (report.hardcodedTexts > 0) {
    print('⚠ ${report.hardcodedTexts} hardcoded Text() found');
  }

  if (report.hardcodedSecrets > 0) {
    print('⚠ ${report.hardcodedSecrets} potential secret(s) detected');
  }

  if (report.directRouteStrings > 0) {
    print('⚠ ${report.directRouteStrings} direct route strings detected');
  }

  print('');
  print('══════════════════════════════');
  print('OVERALL SCORECARD');
  print('══════════════════════════════');

  print('Code Quality    ${codeQuality.toStringAsFixed(0)}%');

  print('Architecture    ${architecture.toStringAsFixed(0)}%');

  print('');
  print('OVERALL HEALTH GRADE   $grade');

  print('OVERALL SCORE          $overall%');

  print('');

  if (overall < 70) {
    print('✖ BELOW THRESHOLD ($overall% < 70%)');
  } else {
    print('✔ PASSED ($overall%)');
  }

  print('');

  if (report.issues.isNotEmpty) {
    print('Top Issues');
    print('────────────');

    for (final issue in report.issues.take(20)) {
      print(issue);
    }
  }

  print('');
}

String _grade(int score) {
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  return 'D';
}
