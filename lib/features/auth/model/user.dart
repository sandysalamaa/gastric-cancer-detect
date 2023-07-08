enum UserType {
  patient('patient'),
  doctor('doctor');

  final String type;
  const UserType(this.type);
  factory UserType.fromValue(String type) {
    switch (type) {
      case 'patient':
        return UserType.patient;
      case 'doctor':
        return UserType.doctor;
      default:
        return UserType.patient;
    }
  }
}

abstract class BaseUser {
  final String id;
  final UserType type;
  final String fcmToken;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  BaseUser({
    required this.id,
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.fcmToken,
  });
}

BaseUser userFromJson(Map<String, dynamic> map) {
  if (UserType.fromValue(map['type']) == UserType.patient) {
    return Patient.fromJson(map);
  } else {
    return Doctor.fromJson(map);
  }
}

class Patient extends BaseUser {
  final String? image;

  Patient({
    required this.image,
    required super.id,
    required super.type,
    required super.fcmToken,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
  });

  factory Patient.fromJson(Map<String, dynamic> map) {
    return Patient(
      image: map['image'],
      fcmToken: map['fcm_token'] ?? "",
      id: map['id'],
      type: UserType.fromValue(map['type']),
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
  Map<String, dynamic> toMap() => {
        'image': image,
        'id': id,
        'type': type.type,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'fcm_token': fcmToken,
      };
}

class Doctor extends BaseUser {
  final String image;
  final String education;
  final String speciality;
  final String description;
  final List<RateModel>? rates;
  final List<TimeModel>? times;
  Doctor({
    required this.image,
    required super.id,
    required super.fcmToken,
    required super.type,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required this.education,
    required this.speciality,
    required this.description,
    required this.rates,
    required this.times,
  });

  factory Doctor.fromJson(Map<String, dynamic> map) {
    return Doctor(
      image: map['image'],
      id: map['id'],
      fcmToken: map['fcm_token'] ?? "",
      type: UserType.fromValue(map['type']),
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      education: map['education'],
      speciality: map['speciality'],
      description: map['description'],
      rates: map['rates'] != null
          ? List<RateModel>.from(
              map['rates']?.map((x) => RateModel.fromJson(x)))
          : [],
      times: map['times'] != null
          ? List<TimeModel>.from(
              map['times']?.map((x) => TimeModel.fromJson(x)))
          : [],
    );
  }
  Map<String, dynamic> toMap() => {
        'image': image,
        'id': id,
        'type': type.type,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'rates': rates,
        'education': education,
        'speciality': speciality,
        'description': description,
        'times': rates,
        'fcm_token': fcmToken,
      };
}

class RateModel {
  String image;
  int rateCount;
  String comment;
  String name;

  RateModel({
    required this.image,
    required this.rateCount,
    required this.comment,
    required this.name,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      image: json['image'] as String,
      rateCount: json['rate_count'] as int,
      comment: json['comment'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'rateCount': rateCount,
      'comment': comment,
      'name': name,
    };
  }
}

class TimeModel {
  String time;
  String date;
  String day;
  bool isReserved;

  TimeModel({
    required this.time,
    required this.date,
    required this.day,
    required this.isReserved,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(
      time: json['time'] as String,
      date: json['date'] as String,
      day: json['day'] as String,
      isReserved: json['is_reserved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'day': day,
      'date': date,
      'is_reserved': isReserved,
    };
  }
}
