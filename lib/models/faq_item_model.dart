class FaqItemModel {
  FaqItemModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.sortOrder,
    this.createdAt = '',
    this.updatedAt = '',
  });

  final int id;
  final String question;
  final String answer;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      question: (json['question'] ?? '').toString(),
      answer: (json['answer'] ?? '').toString(),
      sortOrder: json['order'] is int
          ? json['order'] as int
          : int.tryParse('${json['order'] ?? 0}') ?? 0,
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
    );
  }
}
