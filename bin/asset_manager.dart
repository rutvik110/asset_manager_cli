import 'dart:io';

import 'package:args/args.dart';
import 'package:mason_logger/mason_logger.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()..addCommand("add");
  final logger = Logger();
  final ArgResults argResults;

  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    logger.err(e.toString());
    exit(1);
  }

  if (argResults.arguments.isEmpty) {
    logger.info('''
asset_manager

Usage: asset_manager <command> [arguments]


Available commands:
  add   Generates and adds assets code into pubspec.yaml
      
      ''');
    exit(0);
  }
  final bool isBuild = argResults.command?.name == "add";

  if (!isBuild) {
    final unknownCommand = argResults.arguments[0];
    logger.err(
        "Command not found $unknownCommand\nDid you mean one of these commands?\nadd");

    exit(1);
  }

  final progress = logger.progress("Generating assets code");
  try {
    final assetDir = Directory('assets');
    final fontsDir = Directory('assets/fonts');
    final pubspecFile = File('pubspec.yaml');

    final subdirectories = assetDir.listSync();

    final openedFile = pubspecFile.readAsLinesSync();
    final addAfterLine =
        openedFile.indexWhere(((element) => element.contains("flutter:")));

    openedFile.insert(addAfterLine + 1, "\n  assets:");

    List<String> assetsString = [];
    // add assets code except fonts
    for (var i = 0; i < subdirectories.length; i++) {
      final subdirectory = subdirectories[i];
      if (subdirectory is Directory) {
        if (!subdirectory.path.contains("fonts")) {
          assetsString.add("    - ${subdirectory.path}/");

          assetsString.addAll(addToAssets(subdirectory));
        }
      }
    }

    openedFile.insertAll(addAfterLine + 2, assetsString);

    // add fonts code

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
            final fontFileExtension =
                fontFile.path.split('/').last.split(".").last;
            if (fontFileExtension == "ttf") {
              final fontFilePath = fontFile.path;
              final fontProperties =
                  fontFilePath.split('/').last.split('.').first.split('-');
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
    pubspecFile.writeAsString(openedFile.join("\n"));
    progress.complete("Assets added to pubspec.yaml");
  } catch (e) {
    progress.fail("Error: $e");
    exit(1);
  }
}

List<String> addToAssets(Directory directory) {
  List<String> assetString = [];

  final subDirectories = directory.listSync();

  for (var subDir in subDirectories) {
    if (subDir is Directory) {
      final subDirPath = subDir.path;
      if (!subDirPath.contains('fonts')) {
        assetString.add("    - $subDirPath/");
      }
      assetString.addAll(addToAssets(subDir));
    }
  }

  return assetString;
}
