class Metadata {
  final Map<String, dynamic> fields;

  Metadata({this.fields = const {}});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      Metadata(fields: json);

  Map<String, dynamic> toJson() => fields;
}
