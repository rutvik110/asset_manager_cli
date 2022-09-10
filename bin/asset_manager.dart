import 'dart:io';

import 'package:args/args.dart';
import 'package:asset_manager_cli/asset_manager_cli.dart';
import 'package:mason_logger/mason_logger.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand("add")
    ..addCommand("update");

  final logger = Logger();

  final ArgResults argResults;

  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    logger.err(e.toString());
    await checkForUpdate();
    exit(1);
  }

  if (argResults.arguments.isEmpty) {
    logger.info('''
asset_manager

Usage: asset_manager <command> [arguments]


Available commands:
$commandsWithInfoString
      ''');
    exit(0);
  }

  switch (argResults.command?.name) {
    case "add":
      addAssetsCode(logger);
      break;
    case "update":
      updateCLI();
      break;
    default:
      commandNotFound(commandsWithInfoString, argResults, logger);
  }
}
