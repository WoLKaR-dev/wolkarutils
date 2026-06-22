import 'package:flutter/material.dart';
import 'package:wolkarutils/wolkarutils.dart';

extension Paragraphs on Text {
  Text h1({Color? color, bool? bold}) {
    return Text(
      data!,
      overflow: overflow,
      style: TextStyle(
        color: color,

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

        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => 25,
          ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 25,
        },
        fontWeight: bold! ? FontWeight.w600 : FontWeight.w500,
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
