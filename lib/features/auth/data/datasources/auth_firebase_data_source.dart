import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthFirebaseDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String userType,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> forgotPassword({required String email});
  Future<UserModel> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? profilePictureUrl,
  });
  Future<void> changePassword({required String newPassword});
  Stream<User?> get authStateChanges;
}

class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthFirebaseDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Create a Google provider
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      
      // Sign in with Google
      final userCredential = await _auth.signInWithPopup(googleProvider);
      final user = userCredential.user;
      
      if (user == null) {
        throw Exception('Google sign in failed');
      }
      
      // Check if user document exists in Firestore
      // This determines if this is a first-time Google sign-in or returning user
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        // Create user document if it doesn't exist
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          fullName: user.displayName ?? '',
          phoneNumber: user.phoneNumber ?? '',
          userType: 'customer', // Default user type
          profilePictureUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
        return userModel;
      } else {
        // Return existing user
        return UserModel.fromJson(userDoc.data()!);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Google sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign in failed');
      }
      return await _getUserModelFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String userType,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign up failed');
      }

      // Update user profile
      await user.updateDisplayName(fullName);

      // Create user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        userType: userType,
        profilePictureUrl: user.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return await _getUserModelFromFirebaseUser(user);
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      // Update Firebase Auth profile
      await user.updateDisplayName(fullName);
      if (profilePictureUrl != null) {
        await user.updatePhotoURL(profilePictureUrl);
      }

      // Update Firestore document
      final userDoc = _firestore.collection('users').doc(user.uid);
      final updateData = <String, dynamic>{
        'fullName': fullName,
        'updatedAt': DateTime.now(),
      };
      if (phoneNumber != null) {
        updateData['phoneNumber'] = phoneNumber;
      }
      if (profilePictureUrl != null) {
        updateData['profilePictureUrl'] = profilePictureUrl;
      }

      await userDoc.update(updateData);

      return await _getUserModelFromFirebaseUser(user);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword({required String newPassword}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> _getUserModelFromFirebaseUser(User user) async {
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        // Ensure userType is not null
        if (data['userType'] == null) {
          data['userType'] = 'customer'; // Default user type
        }
        return UserModel.fromJson(data);
      } else {
        // Create user document if it doesn't exist
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          fullName: user.displayName ?? '',
          phoneNumber: user.phoneNumber ?? '',
          userType: 'customer', // Default user type
          profilePictureUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
        return userModel;
      }
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email address');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('An account with this email already exists');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'too-many-requests':
        return Exception('Too many failed attempts. Please try again later');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
