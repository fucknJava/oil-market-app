import 'package:flutter/material.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      body: ListView(
        children: [
          _buildOrderCard(
            'Заказ #001',
            '25.12.2023',
            '3998 руб.',
            'Доставлен',
            Colors.green,
          ),
          _buildOrderCard(
            'Заказ #002',
            '20.12.2023',
            '5997 руб.',
            'В обработке',
            Colors.orange,
          ),
          _buildOrderCard(
            'Заказ #003',
            '15.12.2023',
            '2499 руб.',
            'Доставляется',
            Colors.blue,
          ),
          _buildOrderCard(
            'Заказ #004',
            '10.12.2023',
            '1899 руб.',
            'Доставлен',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    String orderNumber,
    String date,
    String amount,
    String status,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Дата: $date'),
            const SizedBox(height: 8),
            Text('Сумма: $amount'),
            const SizedBox(height: 12),
            const Divider(),
            const Text(
              'Товары:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Mobil 1 ESP 5W-30 x1 - 2999 руб.'),
            const Text('• Shell Helix HX7 10W-40 x1 - 1899 руб.'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Повторить заказ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}