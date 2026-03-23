import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wolkarutils/wolkarutils.dart';

/// Color pallete privado
final _colorPallete = WolkarUtils.instance.colorPallete;

/// Un botón redondeado con icono incluido
abstract class RoundedButton extends StatelessWidget {
  final bool bold;
  final String text;
  final Function(BuildContext) onTap;
  final IconData? icon;
  final EdgeInsets? padding;
  final RoundedButtonIconPosition? iconPosition;
  final double? roundedPixels;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.bold = true,
    this.icon = Icons.arrow_forward_ios_rounded,
    this.padding = const EdgeInsets.all(15),
    this.iconPosition = RoundedButtonIconPosition.right,
    this.roundedPixels = 360,
  });

  @override
  Widget build(BuildContext context) {
    //PART Width definido
    final double width = switch (WolkarUtils.instance.screenSize) {
      ScreenSize.small => MediaQuery.sizeOf(context).width * 0.95,
      ScreenSize.regular => MediaQuery.sizeOf(context).width * 0.95,
      ScreenSize.large => MediaQuery.sizeOf(context).width * 0.60,
      ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.30,
      ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.30,
    };

    //ATOMS Diseño del texto
    final textDesign = Text(
      text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
        fontSize: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small => 25,
          ScreenSize.regular => 25,
          ScreenSize.large => 30,
          ScreenSize.xlarge => 30,
          ScreenSize.xxlarge => 30,
        },
      ),
    );

    //ATOMS Diseño del icono
    final iconDesign = Icon(
      icon,
      size: switch (WolkarUtils.instance.screenSize) {
        ScreenSize.small => 25,
        ScreenSize.regular => 27,
        ScreenSize.large => 30,
        ScreenSize.xlarge => 35,
        ScreenSize.xxlarge => 35,
      },
    );

    //ATOMS Diseño principal
    final mainDesign = Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: _colorPallete.surfaceContainer,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(roundedPixels!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (iconPosition == RoundedButtonIconPosition.left) iconDesign,
          Expanded(child: textDesign),
          if (iconPosition == RoundedButtonIconPosition.right) iconDesign,
        ],
      ),
    );

    //LAYOUT Layout principal
    final mainLayout = GestureDetector(
      onTap: () {
        onTap(context);
      },
      child: mainDesign,
    );

    return mainLayout;
  }
}

/// Crea un botón Cuadrado con icono incluido
abstract class SquaredButton extends StatelessWidget {
  final bool? useBorder;
  final Widget? extraInfo;
  final String text;
  final Color? color;
  final IconData? upperIcon;
  final Function(BuildContext)? onLongTap;
  final Function(BuildContext) onPressed;
  SquaredButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.upperIcon = Icons.arrow_outward,
    this.extraInfo,
    this.useBorder = true,
    this.onLongTap,
    Color? color,
  }) : color = color ?? WolkarUtils.instance.colorPallete.surfaceContainer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onLongTap?.call(context);
      },
      onTap: () {
        onPressed.call(context);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: useBorder! ? Border.all(color: Colors.black) : null,
          borderRadius: BorderRadius.circular(15),
          color: color != WolkarUtils.instance.colorPallete.surfaceContainer
              ? color!.toPastel()
              : WolkarUtils.instance.colorPallete.surfaceContainer,
        ),
        width: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small => 170,
          ScreenSize.regular => 200,
          ScreenSize.large => 225,
          ScreenSize.xlarge => 255,
          ScreenSize.xxlarge => 255,
        },
        child: AspectRatio(
          aspectRatio: 1 / 1.15,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(360),
                ),
                padding: EdgeInsets.all(5),
                child: Icon(upperIcon),
              ),
              Column(
                spacing: 15,

                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //SECTION Nombre
                  Text(text).h4(),

                  //SECTION Apartado de tiempo
                  extraInfo ?? SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fondo de la pantalla de las apps
class Background extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;
  const Background({super.key, this.padding, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(color: _colorPallete.surface),
      child: SafeArea(child: child),
    );
  }

  Widget aligned({AlignmentGeometry? alignment = Alignment.topCenter}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: padding,
      decoration: BoxDecoration(color: _colorPallete.surface),
      child: SafeArea(
        child: Align(alignment: alignment!, child: child),
      ),
    );
  }
}

