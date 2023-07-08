class OrderModel {
  String id;
  String doctorName;
  String patientName;
  String patientId;
  String doctorId;
  String status;
  String bookingDate;
  String bookingTime;
  String image;
  String notes;
  String patientFcmToken;
  String doctorFcmToken;

  OrderModel({
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.bookingDate,
    required this.image,
    required this.bookingTime,
    required this.notes,
    required this.patientFcmToken,
    required this.doctorFcmToken,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      doctorName: json['doctor_name'] as String,
      patientName: json['patient_name'] as String,
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      image: json['image'],
      notes: json['notes'],
      status: json['status'] as String,
      bookingDate: json['booking_date'] as String,
      bookingTime: json['booking_time'] as String,
      patientFcmToken: json['patient_fcm_token'] as String,
      doctorFcmToken: json['doctor_fcm_token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_name': doctorName,
        'patient_name': patientName,
        'patient_id': patientId,
        'status': status,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
        'notes': notes,
        'image': image,
        'patient_fcm_token': patientFcmToken,
        'doctor_fcm_token': doctorFcmToken,
        'doctor_id': doctorId,
      };
}
