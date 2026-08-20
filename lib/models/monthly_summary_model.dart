class MonthlySummary {
  final String period;
  final int topUpCount;
  final double topUpAmount;
  final int exchangeCount;
  final double exchangeAmount;

  final List<TransactionItem> topUps;
  final List<TransactionItem> exchanges;


  MonthlySummary({
    required this.period,
    required this.topUpCount,
    required this.topUpAmount,
    required this.exchangeCount,
    required this.exchangeAmount,
    required this.topUps,
    required this.exchanges,
  });


  factory MonthlySummary.fromJson(Map<String,dynamic> json){

    final data = json['data'];

    return MonthlySummary(
      period: data['selected_period'],

      topUpCount:
          data['totals']['top_up']['count'],

      topUpAmount:
          (data['totals']['top_up']['amount'] as num)
              .toDouble(),

      exchangeCount:
          data['totals']['exchange']['count'],

      exchangeAmount:
          (data['totals']['exchange']['exchange_amount']
              as num)
              .toDouble(),


      topUps:
          (data['top_up_list'] as List)
              .map((e)=>TransactionItem.fromJson(e))
              .toList(),

      exchanges:
          (data['exchange_list'] as List)
              .map((e)=>TransactionItem.fromJson(e))
              .toList(),
    );
  }
}



class TransactionItem {

  final int id;
  final String name;
  final double amount;
  final String type;
  final String date;
  final String time;


  TransactionItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
    required this.time,
  });



  factory TransactionItem.fromJson(Map<String,dynamic> json){

    return TransactionItem(

      id: json['transaction_id'],

      name: json['user_name'],

      amount:
        ((json['amount'] ??
          json['exchange_amount']) as num)
          .toDouble(),

      type:
        json['transaction_type'],

      date:
        json['date'],

      time:
        json['time'],
    );
  }
}