/// Pantalls deslizables de la app
class Scroll extends StatelessWidget {
  final Axis scrollDirection;
  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final bool lockScroll;
  final bool scrollConfiguration;
  const Scroll({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.scrollDirection = Axis.vertical,
    this.lockScroll = false,
    this.scrollConfiguration = false,
  });
  @override
  Widget build(BuildContext context) {
    //ATOMS Scroll principal
    final scroll = SingleChildScrollView(
      physics: lockScroll ? NeverScrollableScrollPhysics() : null,
      scrollDirection: scrollDirection,
      padding: padding,
      child: scrollDirection == Axis.vertical
          ? Column(spacing: spacing, crossAxisAlignment: crossAxisAlignment, children: children)
          : Row(spacing: spacing, crossAxisAlignment: crossAxisAlignment, children: children),
    );

    //LAYOUT Definicion final
    return scrollConfiguration
        ? ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            child: scroll,
          )
        : scroll;
  }

  Widget addChildren({List<Widget>? childrenToAdd = const []}) {
    //ATOMS Scroll
    final scroll = SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      child: scrollDirection == Axis.vertical
          ? Column(
              spacing: spacing,
              crossAxisAlignment: crossAxisAlignment,
              children: [...children, ...childrenToAdd!],
            )
          : Row(
              spacing: spacing,
              crossAxisAlignment: crossAxisAlignment,
              children: [...children, ...childrenToAdd!],
            ),
    );

    //LAYOUT Main Scroll
    return scrollConfiguration
        ? ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.stylus},
            ),
            child: scroll,
          )
        : scroll;
  }
}

/// Input de textfield de la app
class Input extends StatelessWidget {
  final dynamic onChange;
  final bool obscure;
  final String hintText;
  final TextEditingController controller;
  final bool? dialog;
  final TextInputType? textInputType;
  const Input({
    super.key,
    this.obscure = false,
    this.hintText = "",
    required this.controller,
    this.onChange,
    this.dialog = false,
    this.textInputType = TextInputType.text,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: switch (WolkarUtils.instance.screenSize) {
        ScreenSize.small || ScreenSize.regular => MediaQuery.sizeOf(context).width * 0.9,
        ScreenSize.large => MediaQuery.sizeOf(context).width * 0.60,
        ScreenSize.xlarge || ScreenSize.xxlarge =>
          !dialog!
              ? MediaQuery.sizeOf(context).width * 0.30
              : MediaQuery.sizeOf(context).width * 0.15,
      },
      child: TextField(
        onChanged: (value) {
          if (onChange != null) {
            onChange(value);
          }
        },
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: _colorPallete.secondaryContainer,
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: _colorPallete.outline),
            borderRadius: BorderRadius.circular(360),
          ),
        ),
      ),
    );
  }

  Widget simple({bool? limitedLines = true, int? lineLimit = 1}) {
    return Builder(
      builder: (context) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black12)),
          child: TextField(
            cursorColor: Colors.black12,
            maxLines: limitedLines! ? lineLimit : null,
            onChanged: (value) {
              if (onChange != null) {
                onChange(value);
              }
            },
            controller: controller,
            obscureText: obscure,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black12,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: _colorPallete.outline),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: _colorPallete.outline),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Indicador de disponibilidad
class AvailabilityIndicator extends StatelessWidget {
  final bool available;
  final String? availableText;
  final String? unavailableText;
  const AvailabilityIndicator({
    super.key,
    required this.available,
    this.availableText = "Available__",
    this.unavailableText = "Unavailable__",
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        border: Border.all(color: available ? Colors.green[900]! : Colors.red[900]!, width: 2),
        color: available ? Colors.green[100] : Colors.red[100],
      ),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            available ? Icons.check : Icons.close,
            color: available ? Colors.green[900] : Colors.red[900],
          ),
          Text(
            available ? availableText! : unavailableText!,
            style: TextStyle(
              fontSize: switch (WolkarUtils.instance.screenSize) {
                ScreenSize.small || ScreenSize.regular => 18,
                ScreenSize.large || ScreenSize.xlarge || ScreenSize.xxlarge => 20,
              },
              color: available ? Colors.green[900] : Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón que permite estar activo segun toggle
///
/// [active] define si está activo o no. [text] debe proveer el texto para mostrar en el
/// botón y [onToggle] se retornará el inverso del valor actual del botón
class ToggleableTextButton extends StatelessWidget {
  final String baseText;
  final String? unselectedText;
  final String? selectedText;
  final double? width;
  final bool? circle;
  final bool active;
  final Function(bool) onToggle;

  const ToggleableTextButton({
    super.key,
    required this.active,
    required this.baseText,
    required this.onToggle,
    String? unselectedText,
    String? selectedText,
    this.circle = true,
    this.width,
  }) : selectedText = selectedText ?? baseText,
       unselectedText = unselectedText ?? baseText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle(!active);
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: active ? Colors.black : _colorPallete.outline),
          color: active ? _colorPallete.secondaryContainer : _colorPallete.surfaceContainer,
          shape: circle! ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: Center(
          child: Text(
            active ? selectedText! : unselectedText!,
          ).h7(color: active ? _colorPallete.onSecondaryContainer : _colorPallete.onSurface),
        ),
      ),
    );
  }
}

/// Botón que forma parte de un [BottomSheet]
///
/// [icon] como icono y [text] como texto del botón. [onTap] como callback a ejecutar al ser
/// presionado.
/// [color] como color opcional del icono y texto. [rounded] representa opcionalmente si redondear
/// el tile.
class BottomSheetListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool? rounded;
  const BottomSheetListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
    this.rounded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text).h6(),
      iconColor: color,
      textColor: color,
      onTap: onTap,
      leading: Icon(icon),
      shape: rounded!
          ? RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(360))
          : null,
    );
  }
}

