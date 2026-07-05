import 'dart:ui';
import 'package:flutter/gestures.dart';
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
  final Widget? trailing;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.bold = true,
    this.icon = Icons.arrow_forward_ios_rounded,
    this.padding = const EdgeInsets.all(15),
    this.iconPosition = RoundedButtonIconPosition.right,
    this.roundedPixels = 360,
    this.trailing,
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
    final buttonTrailing =
        trailing ??
        Icon(
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
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (iconPosition == RoundedButtonIconPosition.left) buttonTrailing,
          Expanded(child: textDesign),
          if (iconPosition == RoundedButtonIconPosition.right) buttonTrailing,
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

/// Pantallas deslizables de la app
class Scroll extends StatefulWidget {
  final Axis scrollDirection;
  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final bool lockScroll;
  final bool draggable;
  const Scroll({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.scrollDirection = Axis.vertical,
    this.lockScroll = false,
    this.draggable = false,
  });

  /// Devuelve un Scroll adaptado SOLO para un [BottomSheet]
  Widget bottomSheet() {
    return Scroll(padding: EdgeInsets.only(left: 15, right: 15, bottom: 50), children: children);
  }

  /// Adds more children to a scroll widget
  Widget addChildren(List<Widget> newChildren) {
    return Scroll(children: [...children, ...newChildren]);
  }

  @override
  State<Scroll> createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS Scroll principal
    Widget scroll = SingleChildScrollView(
      controller: scrollController,
      physics: widget.lockScroll ? NeverScrollableScrollPhysics() : null,
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      child: widget.scrollDirection == Axis.vertical
          ? Column(
              spacing: widget.spacing,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: widget.children,
            )
          : Row(
              spacing: widget.spacing,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: widget.children,
            ),
    );

    //ATOMS Scroll con scroll horizontal
    if (widget.scrollDirection == Axis.horizontal) {
      scroll = Listener(
        onPointerSignal: (signal) {
          if (signal is PointerScrollEvent) {
            final double delta = signal.scrollDelta.dy;
            final double newOffset = scrollController.offset + delta;
            if (scrollController.hasClients) {
              scrollController.jumpTo(
                newOffset.clamp(0.0, scrollController.position.maxScrollExtent),
              );
            }
          }
        },
        child: scroll,
      );
    }

    //LAYOUT Definicion final
    return widget.draggable
        ? ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            child: scroll,
          )
        : scroll;
  }
}

/// Input de textfield de la app
class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.controller,
    this.onChange,
    this.obscure = false,
    this.hintText = "",
    this.dialog = false,
    this.textInputType = TextInputType.text,
    this.centered = false,
    this.initiallySelected = false,
    this.onLeave,
    this.onSubmitted,
  });

  final dynamic onChange;
  final bool obscure;
  final String hintText;
  final TextEditingController controller;
  final bool? dialog;
  final TextInputType? textInputType;
  final bool initiallySelected;
  final bool centered;
  final Function(String)? onLeave;
  final Function(String)? onSubmitted;

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
        onTapOutside: (event) {
          onLeave?.call(controller.text);
        },
        onSubmitted: onSubmitted ?? (value) {},
        selectAllOnFocus: initiallySelected,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        keyboardType: textInputType,
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

  Widget simple({bool? limitedLines = true, int? lineLimit = 1, bool? restricted = false}) {
    return Builder(
      builder: (context) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black12)),
          child: SizedBox(
            width: restricted!
                ? switch (WolkarUtils.instance.screenSize) {
                    ScreenSize.small ||
                    ScreenSize.regular => MediaQuery.sizeOf(context).width * 0.9,
                    ScreenSize.large => MediaQuery.sizeOf(context).width * 0.60,
                    ScreenSize.xlarge || ScreenSize.xxlarge =>
                      !dialog!
                          ? MediaQuery.sizeOf(context).width * 0.30
                          : MediaQuery.sizeOf(context).width * 0.15,
                  }
                : null,
            child: TextField(
              onSubmitted: onSubmitted ?? (value) {},
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
          ).p(color: active ? _colorPallete.onSecondaryContainer : _colorPallete.onSurface),
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
    this.rounded = true,
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

/// Restricts the horizontal size to make content legible
class Legible extends StatelessWidget {
  const Legible({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: switch (WolkarUtils.instance.screenSize) {
        ScreenSize.small || ScreenSize.regular => double.infinity,
        ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
        ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
        ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
      },
      child: child,
    );
  }
}

//STYLE Carta grande inicio
class HomeBigCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final dynamic onPressed;
  final LinearGradient? gradient;
  final BoxFit? fit;

  const HomeBigCard(
    this.title,
    this.description,
    this.image, {
    super.key,
    this.onPressed,
    this.gradient,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onPressed ?? () {},
        child: Container(
          width: switch (WolkarUtils.instance.screenSize) {
            ScreenSize.small || ScreenSize.regular => MediaQuery.sizeOf(context).width * 0.9,
            ScreenSize.large => MediaQuery.sizeOf(context).width * 0.6,
            ScreenSize.xxlarge || ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
          },
          decoration: BoxDecoration(
            color: _colorPallete.surfaceContainer,
            border: Border.all(color: _colorPallete.outline),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            spacing: 10,
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      color: gradient != null ? null : _colorPallete.surfaceContainer,
                    ),
                    child: Image.asset(image, fit: fit ?? BoxFit.cover),
                  ),
                ),
              ),

              Text(title).h4(bold: true),
              Text(description).h5(),
            ],
          ),
        ),
      ),
    );
  }
}

