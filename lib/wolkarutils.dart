export 'src/wolkarutils_enums.dart';
export 'src/wolkarutils_extensions.dart';
export 'src/wolkarutils_styles.dart';
export 'src/wolkarutils_code.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/wolkarutils_enums.dart';

/// Clase principal de uso general de wolkarutils
class WolkarUtils {
  //==============
  //============== Atributos
  //==============

  /// Tipo de dispositivo usado
  late Device _device;

  /// Tamaño de dispositivo usado
  late ScreenSize _screenSize;

  /// Color pallete de dispositivo
  late ColorScheme _colorPallete;

  /// Instancia unica del singleton
  static final WolkarUtils _instance = WolkarUtils._internal();

  /// Temas de la app
  late ThemeData _theme;

  //==============
  //============== Constructor interno
  //==============

  /// Constructor interno privado
  WolkarUtils._internal();

  //==============
  //============== Metodos
  //==============

  /// Inicializa los utiles de wolkar
  ///
  /// [context] como contexto para tomar a partir de ahí los datos
  ///
  /// Ejemplo:
  /// ```dart
  /// class MainApp extends StatelessWidget{
  ///   ...
  ///   return Builder(
  ///     builder: (context){
  ///       initWolkarUtils(context); 
  ///       return MaterialApp(...); 
  ///     }
  ///   );
  ///   ...
  /// }
  /// ```
  void initWolkarUtils(BuildContext context) {
    _theme = Theme.of(context);
    _colorPallete = _theme.colorScheme;
    _initDevice();
    _initScreenSize(context);
  }

  /// Inicializa el tipo de dispositivo de la app
  void _initDevice() {
    if (kIsWeb) {
      _device = Device.web;
      return;
    } else if (Platform.isAndroid) {
      _device = Device.android;
    } else if (Platform.isLinux) {
      _device = Device.linux;
    } else if (Platform.isWindows) {
      _device = Device.windows;
    } else if (Platform.isMacOS) {
      _device = Device.macos;
    } else if (Platform.isIOS) {
      _device = Device.ios;
    }
  }

  /// Inicializa el tipo de pantalla
  ///
  /// [context] de tipo [BuildContext] para poder leer los tamaños
  void _initScreenSize(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width < 360) {
      _screenSize = ScreenSize.small;
    } else if (width < 600) {
      _screenSize = ScreenSize.regular;
    } else if (width < 720) {
      _screenSize = ScreenSize.large;
    } else if (width < 1024) {
      _screenSize = ScreenSize.xlarge;
    } else {
      _screenSize = ScreenSize.xxlarge;
    }
  }

  //==============
  //============== Getters
  //==============

  /// Tamaño de pantalla de dispostivo
  ScreenSize get screenSize => _screenSize;

  /// Tipo de dispositivo
  Device get device => _device;

  /// Paleta de color de la app
  ColorScheme get colorPallete => _colorPallete;

  /// Temas de la app
  ThemeData get theme => _theme;

  /// Instancia del singleton
  static WolkarUtils get instance => _instance;
}
