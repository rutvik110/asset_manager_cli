import 'dart:io';

import 'package:args/args.dart';
import 'package:asset_manager_cli/src/version.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:path/path.dart' as p;

final pubUpdater = PubUpdater();

Future<void> checkForUpdate() async {
  // Create an instance of PubUpdater

  // Check whether or not packageVersion is the latest version of asset_manager_cli
  final isUpToDate = await pubUpdater.isUpToDate(
    packageName: 'asset_manager_cli',
    currentVersion: packageVersion,
  );

  // Trigger an upgrade to the latest version if asset_manager_cli is not up to date
  if (!isUpToDate) {
    await pubUpdater.update(packageName: 'asset_manager_cli');
  }
}

void commandNotFound(String commands, ArgResults argResults, Logger logger) async {
  final unknownCommand = argResults.arguments[0];
  logger.err("Command not found $unknownCommand\nDid you mean one of these commands?\n$commands");
  await checkForUpdate();
  exit(1);
}

String commandsWithInfoString = '''
  add       Generates and adds assets code into pubspec.yaml
  update    Updates asset_manager_cli to the latest version 
''';

void addAssetsCode(Logger logger) async {
  final progress = logger.progress("Generating assets code");
  try {
    final assetDir = Directory('assets');
    final fontsDir = Directory(p.joinAll(['assets', 'fonts']));
    final pubspecFile = File('pubspec.yaml');

    final openedFile = pubspecFile.readAsLinesSync();
    final addAfterLine = openedFile.indexWhere(((element) => element == "flutter:"));

    openedFile.insert(addAfterLine + 1, "\n  assets:");

    List<String> assetsString = [];
    // add assets code except fonts
    assetsString.add(generateAssetDirPath("assets/"));
    assetsString.addAll(generateDirAssetsCode(assetDir));

    openedFile.insertAll(addAfterLine + 2, assetsString);

    // add fonts code

    if (fontsDir.existsSync()) {
      openedFile.insert(addAfterLine + 2 + assetsString.length, "\n  fonts:");

      final fonts = fontsDir.listSync();
      List<String> fontsString = [];

      for (var font in fonts) {
        if (font is Directory) {
          final fontFamily = font.path.split('/').last;
          fontsString.add("    - family: $fontFamily");
          fontsString.add("      fonts:");
          final fontFiles = Directory(font.path).listSync();
          for (var fontFile in fontFiles) {
            if (fontFile is File) {
              final fontFileExtension = fontFile.path.split('/').last.split(".").last;
              if (fontFileExtension == "ttf") {
                final fontFilePath = fontFile.path;
                final fontProperties = fontFilePath.split('/').last.split('.').first.split('-');
                final fontFileWeight = fontProperties.last;
                final fontFileStyle = fontProperties[1].toLowerCase();
                fontsString.add(
                  "        - asset: $fontFilePath",
                );
                fontsString.add(
                  "          weight: $fontFileWeight",
                );
                if (fontFileStyle != "regular") {
                  fontsString.add(
                    "          style: $fontFileStyle",
                  );
                }
              }
            }
          }
        }
      }

      openedFile.insertAll(addAfterLine + 3 + assetsString.length, fontsString);
    }
    pubspecFile.writeAsString(openedFile.join("\n"));
    progress.complete("Assets added to pubspec.yaml");
    await checkForUpdate();
    exit(0);
  } catch (e) {
    progress.fail("Error: $e");
    await checkForUpdate();
    exit(1);
  }
}

List<String> generateDirAssetsCode(Directory directory) {
  List<String> assetString = [];

  final subDirectories = directory.listSync();

  for (var subDir in subDirectories) {
    if (subDir is Directory) {
      final subDirPath = "${Uri.file(subDir.path).toFilePath(windows: false)}/";
      if (!subDirPath.contains('fonts')) {
        assetString.add(generateAssetDirPath(subDirPath));
      }
      assetString.addAll(generateDirAssetsCode(subDir));
    }
  }

  return assetString;
}

Future<void> updateCLI() async {
  await pubUpdater.update(packageName: "asset_manager_cli");
}

String generateAssetDirPath(String path) {
  return "    - $path";
}
