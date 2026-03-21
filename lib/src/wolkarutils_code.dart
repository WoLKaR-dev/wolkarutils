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
