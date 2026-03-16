import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';

final gameProvider = StateNotifierProvider<GameProvider, GameState>((ref) {
  return GameProvider();
});

class GameProvider extends StateNotifier<GameState> {
  GameProvider() : super(GameState.initial());

  void reset() {
    state = GameState.initial();
  }

  GameState get deal => state.deal();

  bool canMoveToFoundation(PlayingCard card, List<PlayingCard> foundation) {
    if (foundation.isEmpty) {
      return card.rank == CardRank.ace;
    }
    final topCard = foundation.last;
    return card.suit == topCard.suit && card.rank.previousValue == topCard.rank.value;
  }

  bool canMoveToTableau(PlayingCard card, List<PlayingCard> tableauPile) {
    if (tableauPile.isEmpty) {
      return card.rank == CardRank.king;
    }
    final topCard = tableauPile.last;
    return card.suit.color != topCard.suit.color && card.rank.previousValue == topCard.rank.value;
  }

  void moveCardToFoundation(int tableauIndex, int foundationIndex) {
    final tableauPile = state.tableau[tableauIndex];
    if (tableauPile.isEmpty) return;

    final cardToMove = tableauPile.last;
    if (!canMoveToFoundation(cardToMove, state.foundations[foundationIndex])) return;

    // Create new tableau with one less card in the specified pile
    final newTableauPile = List<PlayingCard>.from(tableauPile)..removeLast();
    final newTableau = List<List<PlayingCard>>.from(state.tableau)..[tableauIndex] = newTableauPile;

    // Face up the next card in the tableau pile if any
    if (newTableauPile.isNotEmpty) {
      final pile = List<PlayingCard>.from(newTableauPile);
      pile.last = pile.last.copyWith(isFaceUp: true);
      newTableau[tableauIndex] = pile;
    }

    // Create new foundation with the card added
    final newFoundationPile = List<PlayingCard>.from(state.foundations[foundationIndex])
      ..add(cardToMove);
    final newFoundations = List<List<PlayingCard>>.from(state.foundations)
      ..[foundationIndex] = newFoundationPile;

    state = state.copyWith(tableau: newTableau, foundations: newFoundations);
  }
}
