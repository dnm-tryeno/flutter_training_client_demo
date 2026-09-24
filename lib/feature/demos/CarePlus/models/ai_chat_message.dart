enum MessageSender {
  user,
  assistant,
  system,
}

class AIChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isEmergencyAlert;
  final List<String> quickOptions;
  final String disclaimer;

  const AIChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isEmergencyAlert = false,
    this.quickOptions = const [],
    this.disclaimer = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'sender': sender.index,
    'timestamp': timestamp.toIso8601String(),
    'isEmergencyAlert': isEmergencyAlert,
    'quickOptions': quickOptions,
    'disclaimer': disclaimer,
  };

  factory AIChatMessage.fromJson(Map<String, dynamic> json) => AIChatMessage(
    id: json['id'] as String? ?? '',
    text: json['text'] as String? ?? '',
    sender: MessageSender.values[(json['sender'] as num?)?.toInt() ?? 0],
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : DateTime.now(),
    isEmergencyAlert: json['isEmergencyAlert'] as bool? ?? false,
    quickOptions: (json['quickOptions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    disclaimer: json['disclaimer'] as String? ?? '',
  );
}
