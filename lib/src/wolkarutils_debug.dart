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
  /// - [stackTrace] is an optional strack trace for detailed debugging
  void addMessage(String message, DebugMessageType type, {StackTrace? stackTrace}) {
    final debugMessage = DebugMessage(message, type, trace: stackTrace);
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

  /// StaceTrack
  final StackTrace? trace;

  /// Message constructor
  DebugMessage(this.message, this.type, {this.trace});
}

/// Message enums
enum DebugMessageType { error, success, warning }

/// Shows all messages added to the log.
class DebugServiceMessageLog extends StatefulWidget {
  const DebugServiceMessageLog({super.key});

  @override
  State<DebugServiceMessageLog> createState() => _DebugServiceMessageLogState();
}

class _DebugServiceMessageLogState extends State<DebugServiceMessageLog> {
  //STATE Show StackTrace
  bool showStackTrace = false;

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: WolkarUtils.instance.colorPallete.outline),
            ),
            padding: EdgeInsets.all(10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 5,
              spacing: 5,
              children: [
                Text('Show StackTrace:').p(),
                Switch(
                  value: showStackTrace,
                  onChanged: (newValue) {
                    setState(() {
                      showStackTrace = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          ...List.generate(DebugService().messages.length, (index) {
            final message = DebugService().messages[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(message.message).p(
                    color: switch (message.type) {
                      DebugMessageType.success => Colors.green[700],
                      DebugMessageType.warning => Colors.amber[800],
                      DebugMessageType.error => Colors.red[700],
                    },
                  ),
                  if (showStackTrace && message.trace != null)
                    Text('Trace: ${message.trace}').p(color: Colors.red[700]),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
