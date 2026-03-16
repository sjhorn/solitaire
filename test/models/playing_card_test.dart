import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solitaire/models/models.dart';

void main() {
  group('CardRank', () {
    test('has correct value for each rank', () {
      expect(CardRank.ace.value, equals(1));
      expect(CardRank.five.value, equals(5));
      expect(CardRank.king.value, equals(13));
    });

    test('previousValue returns value minus 1', () {
      expect(CardRank.ace.previousValue, equals(0));
      expect(CardRank.five.previousValue, equals(4));
      expect(CardRank.king.previousValue, equals(12));
    });

    test('symbol returns correct letter', () {
      expect(CardRank.ace.symbol, equals('A'));
      expect(CardRank.king.symbol, equals('K'));
      expect(CardRank.five.symbol, equals('F'));
      expect(CardRank.jack.symbol, equals('J'));
    });
  });

  group('CardSuit', () {
    test('has correct symbol and color for each suit', () {
      expect(CardSuit.clubs.symbol, equals('♣'));
      expect(CardSuit.clubs.color, equals(Colors.black));

      expect(CardSuit.diamonds.symbol, equals('♦'));
      expect(CardSuit.diamonds.color, equals(Colors.red));

      expect(CardSuit.hearts.symbol, equals('♥'));
      expect(CardSuit.hearts.color, equals(Colors.red));

      expect(CardSuit.spades.symbol, equals('♠'));
      expect(CardSuit.spades.color, equals(Colors.black));
    });

    test('name returns correct suit name', () {
      expect(CardSuit.clubs.name, equals('Clubs'));
      expect(CardSuit.diamonds.name, equals('Diamonds'));
      expect(CardSuit.hearts.name, equals('Hearts'));
      expect(CardSuit.spades.name, equals('Spades'));
    });
  });

  group('PlayingCard', () {
    test('has correct suit and rank', () {
      final card = const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      expect(card.suit, equals(CardSuit.hearts));
      expect(card.rank, equals(CardRank.ace));
    });

    test('defaults to face down', () {
      final card = const PlayingCard(suit: CardSuit.spades, rank: CardRank.king);
      expect(card.isFaceUp, isFalse);
    });

    test('supports face up state', () {
      final card = const PlayingCard(suit: CardSuit.diamonds, rank: CardRank.five, isFaceUp: true);
      expect(card.isFaceUp, isTrue);
    });

    test('supports isSelected state', () {
      final card = const PlayingCard(suit: CardSuit.clubs, rank: CardRank.jack, isSelected: true);
      expect(card.isSelected, isTrue);
    });

    test('copyWith creates new instance with updated fields', () {
      final card = const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ten, isFaceUp: false);
      final flipped = card.copyWith(isFaceUp: true);
      expect(flipped.suit, equals(card.suit));
      expect(flipped.rank, equals(card.rank));
      expect(flipped.isFaceUp, isTrue);
    });

    test('equality compares by suit and rank only', () {
      final card1 = const PlayingCard(suit: CardSuit.spades, rank: CardRank.ace);
      final card2 = const PlayingCard(suit: CardSuit.spades, rank: CardRank.ace);
      final card3 = const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);

      expect(card1, equals(card2));
      expect(card1.hashCode, equals(card2.hashCode));
      expect(card1, isNot(equals(card3)));
    });

    test('toString includes face status', () {
      final card1 = const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace, isFaceUp: true);
      final card2 = const PlayingCard(suit: CardSuit.spades, rank: CardRank.king, isFaceUp: false);

      expect(card1.toString(), contains(' (face up)'));
      expect(card2.toString(), isNot(contains(' (face up)')));
    });

    test('copyWith updates isSelected', () {
      final card = const PlayingCard(
        suit: CardSuit.diamonds,
        rank: CardRank.queen,
        isSelected: false,
      );
      final selected = card.copyWith(isSelected: true);

      expect(selected.isSelected, isTrue);
      expect(selected.suit, equals(card.suit));
      expect(selected.rank, equals(card.rank));
      expect(selected.isFaceUp, equals(card.isFaceUp));
    });
  });
}
