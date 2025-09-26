import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Sign in with Google and return a Firebase [User]
  Future<User?> signInWithGoogle() async {
    try {
      // Make sure it's initialized (needed in google_sign_in ^6.x)
      await _googleSignIn.initialize();

      // Show Google account picker
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) return null; // user canceled login

      // Get the auth tokens
      final googleAuth = googleUser.authentication;

      // Create a Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        //Todo Add this if needed
        // accessToken: googleUser.authorizationClient
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out from both Firebase & Google
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
  }

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;
}
