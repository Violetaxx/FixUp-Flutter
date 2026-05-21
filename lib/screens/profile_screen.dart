import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewModel {
  final String id;
  final String authorName;
  final String authorImageUrl;
  final String serviceTitle;
  final int rating;
  final String comment;
  final String date;
  final List<String> likedBy;

  ReviewModel({
    required this.id,
    required this.authorName,
    this.authorImageUrl = '',
    this.serviceTitle = '',
    this.rating = 0,
    this.comment = '',
    this.date = '',
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  bool _isImageUploading = false;
  String _profileImageUrl = '';
  String _name = 'Juan Pérez';
  String _role = 'Cliente estrella';

  final ImagePicker _picker = ImagePicker();

  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: 'r1',
      authorName: 'María Gómez',
      rating: 5,
      comment: 'Excelente servicio, muy puntual y profesional.',
      date: '2024-06-01',
      likedBy: ['u1', 'u2'],
      serviceTitle: 'Plomería',
    ),
    ReviewModel(
      id: 'r2',
      authorName: 'Carlos Ruiz',
      rating: 4,
      comment: 'Buen trabajo, pero tardó un poco.',
      date: '2024-05-12',
      likedBy: ['u3'],
      serviceTitle: 'Electricidad',
    ),
  ];

  void _toggleLike(String reviewId) {
    setState(() {
      final r = _reviews.firstWhere((e) => e.id == reviewId);
      if (r.likedBy.contains('me')) {
        r.likedBy.remove('me');
      } else {
        r.likedBy.add('me');
      }
    });
  }

  void _deleteReview(String reviewId) {
    setState(() {
      _reviews.removeWhere((r) => r.id == reviewId);
    });
  }

  void _editReview(String reviewId, int rating, String comment) {
    setState(() {
      final idx = _reviews.indexWhere((r) => r.id == reviewId);
      if (idx != -1) {
        _reviews[idx] = ReviewModel(
          id: _reviews[idx].id,
          authorName: _reviews[idx].authorName,
          authorImageUrl: _reviews[idx].authorImageUrl,
          serviceTitle: _reviews[idx].serviceTitle,
          rating: rating,
          comment: comment,
          date: _reviews[idx].date,
          likedBy: _reviews[idx].likedBy,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8F8FC);
    const softFawn = Color(0xFFC4A36C);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _showEditProfileDialog(context),
          icon: const Icon(Icons.edit),
          color: softFawn,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            color: softFawn,
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading && _reviews.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _isImageUploading ? null : () => _onChangePhotoTapped(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 130,
                              height: 130,
                              color: Colors.white,
                                child: _profileImageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 64, color: Colors.black26)
                                  : _profileImageUrl.startsWith('http')
                                    ? Image.network(_profileImageUrl, fit: BoxFit.cover)
                                    : Image.file(File(_profileImageUrl), fit: BoxFit.cover),
                            ),
                          ),
                          if (_isImageUploading)
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: const Color(0x66000000),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: softFawn,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _name,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.normal, color: softFawn),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _role,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 36),

                    // Reviews section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mis Reseñas',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          if (_reviews.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              alignment: Alignment.center,
                              child: Text(
                                'Aún no has realizado reseñas.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _reviews.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final r = _reviews[index];
                                return _ReviewItem(
                                  review: r,
                                  onLike: () => _toggleLike(r.id),
                                  onDelete: () => _deleteReview(r.id),
                                  onEdit: (rating, comment) => _editReview(r.id, rating, comment),
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSavedProfileImage();
  }

  Future<void> _loadSavedProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path') ?? '';
    if (path.isNotEmpty) {
      setState(() {
        _profileImageUrl = path;
      });
    }
  }

  Future<void> _onChangePhotoTapped(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la galería'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancelar'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isImageUploading = true);
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile${p.extension(picked.path)}';
      final savedPath = p.join(appDir.path, fileName);

      final savedFile = await File(picked.path).copy(savedPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', savedFile.path);

      setState(() {
        _profileImageUrl = savedFile.path;
      });
    } catch (e) {
      // ignore errors for now
    } finally {
      setState(() => _isImageUploading = false);
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _name);
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Información Personal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Dirección')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback onLike;
  final VoidCallback onDelete;
  final void Function(int, String) onEdit;

  const _ReviewItem({
    required this.review,
    required this.onLike,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = review.likedBy.contains('me');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: review.authorImageUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.black26)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (review.serviceTitle.isNotEmpty)
                        Text('comentó sobre: ${review.serviceTitle}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(onPressed: () => _showEditDialog(context), icon: const Icon(Icons.edit, size: 18)),
                    IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, size: 18, color: Colors.red)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (i) => Icon(i < review.rating ? Icons.star : Icons.star_border, color: const Color(0xFFFFB300), size: 16)),
                ),
                InkWell(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.grey, size: 18),
                      const SizedBox(width: 6),
                      Text(review.likedBy.length.toString(), style: const TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment),
            const SizedBox(height: 4),
            Text(review.date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final ratingController = TextEditingController(text: review.rating.toString());
    final commentController = TextEditingController(text: review.comment);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Reseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: ratingController, decoration: const InputDecoration(labelText: 'Rating (1-5)')),
            TextField(controller: commentController, decoration: const InputDecoration(labelText: 'Comentario')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              final rating = int.tryParse(ratingController.text) ?? review.rating;
              onEdit(rating, commentController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}