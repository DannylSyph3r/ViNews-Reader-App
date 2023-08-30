import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vinews_news_reader/core/constants/firebase_constants.dart';
import 'package:vinews_news_reader/firebase_options.dart';

// Auth Repository Class
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Ref _ref;

  AuthRepository(
    this._ref, {
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;

  //Collection Reference for Firebase Firestore user collection
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  //Auth State changes via stream
  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Sign In a user via Registered Email and Password...
  Future<Either<String, User?>> loginwithEmaillAndPassword(
      {required String email, required String password}) async {
    try {
      final authProcessResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(authProcessResult.user);
      // Successfully signed in
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left('No user found for that Email Address!');
      } else if (e.code == 'invalid-email') {
        return left('Email Address invalid!');
      } else if (e.code == 'wrong-password') {
        return left('Wrong Credentials! Please check your email and password!');
      } else {
        return left('An error occurred. Please try again later.');
      }
    } on FirebaseException catch (_) {
      // Handle other Firebase exceptions
      return left('Another bad error occurred. Please try again later.');
    } catch (_) {
      // Handle other exceptions
      return left('Fatal Error occurred. Please try again later.');
    }
  }

// Sign Up a user with Firstname, Lastname, Email and Password. First three fields to be stored in firestore
  Future<Either<String, User>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;
      if (user != null) {
        // Create a user document in Firestore with additional information
        await _users.doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'date_created': DateTime.now(),
        });

        return right(user);
      } else {
        return left('Failed to log details!.');
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      if (e.code == 'email-already-in-use') {
        return left('The email address is already in use.');
      } else if (e.code == 'invalid-email') {
        return left('Invalid email address.');
      } else {
        return left('An error occurred. Please try again later.');
      }
    } on FirebaseException catch (_) {
      // Handle other Firebase exceptions
      return left('Another bad error occurred. Please try again later.');
    } catch (_) {
      // Handle other exceptions
      return left('Fatal Error occurred. Please try again later.');
    }
  }

  // Sign Up or Sign In a user via Google Auth Credentials
  Future<Either<String, User>> continueWithGoogleAuthentication(
      {required bool isSignUp}) async {
    try {
      final googleSignIn =
          GoogleSignIn(clientId: DefaultFirebaseOptions.ios.iosClientId);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Store the user's first name, last name and email address in Firestore for sign up scenario
        User? signedInUser;
        if (isSignUp) {
          final authProcessResult =
              await _auth.signInWithCredential(credential);
          signedInUser = authProcessResult.user;
          if (signedInUser != null) {
            await _storeGoogleUserDetailsInFirestore(signedInUser);
          }
        } else {
          // Sign in/ Login scenario
          final authProcessResult =
              await _auth.signInWithCredential(credential);
          signedInUser = authProcessResult.user;
        }

        if (signedInUser != null) {
          return right(signedInUser);
        } else {
          return left('Unknown Authentication Error');
        }
      } else {
        return left('Unknown Authentication Error');
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      if (e.code == 'user-disabled') {
        return left('The user associated with this Email has been disabled!');
      } else if (e.code == 'user-not-found') {
        return left('No user found with this Email address!');
      } else if (e.code == 'wrong-password') {
        return left('Incorrect password for this Email address!');
      } else if (e.code == 'account-exists-with-different-credential') {
        return left(
            'An account already exists with a different authentication method.');
      } else if (e.code == 'invalid-credential') {
        return left('The provided credential is invalid.');
      } else if (e.code == 'operation-not-allowed') {
        return left('This operation is not allowed.');
      } else if (e.code == 'user-mismatch') {
        return left(
            'The provided credential does not match the authenticated user.');
      } else if (e.code == 'credential-already-in-use') {
        return left(
            'This credential is already associated with a different user.');
      } else {
        return left('An unknown error occurred. Please try again later.');
      }
    } on FirebaseException catch (_) {
      // Handle other Firebase exceptions
      return left('Another bad error occurred. Please try again later.');
    } catch (_) {
      // Handle other exceptions
      return left('Fatal Error occurred. Please try again later.');
    }
  }

  Future<void> _storeGoogleUserDetailsInFirestore(User authUser) async {
    // Extract user's first name and last name from the Google user's display name
    final displayNameParts = authUser.displayName?.split(' ') ?? [];
    String firstName = '';
    String lastName = '';
    if (displayNameParts.isNotEmpty) {
      firstName = displayNameParts[0];
      if (displayNameParts.length > 1) {
        lastName = displayNameParts.sublist(1).join(' ');
      }
    }

    // Create a Firestore document for the user
    await _users.doc(authUser.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': authUser.email,
      'date_created': DateTime.now(),
    });
  }

  // Sends the Current user an email verification link
  Future<Either<String, User?>> sendEmailVerificationLink() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();

        return right(user);
      } else {
        return left('User not found.');
      }
    } on FirebaseException catch (_) {
      // Handle Firebase exceptions
      return left('An error occurred. Please try again later.');
    } catch (_) {
      // Handle other exceptions
      return left('Fatal Error occurred. Please try again later.');
    }
  }

Future<Either<String, User?>> sendPasswordResetLink({required String emailAddress}) async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      await _auth.sendPasswordResetEmail(email: emailAddress);

      return right(user);
    } else {
      return left('User not found.');
    }
  } on FirebaseException catch (_) {
    // Handle Firebase exceptions
    return left('An error occurred. Please try again later.');
  } catch (_) {
    // Handle other exceptions
    return left('Fatal Error occurred. Please try again later.');
  }
}

  // Triggers Sign Out sequence
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle sign-out exception
      print('Error signing out: $e');
    }
  }
}
