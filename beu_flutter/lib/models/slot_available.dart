import 'package:beu_flutter/models/time_slot.dart';

class slot_availability {
  List<TimeSlot> slotTime;

  slot_availability({this.slotTime});

  slot_availability.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      slotTime = new List<TimeSlot>();
      json['data'].forEach((v) {
        if (v['status'] == "yes") slotTime.add(new TimeSlot.fromJson(v));
      });
    }
  }
}
