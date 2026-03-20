import 'package:flutter/material.dart';
import 'package:wolkarutils/wolkarutils.dart';

extension Paragraphs on Text {
  Widget h1({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 35,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 40,
        },
      ),
    );
  }

  Widget h2({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 32,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 37,
        },
      ),
    );
  }

  Widget h3({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 29,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 34,
        },
      ),
    );
  }

  Widget h4({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 26,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 31,
        },
      ),
    );
  }

  Widget h5({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 23,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 28,
        },
      ),
    );
  }

  Widget h6({Color? color, bool? bold = false}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 20,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 25,
        },
        fontWeight: bold! ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }

  Widget h7({Color? color, bool? bold = false}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,
        
        fontWeight: bold! ? FontWeight.w600 : FontWeight.w500,
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 14,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 17,
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