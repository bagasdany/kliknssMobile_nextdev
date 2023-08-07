class NotificationModel {
  String? notificationId;
  String? notificationTitle;
  String? notificationBody;
  String? notificationType;
  Map<String, dynamic>? notificationData;

  NotificationModel({
    this.notificationId,
    this.notificationTitle,
    this.notificationBody,
    this.notificationType,
    this.notificationData,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> parsedJson) {
    return NotificationModel(
      notificationId: parsedJson['notificationId'].toString(),
      notificationTitle: parsedJson['notificationTitle'].toString(),
      notificationBody: parsedJson['notificationBody'].toString(),
      notificationType: parsedJson['notificationType'].toString(),
    );
  }
}
