enum Trails {
  none('none', 'None', 0, 0),
  circle('circle', 'Bubbles', 0, 0),
  line('line', 'Line', 20, 50),
  rect('rect', 'Rects', 50, 50),
  star('star', 'Stars', 100, 100),
  lightning('lightning', 'Lighting', 100, 100);

  final String id;
  final String name;
  final int requiredScore;
  final int price;

  const Trails(this.id, this.name, this.requiredScore, this.price);
}
