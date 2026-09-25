class ProjectModel {
  final String id;
  final String title;
  final String category; // 'All', 'Website', 'App', 'Meta Ads', 'SEO'
  final String shortDesc;
  final String detailedDesc;
  final List<String> techStack;
  final String? liveDemoUrl;
  final String? githubUrl;
  final String imageUrl;
  final List<String> keyFeatures;
  final String? resultsMetric; // e.g. "3.5x ROI", "10k+ Downloads", "Rank #1 Google"
  final bool isFeatured;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDesc,
    required this.detailedDesc,
    required this.techStack,
    this.liveDemoUrl,
    this.githubUrl,
    required this.imageUrl,
    this.keyFeatures = const [],
    this.resultsMetric,
    this.isFeatured = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'shortDesc': shortDesc,
        'detailedDesc': detailedDesc,
        'techStack': techStack,
        'liveDemoUrl': liveDemoUrl,
        'githubUrl': githubUrl,
        'imageUrl': imageUrl,
        'keyFeatures': keyFeatures,
        'resultsMetric': resultsMetric,
        'isFeatured': isFeatured,
      };

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Untitled Project',
      category: json['category'] as String? ?? 'Website',
      shortDesc: json['shortDesc'] as String? ?? '',
      detailedDesc: json['detailedDesc'] as String? ?? '',
      techStack: List<String>.from(json['techStack'] ?? []),
      liveDemoUrl: json['liveDemoUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      imageUrl: json['imageUrl'] as String? ?? '',
      keyFeatures: List<String>.from(json['keyFeatures'] ?? []),
      resultsMetric: json['resultsMetric'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? category,
    String? shortDesc,
    String? detailedDesc,
    List<String>? techStack,
    String? liveDemoUrl,
    String? githubUrl,
    String? imageUrl,
    List<String>? keyFeatures,
    String? resultsMetric,
    bool? isFeatured,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      shortDesc: shortDesc ?? this.shortDesc,
      detailedDesc: detailedDesc ?? this.detailedDesc,
      techStack: techStack ?? this.techStack,
      liveDemoUrl: liveDemoUrl ?? this.liveDemoUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      resultsMetric: resultsMetric ?? this.resultsMetric,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
