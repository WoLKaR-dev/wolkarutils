import 'package:flutter/material.dart';
import 'package:wolkarutils/src/wolkarutils_extensions.dart';
import 'package:wolkarutils/src/wolkarutils_styles.dart';

class DebugService {
  //==============
  //============== Attributes
  //==============

  /// Debug service messages
  final List<DebugMessage> _messages = [];

  /// Singleton main instance
  static final DebugService _instance = DebugService._internal();

  //==============
  //============== Constructors
  //==============

  /// Private internal constructor
  DebugService._internal();

  /// Factory constructor
  factory DebugService() => _instance;
  //==============
  //============== Methods
  //==============
  /// Adds a message to the log
  ///
  /// [message] is the content
  /// [type] is the message type
  void addMessage(String message, DebugMessageType type) {
    final debugMessage = DebugMessage(message, type);
    debugPrint(type == DebugMessageType.error ? " ❎ $message" : " ✅ $message");
    _messages.add(debugMessage);
  }

  //==============
  //============== Getters
  //==============

  /// Debug service messages
  List<DebugMessage> get messages => _messages;

  //==============
  //============== Getter Functions
  //==============
}

class DebugMessage {
  /// Main message
  final String message;

  /// Mesage type
  final DebugMessageType type;

  /// Message constructor
  DebugMessage(this.message, this.type);
}

/// Message enums
enum DebugMessageType { error, success, warning }

/// Shows all messages added to the log.
class DebugServiceMessageLog extends StatelessWidget {
  const DebugServiceMessageLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        children: [
          ...List.generate(DebugService().messages.length, (index) {
            final message = DebugService().messages[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Text(message.message).p(
                color: switch (message.type) {
                  DebugMessageType.success => Colors.green[700],
                  DebugMessageType.warning => Colors.amber[800],
                  DebugMessageType.error => Colors.red[700],
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