//STYLE Carta pequeña inicio
class HomeSmallCard extends StatelessWidget {
  final String description;
  final dynamic onPressed;
  final String? image;
  final LinearGradient? gradient;

  const HomeSmallCard({
    super.key,
    required this.description,
    this.image,
    this.onPressed,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onPressed ?? () {},
        child: Container(
          width: switch (WolkarUtils.instance.screenSize) {
            ScreenSize.small || ScreenSize.regular => MediaQuery.sizeOf(context).width * 0.9,
            ScreenSize.large => MediaQuery.sizeOf(context).width * 0.6,
            ScreenSize.xxlarge || ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
          },
          decoration: BoxDecoration(
            color: _colorPallete.surfaceContainer,
            border: Border.all(color: _colorPallete.outline),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            spacing: 10,
            children: [
              SizedBox.square(
                dimension: 75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      color: gradient != null ? null : _colorPallete.surfaceContainer,
                    ),
                    child: Image.asset(image ?? "assets/icons/icon.png", fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(child: Text(description).h5()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialogo de confirmación de eliminación
///
/// Ejemplo de implementación:
/// ```dart
/// () async {
///   final result = await showDialog(DeleteDialog());
///   if (result) {
///     //gestionar eliminación
///   }
/// }
/// ```
///
/// Retorna `true` si se ha confirmado la eliminación o `false` si no.
class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final String delete;
  final String cancel;

  const DeleteDialog({
    super.key,
    this.title = "Confirmar eliminación",
    this.content = "¿Seguro que quieres eliminar el contenido? Esta acción no es reversible",
    this.delete = "Eliminar",
    this.cancel = "Cancelar",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Scroll(children: [Text(content).p()]),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, false);
          },
          label: Text(cancel),
          style: ElevatedButton.styleFrom(
            backgroundColor: WolkarUtils.instance.colorPallete.primary,
            foregroundColor: WolkarUtils.instance.colorPallete.onPrimary,
          ),
          icon: Icon(Icons.close),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, true);
          },
          label: Text(delete),
          icon: Icon(Icons.delete_forever),
        ),
      ],
    ).constrained(context);
  }
}

/// Dialogo de renombrado
///
/// [title] como el titulo, [content] como el contenido antes del input,
/// [rename] como botón de aceptado, [cancel] como cancelación. [availableText] como
/// texto que se muestra en el chip si aceptado, [notAvailableText] como texto de chip
/// en rechazo. [chipFunction] como función que debe retornar `true` o `false` para
/// determinar el valor del chip, y que se ejecuta en cada cambio.
///
/// Ejemplo de implementacion:
/// ```dart
///   () async {
///     final chosenName = await showDialog(RenameDialog());
///     if (isAvailable(chosenName)){
///       // Gestionar resultado
///     }
///   }
/// ```
///
/// Retorna `false` si se cancela. Retorna cualquier [String] si se ha metido un valor válido.
class RenameDialog extends StatefulWidget {
  const RenameDialog({
    super.key,
    this.title = "Renombrar",
    this.content = "Elige un nuevo nombre para tu elemento: ",
    this.rename = "Renombrar",
    this.cancel = "Cancelar",
    this.availableText = "Nombre Disponible",
    this.notAvailableText = "Nombre no Disponible",
    required this.chipFunction,
  });

  final String title;
  final String content;
  final String rename;
  final String cancel;
  final String availableText;
  final String notAvailableText;
  final bool Function(String) chipFunction;

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  //STATE Comenzar con false por defecto
  bool available = false;

  //FORM Input controller
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(widget.title),
          content: Scroll(
            children: [
              Text(widget.content).p(),
              Input(
                controller: textController,
                dialog: true,
                onChange: (newValue) {
                  final result = widget.chipFunction(newValue);
                  setState(() {
                    available = result;
                  });
                },
              ),
              AvailabilityIndicator(available: available),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, false);
              },
              label: Text(widget.cancel),
              icon: Icon(Icons.close),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (available == false) return;
                Navigator.pop(context, textController.text);
              },
              label: Text(widget.rename),
              icon: Icon(Icons.edit),
              style: ElevatedButton.styleFrom(
                backgroundColor: WolkarUtils.instance.colorPallete.primary,
                foregroundColor: WolkarUtils.instance.colorPallete.onPrimary,
              ),
            ),
          ],
        ).constrained(context);
      },
    );
  }
}
