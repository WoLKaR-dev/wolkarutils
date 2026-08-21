// wolkarutils is a flutter utils package designed to speed app development.
// Copyright (C) 2026  WoLKaR-dev
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see https://www.gnu.org/licenses/.

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wolkarutils/wolkarutils.dart';

/// This Interface was made to be implemented as a `DataService` singleton
abstract class DataServiceInterface {
  /// Current data path
  String? _path;

  // Must be implemented

  Future<bool> initWebDirectory();

  Future<bool> writeWebFile(String fileOrKeyName, String content, String ext);

  Future<String> readWebFile(String fileOrKeyName, String ext);

  // Already implemented methods

  /// Initializes directories
  ///
  /// [directoryName] is the name of the folder where the data must be saved
  Future<void> initDirectories(String directoryName) async {
    switch (WolkarUtils.instance.device) {
      case Device.web:
        final result = await initWebDirectory();
        if (result) {
          _path = "";
        }
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
    DebugService().addMessage('📁 Init directories triggered: $_path', DebugMessageType.success);
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
        final bool result = await writeWebFile(name, data, ext!);
        if (!result) throw Exception("🛑 Unable to save web data.");
        DebugService().addMessage(
          "[💾DataService] Web data saved successfully",
          DebugMessageType.success,
        );
        return true;
      }

      // Saves for android, linux and windows
      if ([Device.android, Device.linux, Device.windows].contains(WolkarUtils.instance.device)) {
        File file = await File("${_path!}/$name.$ext").create(recursive: true);
        await file.writeAsString(data, flush: true);
        DebugService().addMessage(
          "[💾DataService] Data saved successfully",
          DebugMessageType.success,
        );
        return true;
      }

      throw ("🛑 Current device did not match any of the available devices.");
    } catch (e) {
      DebugService().addMessage(
        "[💾DataService] An error occurred writing file: $e",
        DebugMessageType.error,
      );
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
        final String result = await readWebFile(name, ext!);
        if (result.isEmpty) throw Exception("🛑 Unable to read web data.");
        DebugService().addMessage(
          "[💾DataService] Web data readed successfully",
          DebugMessageType.success,
        );
        return result;
      }

      // Reads for android, linux and windows
      if ([Device.android, Device.linux, Device.windows].contains(WolkarUtils.instance.device)) {
        File file = await File("${_path!}/$name.$ext").create(recursive: true);
        final String content = await file.readAsString();
        DebugService().addMessage(
          "[💾DataService] Data read successfully",
          DebugMessageType.success,
        );

        return content;
      }

      throw ("🛑 Current device did not match any of the available devices.");
    } catch (e) {
      DebugService().addMessage(
        "[💾DataService] An error occurred reading file: $e",
        DebugMessageType.error,
      );
      return "";
    }
  }

  /// Initializes android directory
  Future<void> _initAndroidDir() async {
    final uri = await getApplicationSupportDirectory();
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
  Future<bool> loadData();

  /// Saves user data, using saveFile
  Future<bool> saveData();

  //==============
  //============== Getters
  //==============

  //==============
  //============== Getter Functions
  //==============
}
