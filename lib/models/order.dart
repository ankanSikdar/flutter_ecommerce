class Order {
  final double amount;
  final String createdAt;
  final List<dynamic> products;

  Order({this.amount, this.createdAt, this.products});

  factory Order.fromJson(json) {
    return Order(
      amount: json['amount'],
      createdAt: json['createdAt'],
      products: json['products'],
    );
  }
}
