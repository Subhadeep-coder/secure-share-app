class FileModel {
  String id;
  String fileName;
  int fileSize;
  String receiverName;
  DateTime sharedAt;
  String sharedId;

  FileModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.receiverName,
    required this.sharedAt,
    required this.sharedId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSize': fileSize,
      'receiverName': receiverName,
      'sharedId': sharedId,
      'sharedAt': sharedAt.toIso8601String(),
    };
  }

  factory FileModel.fromJson(Map<String, dynamic> file) {
    return FileModel(
      id: file['id'] ?? '',
      fileName:
          file['name'] ?? '', // Adjusted to 'name' as per your response data
      fileSize: file['size'] != null
          ? int.parse(
              file['size'].toString()) // Convert the size from string to int
          : 0, // Default to 0 if null
      receiverName:
          file['recipients_email'] ?? '', // Adjusted to 'recipients_email'
      sharedAt: file['shared_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(file['shared_at']['\$date']['\$numberLong'].toString()))
          : DateTime.now(), // Parse the nested timestamp
      sharedId: file['share_id'] ?? '',
    );
  }
}
