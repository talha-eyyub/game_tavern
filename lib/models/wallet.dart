class Wallet {
  double balance;

  Wallet({this.balance = 0});

  void deposit(double amount) {
    balance += amount;
  }

  bool spend(double amount) {
    if (amount > balance) {
      return false;
    }
    balance -= amount;
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
