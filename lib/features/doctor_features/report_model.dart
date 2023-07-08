class ReportModel {
  String title;
  String hint;
  String description;
  String warning;

  ReportModel({
    required this.title,
    required this.hint,
    required this.description,
    required this.warning,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      title: json['title'],
      hint: json['hint'] as String,
      description: json['description'] as String,
      warning: json['warning'],
    );
  }
}
