import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'checkout_screen.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────

const _bg = Color(0xFFF8F8FC);
const _card = Color(0xFFFFFFFF);
const _fawn = Color(0xFFCB9E50);
const _grey = Color(0xFF8E8E93);
const _border = Color(0xFFE6E2D8);

// ─── Mock review model ────────────────────────────────────────────────────────

class MockReview {
  final String id;
  final String authorName;
  final String authorImageUrl;
  final String serviceTitle;
  final int rating;
  final String comment;
  final int likeCount;
  final bool isLiked;

  const MockReview({
    required this.id,
    required this.authorName,
    required this.authorImageUrl,
    required this.serviceTitle,
    required this.rating,
    required this.comment,
    required this.likeCount,
    required this.isLiked,
  });
}

final _mockReviews = [
  const MockReview(
    id: '1',
    authorName: 'juanmateomadrigal',
    authorImageUrl: 'https://picsum.photos/id/1005/100/100',
    serviceTitle: 'Reparación de grifería',
    rating: 5,
    comment: 'esta es una reseña de prueba',
    likeCount: 0,
    isLiked: false,
  ),
  const MockReview(
    id: '2',
    authorName: 'juanmateomadrigal',
    authorImageUrl: 'https://picsum.photos/id/1005/100/100',
    serviceTitle: '',
    rating: 4,
    comment: 'funciono',
    likeCount: 5,
    isLiked: false,
  ),
  const MockReview(
    id: '3',
    authorName: 'Emanuel Benavides',
    authorImageUrl: 'https://picsum.photos/id/1012/100/100',
    serviceTitle: 'Reparación de grifería',
    rating: 5,
    comment: 'Esperemos qu funcione...',
    likeCount: 5,
    isLiked: false,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ServiceDetailScreen extends StatefulWidget {
  final MockService service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isFollowing = true;
  bool _isReviewExpanded = false;
  int _reviewRating = 5;
  final _reviewController = TextEditingController();
  late List<MockReview> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List.from(_mockReviews);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _publishReview() {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe un comentario')),
      );
      return;
    }

    final newReview = MockReview(
      id: 'r_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Mi Cuenta',
      authorImageUrl: 'https://picsum.photos/id/1009/100/100',
      serviceTitle: widget.service.title,
      rating: _reviewRating,
      comment: _reviewController.text,
      likeCount: 0,
      isLiked: false,
    );

    setState(() {
      _reviews.insert(0, newReview);
      _reviewController.clear();
      _reviewRating = 5;
      _isReviewExpanded = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Reseña publicada exitosamente!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Detalle de Publicación',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Stack(
              children: [
                Image.network(
                  s.imageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & price
                  Text(s.title,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('Desde ${s.price}',
                      style: const TextStyle(
                          fontSize: 22, color: _fawn, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Descripción',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(s.description,
                      style: const TextStyle(fontSize: 15, color: _grey, height: 1.5)),

                  const SizedBox(height: 24),

                  // Fixer card
                  _FixerCard(
                    isFollowing: _isFollowing,
                    onFollowToggle: () => setState(() => _isFollowing = !_isFollowing),
                  ),

                  const SizedBox(height: 24),

                  // Benefits
                  const _BenefitsRow(),

                  const SizedBox(height: 24),

                  // Review input
                  _ReviewInputCard(
                    isExpanded: _isReviewExpanded,
                    rating: _reviewRating,
                    controller: _reviewController,
                    onToggle: () =>
                        setState(() => _isReviewExpanded = !_isReviewExpanded),
                    onRatingChanged: (r) => setState(() => _reviewRating = r),
                    onPublish: _publishReview,
                  ),

                  const SizedBox(height: 24),

                  // Reviews
                  _ReviewsSection(reviews: _reviews),

                  const SizedBox(height: 24),

                  // Action buttons
                  _ActionButtons(service: widget.service),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fixer card ───────────────────────────────────────────────────────────────

class _FixerCard extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onFollowToggle;

  const _FixerCard({required this.isFollowing, required this.onFollowToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              'https://picsum.photos/id/1005/100/100',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Tu Especialista FixUp',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                Text('Verificado • 4.8 ★',
                    style: TextStyle(
                        color: _fawn, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(
                  'Profesional con más de 5 años de experiencia en servicios para el hogar.',
                  style: TextStyle(fontSize: 12, color: _grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onFollowToggle,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _fawn),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              foregroundColor: _fawn,
              backgroundColor: Colors.transparent,
              minimumSize: const Size(0, 34),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              isFollowing ? 'Siguiendo' : 'Seguir',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Benefits ─────────────────────────────────────────────────────────────────

class _BenefitsRow extends StatelessWidget {
  const _BenefitsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _BenefitItem(icon: Icons.verified_user_outlined, label: 'Garantía'),
        _BenefitItem(icon: Icons.bolt_outlined, label: 'Rápido'),
        _BenefitItem(icon: Icons.support_agent_outlined, label: 'Soporte'),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BenefitItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _fawn.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _fawn, size: 30),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
      ],
    );
  }
}

// ─── Review input card ────────────────────────────────────────────────────────

class _ReviewInputCard extends StatelessWidget {
  final bool isExpanded;
  final int rating;
  final TextEditingController controller;
  final VoidCallback onToggle;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onPublish;

  const _ReviewInputCard({
    required this.isExpanded,
    required this.rating,
    required this.controller,
    required this.onToggle,
    required this.onRatingChanged,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.rate_review, color: _fawn, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('¿Cómo fue tu experiencia?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87)),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final sel = i < rating;
                      return GestureDetector(
                        onTap: () => onRatingChanged(i + 1),
                        child: Icon(
                          sel ? Icons.star : Icons.star_border,
                          color: sel ? const Color(0xFFFFC107) : _grey,
                          size: 42,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Cuéntanos más detalles del servicio...',
                      hintStyle: const TextStyle(color: _grey),
                      filled: true,
                      fillColor: _bg,
                      contentPadding: const EdgeInsets.all(14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: _border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: _fawn),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onPublish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _fawn,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text('Publicar Reseña',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Reviews section ──────────────────────────────────────────────────────────

class _ReviewsSection extends StatelessWidget {
  final List<MockReview> reviews;

  const _ReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Opiniones de la comunidad',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _fawn.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(reviews.length.toString(),
                  style: const TextStyle(
                      color: _fawn, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...reviews.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ReviewCard(review: r),
            )),
      ],
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final MockReview review;

  const _ReviewCard({required this.review});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  late bool _liked;
  late int _count;

  @override
  void initState() {
    super.initState();
    _liked = widget.review.isLiked;
    _count = widget.review.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  widget.review.authorImageUrl,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.review.authorName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: _fawn)),
                    if (widget.review.serviceTitle.isNotEmpty)
                      Text('comentó sobre: ${widget.review.serviceTitle}',
                          style: const TextStyle(fontSize: 12, color: _grey)),
                    Row(
                      children: List.generate(5, (i) => Icon(
                            i < widget.review.rating ? Icons.star : Icons.star_border,
                            color: i < widget.review.rating
                                ? const Color(0xFFFFC107)
                                : _grey,
                            size: 14,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _liked = !_liked;
                  _count += _liked ? 1 : -1;
                }),
                child: Row(
                  children: [
                    Icon(
                      _liked ? Icons.favorite : Icons.favorite_border,
                      color: _liked ? Colors.red : _grey,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(_count.toString(),
                        style: const TextStyle(fontSize: 14, color: _grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(widget.review.comment,
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
        ],
      ),
    );
  }
}

// ─── Action buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final MockService service;

  const _ActionButtons({required this.service});

  void _goToCheckout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(service: service),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => _goToCheckout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _fawn,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Ir al Pago',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _fawn, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              foregroundColor: _fawn,
            ),
            child: const Text('Contactar Especialista',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
