import 'card_rank.dart';
import 'card_suit.dart';

class PlayingCard {
  const PlayingCard({
    required this.suit,
    required this.rank,
    this.isFaceUp = false,
    this.isSelected = false,
  });

  final CardSuit suit;
  final CardRank rank;
  final bool isFaceUp;
  final bool isSelected;

  PlayingCard copyWith({CardSuit? suit, CardRank? rank, bool? isFaceUp, bool? isSelected}) {
    return PlayingCard(
      suit: suit ?? this.suit,
      rank: rank ?? this.rank,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayingCard && other.suit == suit && other.rank == rank;
  }

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode;

  @override
  String toString() {
    final faceStatus = isFaceUp ? ' (face up)' : '';
    return '$suit $rank$faceStatus';
  }
}
