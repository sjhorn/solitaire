import 'package:flutter_test/flutter_test.dart';
import 'package:solitaire/models/models.dart';

void main() {
  group('GameState', () {
    group('initial', () {
      test('creates empty game state with full deck in stock', () {
        final state = GameState.initial();
        expect(state.stock.length, equals(52));
        expect(state.waste, isEmpty);
        expect(state.foundations, hasLength(4));
        expect(state.foundations.every((pile) => pile.isEmpty), isTrue);
        expect(state.tableau, hasLength(7));
        expect(state.tableau.every((pile) => pile.isEmpty), isTrue);
      });

      test('creates exactly 52 cards', () {
        final state = GameState.initial();
        final suits = CardSuit.values.length;
        final ranks = CardRank.values.length;
        expect(state.stock.length, equals(suits * ranks));
      });

      test('all suits are present', () {
        final state = GameState.initial();
        final suitsInDeck = state.stock.map((c) => c.suit).toSet();
        expect(suitsInDeck, equals(CardSuit.values.toSet()));
      });

      test('all ranks are present', () {
        final state = GameState.initial();
        final ranksInDeck = state.stock.map((c) => c.rank).toSet();
        expect(ranksInDeck, equals(CardRank.values.toSet()));
      });
    });

    group('deal', () {
      test('deals cards to tableau in correct distribution', () {
        final state = GameState.initial();
        final dealt = state.deal();
        expect(dealt.tableau[0].length, equals(1));
        expect(dealt.tableau[1].length, equals(2));
        expect(dealt.tableau[2].length, equals(3));
        expect(dealt.tableau[3].length, equals(4));
        expect(dealt.tableau[4].length, equals(5));
        expect(dealt.tableau[5].length, equals(6));
        expect(dealt.tableau[6].length, equals(7));
      });

      test('leaves remainder in stock', () {
        final state = GameState.initial();
        final dealt = state.deal();
        final dealtCards = dealt.tableau.fold(0, (sum, pile) => sum + pile.length);
        expect(dealt.stock.length, equals(52 - dealtCards));
      });

      test('tops of tableau piles are face up', () {
        final state = GameState.initial();
        final dealt = state.deal();
        for (var i = 0; i < 7; i++) {
          if (dealt.tableau[i].isNotEmpty) {
            expect(dealt.tableau[i].last.isFaceUp, isTrue);
          }
        }
      });

      test('stock has 24 cards after deal', () {
        final state = GameState.initial();
        final dealt = state.deal();
        expect(dealt.stock.length, equals(24));
      });

      test('creates immutable copy', () {
        final state = GameState.initial();
        state.deal();
        expect(state.stock.length, equals(52));
        expect(state.tableau.every((p) => p.isEmpty), isTrue);
      });
    });

    group('copyWith', () {
      test('creates new state with updated fields', () {
        final state = GameState.initial();
        final newState = state.copyWith(stock: []);
        expect(newState.stock.isEmpty, isTrue);
        expect(state.stock.length, equals(52));
      });
    });

    group('getters', () {
      late GameState state;

      setUp(() {
        state = GameState.initial();
      });

      test('topCardOfWaste returns last card when waste not empty', () {
        final testCard = const PlayingCard(suit: CardSuit.spades, rank: CardRank.two);
        state = state.copyWith(waste: [testCard]);
        expect(state.topCardOfWaste, equals(testCard));
      });

      test('topCardOfWaste returns null when waste empty', () {
        expect(state.topCardOfWaste, isNull);
      });

      test('topCardOfTableau returns last face-up card from rightmost non-empty pile', () {
        // Add cards to tableau[2]
        final card1 = const PlayingCard(suit: CardSuit.spades, rank: CardRank.two);
        state = state.copyWith(
          tableau: [
            [],
            [],
            [card1],
            [],
            [],
            [],
            [],
          ],
        );
        expect(state.topCardOfTableau, equals(card1));
      });

      test('topCardOfTableau returns null when all tableau piles empty', () {
        expect(state.topCardOfTableau, isNull);
      });

      test('topCardOfFoundation returns last card from rightmost non-empty foundation', () {
        final card = const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
        state = state.copyWith(
          foundations: [
            [],
            [card],
            [],
            [],
          ],
        );
        expect(state.topCardOfFoundation, equals(card));
      });

      test('topCardOfFoundation returns null when all foundations empty', () {
        expect(state.topCardOfFoundation, isNull);
      });
    });

    group('isGameOver', () {
      test('is false when cards remain in stock', () {
        final state = GameState.initial();
        expect(state.isGameOver, isFalse);
      });

      test('is false when cards remain in waste', () {
        final state = GameState.initial();
        final testCard = const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
        final withWaste = state.copyWith(waste: [testCard]);
        expect(withWaste.isGameOver, isFalse);
      });

      test('is false when cards not on foundations', () {
        final state = GameState.initial();
        final dealt = state.deal();
        expect(dealt.isGameOver, isFalse);
      });

      test('is true when all 52 cards on foundations', () {
        final state = GameState.initial();
        final allOnFoundations = List.generate(4, (_) => <PlayingCard>[]);
        // Create a full deck sorted by suit to foundations
        for (final card in state.stock) {
          allOnFoundations[card.suit.index].add(card);
        }
        final wonState = state.copyWith(stock: [], waste: [], foundations: allOnFoundations);
        expect(wonState.isGameOver, isTrue);
      });
    });
  });
}
