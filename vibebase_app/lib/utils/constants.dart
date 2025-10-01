/// Constants used throughout the application
class AppConstants {
  // App info
  static const String appName = 'VibeBase';
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';

  // Storage paths
  static const String profilePicturesPath = 'users/{uid}/profile';
  static const String postImagesPath = 'posts/{postId}/images';

  // Error messages
  static const String genericError = 'An error occurred. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
}
