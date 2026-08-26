import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/core/utils/whatsapp.dart';
import 'package:fashion_store/models/complaint/complaint_model.dart';
import 'package:fashion_store/models/store/store_detail_model.dart';
import 'package:fashion_store/models/wallet/payment_order_details_model.dart';

/// Pins the parsing rules against payloads copied verbatim from the live API,
/// so a field the backend renames cannot silently degrade to a blank row.
void main() {
  group('WhatsApp number normalisation', () {
    test('strips the plus and keeps the country code', () {
      expect(normalizeWhatsAppNumber('+963993730296'), '963993730296');
    });

    test('promotes a local Syrian number to international form', () {
      // Store records and user profiles hold numbers in this shape.
      expect(normalizeWhatsAppNumber('0934546754'), '963934546754');
    });

    test('drops an international 00 prefix', () {
      expect(normalizeWhatsAppNumber('00963934546754'), '963934546754');
    });

    test('ignores spaces and dashes', () {
      expect(normalizeWhatsAppNumber('+963 993-730-296'), '963993730296');
    });
  });

  group('complaint unread counts', () {
    test('customer view reads numberOfUnReadMessage', () {
      final model = UserComplaintModel.fromJson({
        'complaintId': 10,
        'storeId': 2,
        'storeName': 'ROSE & GRACE',
        'storeLogo': '/uploads/x.png',
        'title': 'Test',
        'description': 'test',
        'createdAt': '2026-08-20T15:36:52.4106677',
        'numberOfUnReadMessage': 3,
      });
      expect(model.numberOfUnReadMessage, 3);
    });

    test('store-owner view reads numberOfUnReadMessage', () {
      final model = StoreComplaintModel.fromJson({
        'complaintId': 10,
        'customerId': 'abc',
        'customerFullName': 'fatima houd',
        'title': 'Test',
        'description': 'test',
        'createdAt': '2026-08-20T15:36:52.4106677',
        'status': 'Pending',
        'numberOfUnReadMessage': 7,
      });
      expect(model.numberOfUnReadMessage, 7);
    });

    test('defaults to zero when the field is absent', () {
      final model = UserComplaintModel.fromJson({
        'complaintId': 1,
        'storeId': 1,
        'storeName': 's',
        'title': 't',
        'description': 'd',
        'createdAt': '2026-08-20T15:36:52',
      });
      expect(model.numberOfUnReadMessage, 0);
    });
  });

  group('store payloads use different field names per endpoint', () {
    test('SuperAdmin request feed: phoneNumber / email / ownerId', () {
      final model = StoreDetailModel.fromJson({
        'id': 4,
        'ownerId': '40136ea3-ec24-42e1-9716-4b135cdc9ec7',
        'storeName': 'ELM & VINE',
        'description': 'd',
        'address': 'حلب فرقان',
        'phoneNumber': '0934345678',
        'email': 'VINE@gmail.com',
        'workingHoursStart': '01:00:00',
        'workingHoursEnd': '08:00:00',
        'createdAt': '2026-07-06T20:26:56.7533333',
        'isActive': true,
        'storeStatus': 'Approved',
      });
      // These used to come out blank on the approval screen.
      expect(model.storePhoneNumber, '0934345678');
      expect(model.storeEmail, 'VINE@gmail.com');
      expect(model.ownerId, '40136ea3-ec24-42e1-9716-4b135cdc9ec7');
    });

    test('public store list: storePhoneNumber / storeEmail, no ownerId', () {
      final model = StoreDetailModel.fromJson({
        'id': 1,
        'storeName': 'Step Elegance',
        'description': 'd',
        'storePhoneNumber': '0923456789',
        'address': 'حلب فرقان',
        'storeEmail': 'StepElegance@gmail.com',
        'workingHoursStart': '12:00:00',
        'workingHoursEnd': '22:00:00',
        'createdAt': '2026-07-06T20:26:56',
        'isActive': true,
        'storeStatus': 'Approved',
      });
      expect(model.storePhoneNumber, '0923456789');
      expect(model.storeEmail, 'StepElegance@gmail.com');
      expect(model.ownerId, isNull);
    });
  });

  group('order behind a wallet transaction', () {
    final json = {
      'orderId': 9,
      'userId': '0f4ef1c5-eb61-4261-aee7-ee0fc7103967',
      'userFirstName': 'fatima',
      'userLastName': 'houd',
      'products': [
        {
          'productId': 11,
          'storeId': 1,
          'storeName': 'Step Elegance',
          'quantity': 1,
          'size': 'Shoe40',
          'color': 'اسود',
          'colorHex': '#000000',
          'price': 2000.0,
          'image': 'https://example.invalid/a.jpg',
          'totalPrice': 2000.0,
        },
        {
          'productId': 12,
          'storeId': 1,
          'storeName': 'Step Elegance',
          'quantity': 2,
          'size': 'Shoe41',
          'color': 'ابيض',
          'colorHex': '#FFFFFF',
          'price': 1500.0,
          'image': '',
          'totalPrice': 3000.0,
        },
      ],
    };

    test('parses the customer and the lines', () {
      final model = PaymentOrderDetailsModel.fromJson(json);
      expect(model.orderId, 9);
      expect(model.customerName, 'fatima houd');
      expect(model.products, hasLength(2));
      expect(model.products.first.size, 'Shoe40');
      expect(model.products.first.colorHex, '#000000');
    });

    test('total sums the line totals', () {
      expect(PaymentOrderDetailsModel.fromJson(json).total, 5000.0);
    });

    test('survives a transaction with no linked order', () {
      final model = PaymentOrderDetailsModel.fromJson({});
      expect(model.orderId, 0);
      expect(model.products, isEmpty);
      expect(model.total, 0);
    });
  });
}
