class CmsPageModel {
  CmsPageModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    this.createdAt = '',
    this.updatedAt = '',
  });

  final int id;
  final String title;
  final String slug;
  /// Raw HTML from the API.
  final String content;
  final String createdAt;
  final String updatedAt;

  factory CmsPageModel.fromJson(Map<String, dynamic> json) {
    return CmsPageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
    );
  }
}
