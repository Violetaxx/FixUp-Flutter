import 'package:flutter/material.dart';

const _bg = Color(0xFF111111);
const _card = Color(0xFF252525);
const _fawn = Color(0xFFCB9E50);
const _grey = Color(0xFF8E8E93);
const _border = Color(0xFF333333);

class ChatMessage {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  final String providerName;
  final String providerImage;
  final double providerRating;
  final String serviceName;
  final String servicePrice;

  const ChatScreen({
    super.key,
    required this.providerName,
    required this.providerImage,
    required this.providerRating,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: '¡Hola! Gracias por tu interés en mi servicio. ¿Hay algo en lo que pueda ayudarte?',
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text,
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
    });

    // Simulated provider response after delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      final responses = [
        'Excelente, te confirmo que podemos hacerlo ese día.',
        'Sí, claro, sin problema.',
        'Perfecto, te veo en la dirección indicada.',
        '¡Listo! Allá estaré a la hora acordada.',
      ];

      final providerMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: responses[DateTime.now().millisecond % responses.length],
        isFromUser: false,
        timestamp: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _messages.add(providerMessage);
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.providerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.serviceName,
              style: const TextStyle(
                color: _grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.star, color: _fawn, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.providerRating.toString(),
                    style: const TextStyle(
                      color: _fawn,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Service info card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    widget.providerImage,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Precio: ${widget.servicePrice}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _fawn,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isFromUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isFromUser ? _fawn : _card,
                      borderRadius: BorderRadius.circular(16),
                      border: msg.isFromUser
                          ? null
                          : Border.all(color: _border),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isFromUser ? Colors.white : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input field
          Container(
            decoration: BoxDecoration(
              color: _card,
              border: Border(top: BorderSide(color: _border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe tu mensaje...',
                        hintStyle: const TextStyle(color: _grey),
                        filled: true,
                        fillColor: _bg,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: _border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: _border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: _fawn),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _fawn,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
