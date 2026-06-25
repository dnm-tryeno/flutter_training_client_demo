import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('New post',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Pick how you want to share',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            _UploadTile(
              icon: Icons.photo_library,
              title: 'Upload from gallery',
              subtitle: 'Pick a video from your device',
              gradient: const [Color(0xFF25F4EE), Color(0xFFFE2C55)],
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _UploadTile(
              icon: Icons.videocam,
              title: 'Record video',
              subtitle: 'Use the camera (coming v2)',
              gradient: const [Color(0xFF8E24AA), Color(0xFF1E88E5)],
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _UploadTile(
              icon: Icons.live_tv,
              title: 'Go Live',
              subtitle: 'Stream to your followers',
              gradient: const [Color(0xFFFE2C55), Color(0xFFFFB300)],
              onTap: () {},
            ),
            const Spacer(),
            const Text(
              'By posting you agree to our Community Guidelines',
              style: TextStyle(color: Colors.white38, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _UploadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: gradient),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
