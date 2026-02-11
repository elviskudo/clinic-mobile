import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';

class Appointment {
  String id;
  String userId;
  Doctor? doctor;
  Poly? poly;
  Clinic? clinic;
  ScheduleDate? date;
  ScheduleTime? time;
  String clinicId;
  String polyId;
  String doctorId;
  String dateId;
  String timeId;
  int status;
  String? rejectedNote;
  DateTime updatedAt;
  DateTime createdAt;
  String qrCode; // Ubah di sini
  String? symptoms;
  String? symptomDescription;
  String? aiResponse;
  String? user_name;
  String? poly_name;

  Appointment({
    required this.id,
    this.doctor, // Masukkan ke constructor
    this.poly,
    this.clinic,
    this.date,
    this.time,
    required this.userId,
    required this.clinicId,
    required this.polyId,
    required this.doctorId,
    required this.dateId,
    required this.timeId,
    required this.status,
    this.user_name,
    this.poly_name,
    required this.createdAt,
    this.rejectedNote,
    required this.updatedAt,
    required this.qrCode,
    this.symptoms,
    this.symptomDescription,
    this.aiResponse,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      // PENGAMAN: Tambahkan ?? "" pada semua field String
      id: json["id"] ?? "",
      userId: json["user_id"] ?? "",

      // Handle Relasi Object (Doctor, Clinic, dll)
      doctor: json["doctor"] != null ? Doctor.fromJson(json["doctor"]) : null,
      poly: json["poly"] != null ? Poly.fromJson(json["poly"]) : null,
      clinic: json["clinic"] != null ? Clinic.fromJson(json["clinic"]) : null,
      date: json["date"] != null ? ScheduleDate.fromJson(json["date"]) : null,
      time: json["time"] != null ? ScheduleTime.fromJson(json["time"]) : null,

      clinicId: json["clinic_id"] ?? "",
      polyId: json["poly_id"] ?? "",
      doctorId: json["doctor_id"] ?? "",
      dateId: json["date_id"] ?? "",
      timeId: json["time_id"] ?? "",

      status: json["status"] ?? 0, // Default 0 jika null

      rejectedNote: json["rejected_note"], // Boleh null

      // Handle Tanggal agar tidak error format
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
          : DateTime.now(),
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
          : DateTime.now(),

      qrCode: json["qr_code"] ?? "-", // Default "-" jika null

      symptoms: json["symptoms"],
      symptomDescription: json["symptom_description"],
      aiResponse: json["ai_response"],

      // Helper untuk Nama (Ambil dari dalam object relasi)
      user_name: json["user"] != null ? json["user"]["name"] : null,
      poly_name: json["poly"] != null ? json["poly"]["name"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "clinic_id": clinicId,
        "poly_id": polyId,
        "doctor_id": doctorId,
        "date_id": dateId,
        "time_id": timeId,
        "status": status,
        "rejected_note": rejectedNote,
        "qr_code": qrCode, // Ubah di sini
        "symptoms": symptoms,
        "symptom_description": symptomDescription,
        "ai_response": aiResponse,
      };

  Appointment copyWith({
    String? id,
    String? userId,
    String? clinicId,
    String? polyId,
    String? doctorId,
    String? dateId,
    String? timeId,
    int? status,
    String? rejectedNote,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? qrCode,
    String? symptoms,
    String? symptomDescription,
    String? aiResponse,
    String? user_name,
    String? poly_name,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clinicId: clinicId ?? this.clinicId,
      polyId: polyId ?? this.polyId,
      doctorId: doctorId ?? this.doctorId,
      dateId: dateId ?? this.dateId,
      timeId: timeId ?? this.timeId,
      status: status ?? this.status,
      rejectedNote: rejectedNote ?? this.rejectedNote,
      updatedAt: updatedAt ?? this.updatedAt,
      qrCode: qrCode ?? this.qrCode,
      symptoms: symptoms ?? this.symptoms,
      symptomDescription: symptomDescription ?? this.symptomDescription,
      aiResponse: aiResponse ?? this.aiResponse,
      user_name: user_name ?? this.user_name,
      poly_name: poly_name ?? this.poly_name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  List<int> getSymptomIds() {
    if (symptoms == null || symptoms!.isEmpty) {
      return [];
    }

    return symptoms!
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .map((id) => int.tryParse(id) ?? -1)
        .where((id) => id != -1)
        .toList();
  }
}
