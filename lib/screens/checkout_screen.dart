import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'chat_screen.dart';

const _bg = Color(0xFFF8F8FC);
const _card = Color(0xFFFFFFFF);
const _fawn = Color(0xFFCB9E50);
const _grey = Color(0xFF8E8E93);
const _border = Color(0xFFE6E2D8);

class CheckoutScreen extends StatefulWidget {
  final MockService service;

  const CheckoutScreen({super.key, required this.service});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  void _completeOrder() {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            providerName: widget.service.provider,
            providerImage: 'https://picsum.photos/id/1005/100/100',
            providerRating: widget.service.rating,
            serviceName: widget.service.title,
            servicePrice: widget.service.price,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final priceStr = s.price.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll('.', '');
    final price = double.tryParse(priceStr.replaceAll(',', '.')) ?? 0.0;
    final subtotal = price;
    final tax = subtotal * 0.08;
    final total = subtotal + tax;

    return PopScope(
      canPop: !_isProcessing,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          leading: _isProcessing
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.maybePop(context),
                ),
          title: const Text(
            'Resumen del Pedido',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        s.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Service details card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: _fawn, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                s.location,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: _fawn, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '${s.rating} • ${s.provider}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Descripción',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _grey,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order summary card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow(
                            label: 'Subtotal',
                            value: '\$${subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                          ),
                          const SizedBox(height: 12),
                          _SummaryRow(
                            label: 'Impuestos (8%)',
                            value: '\$${tax.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: _border, height: 1),
                          const SizedBox(height: 12),
                          _SummaryRow(
                            label: 'Total',
                            value: '\$${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment method
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _fawn.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.credit_card, color: _fawn),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tarjeta de Crédito',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '**** **** **** 4242',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle, color: _fawn),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // Bottom button area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: _bg,
                  border: Border(top: BorderSide(color: _border)),
                ),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _completeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _fawn,
                        disabledBackgroundColor: _grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Haz un Pedido',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black87 : _grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? _fawn : Colors.black87,
          ),
        ),
      ],
    );
  }
}
