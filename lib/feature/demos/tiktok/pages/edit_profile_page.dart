import 'package:flutter/material.dart';

import '../theme.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
        title: const Text('Edit profile',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save',
                style: TextStyle(
                  color: TikTokColors.primary,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: TikTokColors.primary,
                  child: Text('Y',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.black, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Change photo',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          const SizedBox(height: 24),
          const _FieldRow(label: 'Name', value: 'Your Name'),
          const _FieldRow(label: 'Username', value: '@you'),
          const _FieldRow(
            label: 'Bio',
            value: 'Flutter dev · building StarTik 🚀\nMVP launching soon',
            multiline: true,
          ),
          const _FieldRow(label: 'Pronouns', value: 'Add pronouns'),
          const Divider(color: Colors.white12, height: 32),
          const _SectionHeader('Social'),
          const _FieldRow(label: 'Instagram', value: 'Add Instagram to your profile'),
          const _FieldRow(label: 'YouTube', value: 'Add YouTube to your profile'),
          const Divider(color: Colors.white12, height: 32),
          const _SectionHeader('Private information'),
          const _FieldRow(label: 'Email', value: 'you@example.com'),
          const _FieldRow(label: 'Phone', value: 'Add phone number'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String value;
  final bool multiline;
  const _FieldRow({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: multiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14)),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
