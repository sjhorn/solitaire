import 'package:flutter/material.dart';

enum CardSuit {
  clubs,
  diamonds,
  hearts,
  spades;

  String get name {
    switch (this) {
      case CardSuit.clubs:
        return 'Clubs';
      case CardSuit.diamonds:
        return 'Diamonds';
      case CardSuit.hearts:
        return 'Hearts';
      case CardSuit.spades:
        return 'Spades';
    }
  }

  String get symbol {
    switch (this) {
      case CardSuit.clubs:
        return '♣';
      case CardSuit.diamonds:
        return '♦';
      case CardSuit.hearts:
        return '♥';
      case CardSuit.spades:
        return '♠';
    }
  }

  Color get color {
    switch (this) {
      case CardSuit.clubs:
      case CardSuit.spades:
        return Colors.black;
      case CardSuit.diamonds:
      case CardSuit.hearts:
        return Colors.red;
    }
  }
}
