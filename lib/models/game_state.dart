import 'card_rank.dart';
import 'card_suit.dart';
import 'playing_card.dart';

class GameState {
  final List<PlayingCard> stock;
  final List<PlayingCard> waste;
  final List<List<PlayingCard>> foundations;
  final List<List<PlayingCard>> tableau;
  final int initialDealSize;

  const GameState({
    required this.stock,
    required this.waste,
    required this.foundations,
    required this.tableau,
    this.initialDealSize = 7,
  });

  factory GameState.initial() {
    return GameState(
      stock: _createDeck(),
      waste: [],
      foundations: List.generate(4, (_) => []),
      tableau: List.generate(7, (_) => []),
    );
  }

  static List<PlayingCard> _createDeck() {
    final suits = CardSuit.values;
    final ranks = CardRank.values;
    final deck = <PlayingCard>[];

    for (final suit in suits) {
      for (final rank in ranks) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }

    return deck;
  }

  PlayingCard? get topCardOfWaste {
    if (waste.isNotEmpty) {
      return waste.last;
    }
    return null;
  }

  PlayingCard? get topCardOfTableau {
    for (var i = tableau.length - 1; i >= 0; i--) {
      if (tableau[i].isNotEmpty) {
        return tableau[i].last;
      }
    }
    return null;
  }

  PlayingCard? get topCardOfFoundation {
    for (var i = foundations.length - 1; i >= 0; i--) {
      if (foundations[i].isNotEmpty) {
        return foundations[i].last;
      }
    }
    return null;
  }

  bool get isGameOver {
    if (stock.isNotEmpty || waste.isNotEmpty) {
      return false;
    }
    return _allCardsOnFoundations();
  }

  bool _allCardsOnFoundations() {
    return foundations.fold(0, (sum, foundation) => sum + foundation.length) == 52;
  }

  GameState copyWith({
    List<PlayingCard>? stock,
    List<PlayingCard>? waste,
    List<List<PlayingCard>>? foundations,
    List<List<PlayingCard>>? tableau,
  }) {
    return GameState(
      stock: stock ?? this.stock,
      waste: waste ?? this.waste,
      foundations: foundations ?? this.foundations,
      tableau: tableau ?? this.tableau,
    );
  }

  GameState deal() {
    var currentStock = List<PlayingCard>.from(stock);
    var currentTableau = List.generate(7, (_) => <PlayingCard>[]);

    // Deal cards to tableau: pile i gets i+1 cards
    // Tableau[0]: 1 card, Tableau[1]: 2 cards, ... Tableau[6]: 7 cards
    // Total: 1+2+3+4+5+6+7 = 28 cards dealt, 24 remain in stock
    for (var i = 0; i < 7; i++) {
      for (var cardIndex = 0; cardIndex <= i; cardIndex++) {
        if (currentStock.isNotEmpty) {
          currentTableau[i].add(currentStock.removeLast());
        }
      }
    }

    // Face up the top card of each tableau pile
    for (var i = 0; i < 7; i++) {
      if (currentTableau[i].isNotEmpty) {
        final pile = List<PlayingCard>.from(currentTableau[i]);
        pile.last = pile.last.copyWith(isFaceUp: true);
        currentTableau[i] = pile;
      }
    }

    return copyWith(stock: currentStock, tableau: currentTableau);
  }
}
