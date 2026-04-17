import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wolkarutils/wolkarutils.dart';

/// This Interface was made to be implemented as a `DataService` singleton
abstract class DataServiceInterface {
  /// Current data path
  String? _path;

  // Must be implemented

  Future<void> initWebDirectory();

  Future<bool> writeWebFile();

  Future<String> readWebFile();

  // Already implemented methods

  /// Initializes directories
  ///
  /// [directoryName] is the name of the folder where the data must be saved
  Future<void> initDirectories(String directoryName) async {
    switch (WolkarUtils.instance.device) {
      case Device.web:
        await initWebDirectory();
        break;
      case Device.android:
        await _initAndroidDir();
        break;
      case Device.linux:
        await _initDesktopDir(directoryName = directoryName);
        break;
      case Device.windows:
        await _initDesktopDir(directoryName = directoryName);
        break;
      default:
        break;
    }
    debugPrint('📁 Init directories triggered: $_path');
  }

  /// Writes a file
  ///
  /// [name] is the file name and
  /// [data] is the content to write in the file
  /// [ext] is the file extension. by default `json`.
  ///
  /// Returns `true` if the file was written successfully, `false` otherwise
  Future<bool> writeFile(String name, String data, {String? ext = "json"}) async {
    try {
      // Check if path does not exist
      if (_path == null) throw Exception("Path is null.");

      // Saves for web devices
      if (WolkarUtils.instance.device == Device.web) {
        final bool result = await writeWebFile();
        if (!result) throw Exception("🛑 Unable to save web data.");
        debugPrint('💾 Web data saved successfully');
        return true;
      }

      // Saves for android, linux and windows
      if ([Device.android, Device.linux, Device.windows].contains(WolkarUtils.instance.device)) {
        File file = await File("${_path!}/$name/$ext").create(recursive: true);
        await file.writeAsString(data, flush: true);
        debugPrint('💾 Data saved successfully');
        return true;
      }

      throw ("🛑 Current device did not match any of the available devices.");
    } catch (e) {
      debugPrint('❌ An error occurred writing file: $e');
      return false;
    }
  }

  /// Reads a file
  ///
  /// [name] is the file name and
  /// [ext] is the file extension. by default `json`.
  ///
  /// Returns the content as [String]
  Future<String> readFile(String name, {String? ext = "json"}) async {
    try {
      // Check if path does not exist
      if (_path == null) throw Exception("Path is null.");

      // Reads for web devices
      if (WolkarUtils.instance.device == Device.web) {
        final String result = await readWebFile();
        if (result.isEmpty) throw Exception("🛑 Unable to read web data.");
        debugPrint('💾 Web data readed successfully');
        return result;
      }

      // Reads for android, linux and windows
      if ([Device.android, Device.linux, Device.windows].contains(WolkarUtils.instance.device)) {
        File file = await File("${_path!}/$name/$ext").create(recursive: true);
        final String content = await file.readAsString();
        debugPrint('💾 Data read successfully');
        return content;
      }

      throw ("🛑 Current device did not match any of the available devices.");
    } catch (e) {
      debugPrint('❌ An error occurred reading file: $e');
      return "";
    }
  }

  /// Initializes android directory
  Future<void> _initAndroidDir() async {
    final uri = await getApplicationDocumentsDirectory();
    _path = uri.path;
  }

  /// Initializes desktop directories (linux, windows)
  ///
  /// Requires a [directoryName] that is the name of the folder
  /// where the data must be saved
  Future<void> _initDesktopDir(String directoryName) async {
    final uri = await getApplicationDocumentsDirectory();
    _path = Uri.parse("${uri.path}/$directoryName").path;
  }

  //==============
  //============== Getters
  //==============

  /// Returns if the path is selected
  bool get directorySelected => _path != null;

  /// Updates service path
  set path(String newPath) {
    _path = newPath;
  }
}

abstract class AppDataInterface {
  //==============
  //============== Attributes
  //==============

  //==============
  //============== Constructors
  //==============

  //==============
  //============== Methods
  //==============

  /// Loads user data, using readFile
  bool loadData();

  /// Saves user data, using saveFile
  bool saveData();

  //==============
  //============== Getters
  //==============

  //==============
  //============== Getter Functions
  //==============
}
