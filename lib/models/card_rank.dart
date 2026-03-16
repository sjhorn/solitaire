enum CardRank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king;

  int get value => index + 1;

  int get previousValue => value - 1;

  String get symbol {
    switch (this) {
      case CardRank.ace:
        return 'A';
      case CardRank.king:
        return 'K';
      default:
        return name[0].toUpperCase();
    }
  }
}
