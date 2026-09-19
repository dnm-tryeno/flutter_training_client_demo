import 'package:flutter/material.dart';
import '../models/ai_chat_message.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/language_selector_button.dart';
import 'patient_info_page.dart';
import 'doctor_consult_page.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _listScroll = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  void _sendMessage([String? textOverride]) {
    final text = textOverride ?? _msgCtrl.text.trim();
    if (text.isEmpty) return;

    final state = CarePlusStateScope.of(context);
    state.sendUserChatMessage(text);
    _msgCtrl.clear();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_listScroll.hasClients) {
        _listScroll.animateTo(
          _listScroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CarePlus AI',
                  style: TextStyle(fontSize: 16 * state.fontScale, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Educational Health Companion',
                  style: TextStyle(
                    fontSize: 11 * state.fontScale,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const LanguageSelectorButton(),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Clear Chat',
            onPressed: () => state.clearChatMessages(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DisclaimerBanner(compact: true),
            ),
            Expanded(
              child: ListView.builder(
                controller: _listScroll,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: state.chatMessages.length + (state.isAIThinking ? 1 : 0),
                itemBuilder: (ctx, idx) {
                  if (idx >= state.chatMessages.length) {
                    // Thinking indicator
                    return _buildThinkingBubble(isDark, state);
                  }
                  final msg = state.chatMessages[idx];
                  return _buildMessageBubble(msg, isDark, state);
                },
              ),
            ),
            _buildInputBar(isDark, state),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(AIChatMessage msg, bool isDark, CarePlusState state) {
    final isUser = msg.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: msg.isEmergencyAlert ? AppColors.emergency : AppColors.primary,
                  child: Icon(
                    msg.isEmergencyAlert ? Icons.emergency_rounded : Icons.auto_awesome,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : msg.isEmergencyAlert
                            ? (isDark ? const Color(0xFF4C0519) : const Color(0xFFFFF1F2))
                            : (isDark ? const Color(0xFF1E293B) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: !isUser
                        ? Border.all(
                            color: msg.isEmergencyAlert
                                ? AppColors.emergency
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 14 * state.fontScale,
                          color: isUser
                              ? Colors.white
                              : msg.isEmergencyAlert
                                  ? (isDark ? Colors.red[200] : AppColors.emergencyDark)
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
              ],
            ],
          ),
          if (msg.quickOptions.isNotEmpty && !isUser) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: msg.quickOptions.map((opt) {
                  return ActionChip(
                    label: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 12 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.primarySurface,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () {
                      if (opt.toLowerCase().contains('check my health')) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PatientInfoPage()),
                        );
                      } else if (opt.toLowerCase().contains('emergency') || opt.toLowerCase().contains('doctor')) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DoctorConsultPage()),
                        );
                      } else {
                        _sendMessage(opt);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThinkingBubble(bool isDark, CarePlusState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.auto_awesome, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  'CarePlus AI is formulating safe guidance...',
                  style: TextStyle(
                    fontSize: 12 * state.fontScale,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isDark, CarePlusState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(
                fontSize: 14 * state.fontScale,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: state.tr('ai_type_hint'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}
