class PlanLevelSection {
  const PlanLevelSection({
    required this.beltId,
    required this.beltTitle,
    required this.isLocked,
  });

  final int beltId;
  final String beltTitle;
  final bool isLocked;

  factory PlanLevelSection.fromJson(Map<String, dynamic> j) {
    return PlanLevelSection(
      beltId: (j['beltId'] as num?)?.toInt() ?? 0,
      beltTitle: j['beltTitle']?.toString() ?? '',
      isLocked: j['isLocked'] == true || j['isLocked'] == 1,
    );
  }
}

class PlanLevelPreviewData {
  const PlanLevelPreviewData({
    required this.planId,
    required this.planTitle,
    required this.totalLessons,
    required this.sections,
  });

  final int planId;
  final String planTitle;
  final int totalLessons;
  final List<PlanLevelSection> sections;

  factory PlanLevelPreviewData.fromJson(Map<String, dynamic> j) {
    final rawSections = j['sections'];
    final list = <PlanLevelSection>[];
    if (rawSections is List) {
      for (final e in rawSections) {
        if (e is Map) {
          list.add(PlanLevelSection.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return PlanLevelPreviewData(
      planId: (j['planId'] as num?)?.toInt() ?? 0,
      planTitle: j['planTitle']?.toString() ?? '',
      totalLessons: (j['totalLessons'] as num?)?.toInt() ?? 0,
      sections: list,
    );
  }
}
