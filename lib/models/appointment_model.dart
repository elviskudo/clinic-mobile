class Appointment {
    String id;
    String userId;
    String clinicId;
    String polyId;
    String doctorId;
    String dateId;
    String timeId;
    int status;
    String? rejectedNote;
    DateTime? updatedAt;
    String qrCode; // Ubah di sini
    String? symptoms;
    String? symptomDescription;
    String? aiResponse;

    Appointment({
        required this.id,
        required this.userId,
        required this.clinicId,
        required this.polyId,
        required this.doctorId,
        required this.dateId,
        required this.timeId,
        required this.status,
        this.rejectedNote,
        this.updatedAt,
        required this.qrCode,
        this.symptoms,
        this.symptomDescription,
        this.aiResponse,
    });

    factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        userId: json["user_id"],
        clinicId: json["clinic_id"],
        polyId: json["poly_id"],
        doctorId: json["doctor_id"],
        dateId: json["date_id"],
        timeId: json["time_id"],
        status: json["status"],
        rejectedNote: json["rejected_note"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        qrCode: json["qr_code"], // Ubah di sini
        symptoms: json["symptoms"],
        symptomDescription: json["symptom_description"],
        aiResponse: json["ai_response"],
    );

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
}