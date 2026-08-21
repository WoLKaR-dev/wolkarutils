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

import 'dart:math';

/// Genera un identificador de caracteres aleatorios
///
/// [amount] número total de caracteres a generar, por defecto 15
///
/// Retorna el id generado
String generateId({int amount = 15}) {
  String chars = "1234567890qwertyuiopasdfghjklñzxcvbnmQWERTYUIOPASDFGHJKLÑZXCVBNM";
  String generatedId = "";
  while (generatedId.length < amount) {
    int chosenPosition = Random.secure().nextInt(chars.length - 1);
    String selectedChar = chars[chosenPosition];
    generatedId += selectedChar;
  }
  return generatedId;
}
