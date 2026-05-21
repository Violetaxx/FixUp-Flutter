import 'package:flutter/material.dart';
import '../data/mock_data.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────

const _bg = Color(0xFFF8F8FC);
const _card = Color(0xFFFFFFFF);
const _fawn = Color(0xFFCB9E50);
const _grey = Color(0xFF8E8E93);
const _border = Color(0xFFE6E2D8);

// ─── Mock specialists ─────────────────────────────────────────────────────────

class _Specialist {
  final String name;
  final String category;
  final String address;
  final String availability; // 'Inmediato' or 'Programado'
  final String? imageUrl;

  const _Specialist({
    required this.name,
    required this.category,
    required this.address,
    required this.availability,
    this.imageUrl,
  });
}

const _specialists = [
  _Specialist(
    name: 'Andrés Cárdenas',
    category: 'Plomería',
    address: 'Calle 72 #10-15, Bogotá',
    availability: 'Inmediato',
  ),
  _Specialist(
    name: 'Camila Rojas',
    category: 'Plomería',
    address: 'Carrera 7 #45-20, Bogotá',
    availability: 'Inmediato',
  ),
  _Specialist(
    name: 'David Ríos',
    category: 'Plomería',
    address: 'Avenida Boyacá #80-30, Bogotá',
    availability: 'Programado',
    imageUrl: 'https://picsum.photos/id/1011/100/100',
  ),
  _Specialist(
    name: 'Elena Mejía',
    category: 'Plomería',
    address: 'Calle 134 #19-40, Bogotá',
    availability: 'Programado',
    imageUrl: 'https://picsum.photos/id/1014/100/100',
  ),
];

// ─── Categories ───────────────────────────────────────────────────────────────

const _categories = [
  ('Plomería', Icons.plumbing),
  ('Electricidad', Icons.electrical_services),
  ('Aseo', Icons.cleaning_services),
  ('Reparación', Icons.build),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCategory = 0;
  String? _selectedUrgency; // null = none, 'Inmediato', 'Programado'

  List<_Specialist> get _filtered {
    return _specialists.where((s) {
      final catMatch = s.category == _categories[_selectedCategory].$1;
      final urgMatch = _selectedUrgency == null || s.availability == _selectedUrgency;
      return catMatch && urgMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          'Asistente FixUp',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── ¿Qué necesitas? ──────────────────────────────────────────
            const Text(
              '¿Qué necesitas?',
              style: TextStyle(
                  color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            // ── Category chips ───────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (i) {
                  final selected = i == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? _fawn : _card,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: selected ? _fawn : _border),
                        ),
                        child: Row(
                          children: [
                            Icon(_categories[i].$2,
                                color: selected ? Colors.white : Colors.black54,
                                size: 18),
                            const SizedBox(width: 6),
                            Text(
                              _categories[i].$1,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // ── Urgencia ─────────────────────────────────────────────────
            const Text(
              'Urgencia',
              style: TextStyle(
                  color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: ['Inmediato', 'Programado'].map((label) {
                final selected = _selectedUrgency == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedUrgency = selected ? null : label;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? _fawn : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: selected ? _fawn : _border, width: 1.5),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ── Specialists list ─────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final sp = _filtered[index];
                  return _SpecialistCard(specialist: sp);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Specialist card ──────────────────────────────────────────────────────────

class _SpecialistCard extends StatelessWidget {
  final _Specialist specialist;

  const _SpecialistCard({required this.specialist});

  @override
  Widget build(BuildContext context) {
    final isImmediate = specialist.availability == 'Inmediato';
    final badgeColor = isImmediate
        ? const Color(0xFFD32F2F)
        : const Color(0xFF5C6BC0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          // Avatar
          ClipOval(
            child: specialist.imageUrl != null
                ? Image.network(
                    specialist.imageUrl!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 52,
                    height: 52,
                    color: const Color(0xFFE5E0D5),
                    child: const Icon(Icons.person, color: Colors.black45, size: 28),
                  ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialist.name,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  specialist.category,
                  style: const TextStyle(color: _fawn, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  specialist.address,
                  style: const TextStyle(color: _grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              specialist.availability,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
