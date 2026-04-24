import 'package:flutter/foundation.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/date_time_entity.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/payment_option_entity.dart';

class BookingEntity extends ChangeNotifier {
  DateTimeEntity? _dateTimeEntity;
  PaymentOptionEntity? _paymentOptionEntity;

  BookingEntity({
    DateTimeEntity? dateTimeEntity,
    PaymentOptionEntity? paymentOptionEntity,
  }) : _dateTimeEntity = dateTimeEntity,
       _paymentOptionEntity = paymentOptionEntity;

  DateTimeEntity? get dateTimeEntity => _dateTimeEntity;
  PaymentOptionEntity? get paymentOptionEntity => _paymentOptionEntity;

  set dateTimeEntity(DateTimeEntity? value) {
    _dateTimeEntity = value;
    notifyListeners();
  }

  set paymentOptionEntity(PaymentOptionEntity? value) {
    _paymentOptionEntity = value;
    notifyListeners();
  }
}