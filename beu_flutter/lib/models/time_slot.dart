class TimeSlot {
  String slotid;
  String slot_starttime;
  String slot_endtime;
  String status;

  TimeSlot({
    this.slotid,
    this.slot_starttime,
    this.slot_endtime,
    this.status,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      slotid: json["slotid"].toString(),
      slot_starttime: json["slot_starttime"].toString(),
      slot_endtime: json["slot_endtime"].toString(),
      status: json["status"].toString(),
    );
  }
}