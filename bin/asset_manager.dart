import 'dart:io';

import 'package:args/args.dart';

void main(List<String> arguments) {
  // find the structure of directories within asset folder
  final parser = ArgParser()..addFlag("build", negatable: false, abbr: 'b');
  final isBuild = parser.parse(arguments)['build'];
  stdout.write(isBuild);
  if (isBuild) {
    // final cwd = Directory.current.path;
    final assetDir = Directory('assets');
    final pubspecFile = File('pubspec.yaml');

    final subdirectories = assetDir.listSync();

    final openedFile = pubspecFile.openWrite(mode: FileMode.append);
    openedFile.writeln("\n  assets:");
    for (var directory in subdirectories) {
      if (directory is Directory) {
        final assetPath = directory.path;
        final subDirectories = Directory(assetPath).listSync();

        if (!assetPath.contains('fonts')) {
          openedFile.writeln("    - ${directory.path}");
        }

        for (var subDir in subDirectories) {
          final subDirPath = subDir.path;
          if (subDir is Directory) {
            if (!subDirPath.contains('fonts')) {
              openedFile.writeln("    - $subDirPath");
            }
          }
        }
      }
    }
    openedFile.writeln("  fonts:");

    for (var directory in subdirectories) {
      if (directory is Directory) {
        final assetPath = directory.path;
        final subFontDirectories = Directory(assetPath).listSync();

        if (assetPath.contains('fonts')) {
          final fontFiles = Directory(assetPath).listSync();

          for (var fontDir in subFontDirectories) {
            if (fontDir is Directory) {
              stdout.writeln(fontDir.path);
              final fontFamily = fontDir.path.split('/').last;
              openedFile.writeln("    - family: $fontFamily");
              openedFile.writeln("      fonts:");
              final fontFiles = Directory(fontDir.path).listSync();
              for (var fontFile in fontFiles) {
                final fontFileExtension =
                    fontFile.path.split('/').last.split(".").last;

                if (fontFileExtension == "ttf") {
                  final fontFilePath = fontFile.path;
                  final fontProperties =
                      fontFilePath.split('/').last.split('.').first.split('-');
                  final fontFileWeight = fontProperties.last;
                  final fontFileStyle = fontProperties[1];
                  openedFile.writeln(
                    "        - asset: $fontFilePath",
                  );
                  openedFile.writeln(
                    "          weight: $fontFileWeight",
                  );
                  openedFile.writeln(
                    "          style: ${fontFileStyle.toLowerCase()}",
                  );
                }
              }
            }
          }
        }
      }
    }
  }
}
