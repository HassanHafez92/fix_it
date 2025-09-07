import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payment_method_model.dart';

/// Remote data source for payment methods using Firebase Firestore.
/// 
/// This class handles all the remote operations for payment methods,
/// including CRUD operations with Firebase Firestore.
abstract class PaymentMethodsRemoteDataSource {
  /// Retrieves all payment methods for a specific user from Firestore
  Future<List<PaymentMethodModel>> getPaymentMethods(String userId);

  /// Adds a new payment method to Firestore
  Future<PaymentMethodModel> addPaymentMethod(PaymentMethodModel paymentMethod);

  /// Updates an existing payment method in Firestore
  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel paymentMethod);

  /// Deletes a payment method from Firestore
  Future<void> deletePaymentMethod(String paymentMethodId);

  /// Sets a payment method as default for a user
  Future<void> setDefaultPaymentMethod(String userId, String paymentMethodId);

  /// Gets the default payment method for a user
  Future<PaymentMethodModel?> getDefaultPaymentMethod(String userId);
}

/// Implementation of PaymentMethodsRemoteDataSource using Firebase Firestore
class PaymentMethodsRemoteDataSourceImpl implements PaymentMethodsRemoteDataSource {
  final FirebaseFirestore firestore;

  /// Collection reference for payment methods
  static const String paymentMethodsCollection = 'paymentMethods';

  /// Collection reference for users (to store default payment method)
  static const String usersCollection = 'users';

  PaymentMethodsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(paymentMethodsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return PaymentMethodModel.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to fetch payment methods: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      // If this is the first payment method for the user, make it default
      final existingMethods = await getPaymentMethods(paymentMethod.userId);
      final shouldBeDefault = existingMethods.isEmpty;

      final paymentMethodData = paymentMethod.copyWith(
        isDefault: shouldBeDefault || paymentMethod.isDefault,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add the payment method to Firestore
      final docRef = await firestore
          .collection(paymentMethodsCollection)
          .add(paymentMethodData.toJson());

      // If this is set as default, update all other payment methods
      if (paymentMethodData.isDefault) {
        await _updateOtherPaymentMethodsAsNonDefault(paymentMethod.userId, docRef.id);
      }

      // Return the created payment method with the generated ID
      return paymentMethodData.copyWith(id: docRef.id);
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to add payment method: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      final updatedPaymentMethod = paymentMethod.copyWith(
        updatedAt: DateTime.now(),
      );

      await firestore
          .collection(paymentMethodsCollection)
          .doc(paymentMethod.id)
          .update(updatedPaymentMethod.toJson());

      return updatedPaymentMethod;
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to update payment method: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      // Mark as inactive instead of deleting for audit purposes
      await firestore
          .collection(paymentMethodsCollection)
          .doc(paymentMethodId)
          .update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to delete payment method: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<void> setDefaultPaymentMethod(String userId, String paymentMethodId) async {
    try {
      // Start a batch operation to ensure atomicity
      final batch = firestore.batch();

      // Update all user's payment methods to not be default
      final userPaymentMethods = await firestore
          .collection(paymentMethodsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      for (final doc in userPaymentMethods.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      // Set the specified payment method as default
      final targetPaymentMethodRef = firestore
          .collection(paymentMethodsCollection)
          .doc(paymentMethodId);

      batch.update(targetPaymentMethodRef, {
        'isDefault': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Commit the batch
      await batch.commit();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to set default payment method: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentMethodModel?> getDefaultPaymentMethod(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(paymentMethodsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return PaymentMethodModel.fromJson(data);
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to get default payment method: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  /// Helper method to update other payment methods as non-default
  Future<void> _updateOtherPaymentMethodsAsNonDefault(String userId, String excludePaymentMethodId) async {
    final batch = firestore.batch();

    final userPaymentMethods = await firestore
        .collection(paymentMethodsCollection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    for (final doc in userPaymentMethods.docs) {
      if (doc.id != excludePaymentMethodId) {
        batch.update(doc.reference, {'isDefault': false});
      }
    }

    if (userPaymentMethods.docs.isNotEmpty) {
      await batch.commit();
    }
  }
}
