class Order {
  final double amount;
  final DateTime createdAt;
  final List<dynamic> products;

  Order({this.amount, this.createdAt, this.products});

  factory Order.fromJson(json) {
    return Order(
      amount: json['amount'],
      createdAt: DateTime.parse(json['createdAt']),
      products: json['products'],
    );
  }
}
