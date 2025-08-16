import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List items;
  const HistoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return TransactionItem(
          amount: item['amount'],
          title: 'Transaction $index',
          timeAgo: '1 hour ago',
          trxID: item['trxID'],
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String amount;
  final String title;
  final String timeAgo;
  final String trxID;

  const TransactionItem({
    super.key,
    required this.amount,
    required this.title,
    required this.timeAgo,
    required this.trxID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.chat_bubble_outline, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 16),
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          // Amount and Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$$amount',
                style: const TextStyle(
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF00A86B),
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      trxID,
                      style: TextStyle(
                        color: Color(0xFF00A86B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
