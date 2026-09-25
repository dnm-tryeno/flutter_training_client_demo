import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';

class ContactSection extends StatefulWidget {
  final bool isDark;
  final ProfileConfigModel config;

  const ContactSection({
    super.key,
    required this.isDark,
    required this.config,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedService = 'Website Development';

  final List<String> _servicesList = [
    'Website Development',
    'App Development (Flutter)',
    'Meta Ads (FB & Insta)',
    'SEO & Google Ranking',
    'Google Ads (PPC)',
    'Digital Marketing & Lead Gen',
    'Other / General Enquiry',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      final message = _messageController.text.trim();

      final fullMessage = '''
*Namaste ${widget.config.name} ji, New Project Enquiry:*
👤 *Name:* $name
📞 *Phone:* $phone
📧 *Email:* ${email.isEmpty ? 'Not provided' : email}
🎯 *Service Needed:* $_selectedService
💬 *Message:* $message
''';

      UrlHelper.openWhatsApp(
        phone: widget.config.whatsappNumber,
        message: fullMessage,
        context: context,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening WhatsApp with your message details...'),
          backgroundColor: AppColors.whatsappGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final textPrimary = widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final config = widget.config;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 64 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Get in Touch / Sampark Karein',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                config.contactHeading.isNotEmpty ? config.contactHeading : 'Let’s Discuss Your Next Big Project',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium(context, isDark: widget.isDark),
              ),
              const SizedBox(height: 8),
              Text(
                config.contactSubtitle.isNotEmpty
                    ? config.contactSubtitle
                    : 'Aapke business requirements ke mutabik customized proposal aur free guidance paayein.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(context, isDark: widget.isDark),
              ),
              const SizedBox(height: 40),

              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildContactInfoCard(context, textPrimary)),
                        const SizedBox(width: 32),
                        Expanded(flex: 6, child: _buildContactForm(context, textPrimary)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildContactInfoCard(context, textPrimary),
                        const SizedBox(height: 32),
                        _buildContactForm(context, textPrimary),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(BuildContext context, Color textPrimary) {
    final config = widget.config;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            config.tagline,
            style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),

          // Phone
          _buildInfoTile(
            icon: Icons.phone_in_talk_rounded,
            title: 'Phone Number',
            value: config.phone,
            actionLabel: 'Call Now',
            color: AppColors.callBlue,
            onTap: () => UrlHelper.makePhoneCall(phone: config.phone, context: context),
          ),
          const SizedBox(height: 16),

          // WhatsApp
          _buildInfoTile(
            icon: Icons.chat_rounded,
            title: 'WhatsApp Direct Chat',
            value: '+91 ${config.whatsappNumber}',
            actionLabel: 'Message',
            color: AppColors.whatsappGreen,
            onTap: () => UrlHelper.openWhatsApp(
              phone: config.whatsappNumber,
              message: config.whatsappDefaultMessage,
              context: context,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          _buildInfoTile(
            icon: Icons.mail_rounded,
            title: 'Email Address',
            value: config.email,
            actionLabel: 'Send Mail',
            color: AppColors.mailRed,
            onTap: () => UrlHelper.sendEmail(email: config.email, context: context),
          ),
          const SizedBox(height: 16),

          // Location
          _buildInfoTile(
            icon: Icons.location_on_rounded,
            title: 'Office / Location',
            value: config.location,
            actionLabel: 'View Map',
            color: AppColors.accent,
            onTap: () => UrlHelper.openMapLocation(
              query: config.mapsEmbedQuery.isNotEmpty ? config.mapsEmbedQuery : config.location,
              context: context,
            ),
          ),
          const SizedBox(height: 24),

          // Google Maps Preview Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.map_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      config.locationShort,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Local support available across ${config.locationShort} & remote clients worldwide.',
                  style: AppTypography.caption(context, isDark: widget.isDark),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => UrlHelper.openMapLocation(
                      query: config.mapsEmbedQuery.isNotEmpty ? config.mapsEmbedQuery : config.location,
                      context: context,
                    ),
                    icon: const Icon(Icons.directions_rounded, size: 16),
                    label: const Text('Open in Google Maps'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required String actionLabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Form fill karein aur direct WhatsApp par instant proposal paayein.',
              style: AppTypography.bodyMedium(context, isDark: widget.isDark),
            ),
            const SizedBox(height: 20),

            // Name
            _buildFormField(
              controller: _nameController,
              label: 'Your Name (Aapka Naam) *',
              hint: 'e.g. Rahul Sharma',
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 14),

            // Phone
            _buildFormField(
              controller: _phoneController,
              label: 'Phone Number (Mobile No) *',
              hint: 'e.g. 9876543210',
              icon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().length < 10) ? 'Enter valid 10-digit number' : null,
            ),
            const SizedBox(height: 14),

            // Email
            _buildFormField(
              controller: _emailController,
              label: 'Email Address (Optional)',
              hint: 'e.g. rahul@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),

            // Service Dropdown
            Text(
              'Select Service Required *',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedService,
                  isExpanded: true,
                  dropdownColor: widget.isDark ? AppColors.darkSurface : Colors.white,
                  items: _servicesList.map((s) {
                    return DropdownMenuItem<String>(
                      value: s,
                      child: Text(s, style: TextStyle(color: textPrimary, fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedService = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Message
            _buildFormField(
              controller: _messageController,
              label: 'Project Details / Message *',
              hint: 'Describe your website, app, or marketing requirements...',
              icon: Icons.chat_bubble_outline_rounded,
              maxLines: 3,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter message details' : null,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'Send via WhatsApp Chat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whatsappGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: widget.isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
