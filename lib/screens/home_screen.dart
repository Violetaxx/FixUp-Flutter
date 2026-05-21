import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featured = mockServices.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FeedSearchBar(),
              const SizedBox(height: 24),
              const _FeedHeaderActions(),
              const SizedBox(height: 20),
              _FeedFeaturedCard(imageUrl: featured.imageUrl),
              const SizedBox(height: 24),
              const _FeedSectionHeader(title: 'Categorías'),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: mockCategories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final category = mockCategories[index];
                    return _FeedCategoryCard(category: category);
                  },
                ),
              ),
              const SizedBox(height: 24),
              const _FeedSectionHeader(title: 'Publicaciones'),
              const SizedBox(height: 16),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: mockServices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 240,
                ),
                itemBuilder: (context, index) {
                  final service = mockServices[index];
                  return _FeedPublicationCard(service: service);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedSearchBar extends StatelessWidget {
  const _FeedSearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E2D8)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.black45),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Buscar servicios...',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
              ),
            ),
          ),
          Icon(Icons.mic_none, color: Colors.black45),
        ],
      ),
    );
  }
}

class _FeedHeaderActions extends StatelessWidget {
  const _FeedHeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'Recomendados',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFCB9E50),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () {},
          child: const Text('Asistente', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFCB9E50)),
            foregroundColor: const Color(0xFFCB9E50),
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () {},
          child: const Text('Siguiendo'),
        ),
      ],
    );
  }
}

class _FeedFeaturedCard extends StatelessWidget {
  final String imageUrl;

  const _FeedFeaturedCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.network(
        imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEBE3),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(Icons.broken_image, color: Colors.black26, size: 48),
        ),
      ),
    );
  }
}

class _FeedSectionHeader extends StatelessWidget {
  final String title;

  const _FeedSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Ver todo',
            style: TextStyle(color: Color(0xFFCB9E50)),
          ),
        ),
      ],
    );
  }
}

class _FeedCategoryCard extends StatelessWidget {
  final MockCategory category;

  const _FeedCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E2D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              category.imageUrl,
              height: 76,
              width: 112,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 76,
                width: 112,
                color: const Color(0xFFEFEBE3),
                child: const Icon(Icons.broken_image, color: Colors.black26),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                category.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedPublicationCard extends StatelessWidget {
  final MockService service;

  const _FeedPublicationCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E2D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              service.imageUrl,
              height: 132,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 132,
                width: double.infinity,
                color: const Color(0xFFEFEBE3),
                child: const Icon(Icons.broken_image, color: Colors.black26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Desde ${service.price}',
                  style: const TextStyle(
                    color: Color(0xFFCB9E50),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
