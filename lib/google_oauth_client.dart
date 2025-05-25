import 'package:oauth2_client/oauth2_client.dart';

class GoogleOAuthClient extends OAuth2Client {
  GoogleOAuthClient({
    required String redirectUri,
    required String customUriScheme,
  }) : super(
    authorizeUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
    tokenUrl: 'https://oauth2.googleapis.com/token',
    redirectUri: redirectUri,
    customUriScheme: customUriScheme,
  );
}
