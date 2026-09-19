class FoodSuggestion {
  final String title;
  final String category; // 'Recommended', 'Limit/Avoid', 'Hydration', 'Meal Habit'
  final String description;
  final List<String> items;
  final String icon;
  final String warning;

  const FoodSuggestion({
    required this.title,
    required this.category,
    required this.description,
    required this.items,
    this.icon = 'restaurant',
    this.warning = '',
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'description': description,
    'items': items,
    'icon': icon,
    'warning': warning,
  };

  factory FoodSuggestion.fromJson(Map<String, dynamic> json) => FoodSuggestion(
    title: json['title'] as String? ?? '',
    category: json['category'] as String? ?? 'Recommended',
    description: json['description'] as String? ?? '',
    items: (json['items'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    icon: json['icon'] as String? ?? 'restaurant',
    warning: json['warning'] as String? ?? '',
  );
}
