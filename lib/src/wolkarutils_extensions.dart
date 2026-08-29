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

import 'package:flutter/material.dart';
import 'package:wolkarutils/wolkarutils.dart';

extension Paragraphs on Text {
  Text h1({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: bold == true ? FontWeight.w700 : null,

        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 50,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 55,
        },
      ),
    );
  }

  Text h2({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: bold == true ? FontWeight.w700 : null,
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 45,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 45,
        },
      ),
    );
  }

  Text h3({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: bold == true ? FontWeight.w700 : null,
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 40,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 35,
        },
      ),
    );
  }

  Text h4({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: bold == true ? FontWeight.w600 : null,
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 35,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 30,
        },
      ),
    );
  }

  Text h5({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: bold == true ? FontWeight.w600 : null,

        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 30,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 27,
        },
      ),
    );
  }

  Text h6({Color? color, bool? bold = false}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: bold == true ? FontWeight.w600 : null,

        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 25,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 25,
        },
      ),
    );
  }

  Text p({Color? color, bool? bold = false}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,

        fontWeight: bold! ? FontWeight.w600 : FontWeight.w500,
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 20,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 20,
        },
      ),
    );
  }
}

extension Percentage on Divider {
  Widget percentage(int percentaje) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * (percentaje / 100),
          child: Divider(),
        );
      },
    );
  }
}

extension Modifier on Color {
  Color toPastel({
    double saturation = 0.35, // 35% de saturación (rango: 0.3-0.5)
    double lightness = 0.80, // 80% de luminosidad (rango: 0.75-0.85)
  }) {
    HSLColor color = HSLColor.fromColor(this);
    return color.withLightness(lightness).withSaturation(saturation).toColor();
  }

  Color darkerColor({
    double saturation = 0.20,
    double lightness = 0.60, // 80% de luminosidad (rango: 0.75-0.85)
  }) {
    HSLColor color = HSLColor.fromColor(this);
    return color.withSaturation(saturation).withLightness(lightness).toColor();
  }
}

extension Children on Column {
  Widget addChildren(List<Widget> childrenToAdd) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      spacing: spacing,
      children: [...children, ...childrenToAdd],
    );
  }
}

extension Constrained on AlertDialog {
  Widget constrained(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints(
        maxWidth: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => double.infinity,
          ScreenSize.large => MediaQuery.sizeOf(context).width * 0.60,
          ScreenSize.xlarge || ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.30,
        },
      ),
      title: title,
      content: content,
      actions: actions,
    );
  }
}

extension TextUtils on TextEditingController {
  /// Gets the corresponding text on Controller, but already trimmed.
  String get trimmedText {
    final finalText = text.trim();
    return finalText;
  }

  /// Transforms and returns the trimmed text into a int if possible or `0` if not.
  int get intValue {
    String text = this.text.trim();
    text = text.replaceAll(",", ".");
    double doubleValue = double.tryParse(text) ?? 0.0;
    int endValue = doubleValue.toInt();
    return endValue;
  }

  /// Transforms and returns the trimmed text into a double if possible or `0.0` if not.
  double get doubleValue {
    String text = this.text.trim();
    text = text.replaceAll(",", ".");
    final double endValue = double.tryParse(text) ?? 0.0;
    return endValue;
  }
}

/// Allows offset to use json parsing
extension OffsetJSON on Offset {
  /// Returns a json parsed data
  Map<String, dynamic> get json => {"dx": dx, "dy": dy};

  /// Loads the json parsed data
  static Offset fromJSON(Map<String, dynamic> data) {
    return Offset((data["dx"] as num).toDouble(), (data["dy"] as num).toDouble());
  }
}

/// Allows TimeOfDay to export / load from json
extension TimeOfDayJSON on TimeOfDay {
  /// Returns a timeofday from json
  static TimeOfDay fromJSON(Map<String, dynamic> data) {
    return TimeOfDay(hour: data["hour"] ?? 0, minute: data["minute"] ?? 0);
  }

  /// Returns the JSON of a TimeOfDay
  Map<String, dynamic> get json => {"hour": hour, "minute": minute};
}

/// Allows DateTime to build from TimeOfDay
extension DateTimeFromTOD on DateTime {
  /// Transfroms a TimeOfDay to DateTime
  DateTime fromTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }
}
