import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class OrderScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const OrderScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  DeliveryType _deliveryType = DeliveryType.pickup;
  PaymentMethod _paymentMethod = PaymentMethod.card;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      final user = authProvider.user!;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      if (user.address != null) {
        _addressController.text = user.address!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Информация о заказе
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ваш заказ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...widget.cartItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('${item.product.title} x${item.quantity}'),
                              ),
                              Text('${item.totalPrice} руб.'),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Итого:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.totalAmount} руб.',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1a237e),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Контактные данные
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Контактные данные',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'ФИО',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите ФИО';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Телефон',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите телефон';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите email';
                          }
                          if (!value.contains('@')) {
                            return 'Введите корректный email';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Способ доставки
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Способ доставки',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RadioListTile<DeliveryType>(
                        title: const Text('Самовывоз'),
                        subtitle: const Text('ул. Дзержинского, 4, стр. 7, Большой Камень'),
                        value: DeliveryType.pickup,
                        groupValue: _deliveryType,
                        onChanged: (value) {
                          setState(() {
                            _deliveryType = value!;
                          });
                        },
                      ),
                      RadioListTile<DeliveryType>(
                        title: const Text('Курьером по городу'),
                        subtitle: const Text('Доставка в пределах Большого Камня - 300 руб.'),
                        value: DeliveryType.city,
                        groupValue: _deliveryType,
                        onChanged: (value) {
                          setState(() {
                            _deliveryType = value!;
                          });
                        },
                      ),
                      RadioListTile<DeliveryType>(
                        title: const Text('По России'),
                        subtitle: const Text('Доставка по РФ - от 500 руб.'),
                        value: DeliveryType.russia,
                        groupValue: _deliveryType,
                        onChanged: (value) {
                          setState(() {
                            _deliveryType = value!;
                          });
                        },
                      ),
                      if (_deliveryType != DeliveryType.pickup)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Адрес доставки',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введите адрес доставки';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Способ оплаты
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Способ оплаты',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RadioListTile<PaymentMethod>(
                        title: const Text('Банковской картой онлайн'),
                        value: PaymentMethod.card,
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile<PaymentMethod>(
                        title: const Text('Наличными при получении'),
                        value: PaymentMethod.cashOnDelivery,
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile<PaymentMethod>(
                        title: const Text('Картой при получении'),
                        value: PaymentMethod.cardOnDelivery,
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Кнопка оформления
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a237e),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Подтвердить заказ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_deliveryType != DeliveryType.pickup &&
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите адрес доставки')),
      );
      return;
    }

    // Показать диалог подтверждения
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение заказа'),
        content: const Text('Вы уверены, что хотите оформить заказ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Имитация платежа
    final paymentSuccess = await _simulatePayment();

    if (paymentSuccess) {
      // Очистить корзину
      final cartProvider = context.read<CartProvider>();
      cartProvider.clearCart();

      // Показать успешное сообщение
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заказ успешно оформлен!'),
          backgroundColor: Colors.green,
        ),
      );

      // Вернуться на главную
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка оплаты. Попробуйте еще раз.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _simulatePayment() async {
    // Имитация процесса оплаты
    await Future.delayed(const Duration(seconds: 2));
    return true; // Всегда успешно для демонстрации
  }
}