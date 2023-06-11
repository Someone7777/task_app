/// Defines the relative URLs for the backend server endpoints.
class APIContract {
  /*
   * ============ JWT login ============ *
   */
  /// [POST] Returns JWT access and refresh token
  static const String jwtLogin = "/api/v1/jwt";

  /*
   * ============ JWT refresh ============ *
   */
  /// [POST] Returns new JWT access token
  static const String jwtRefresh = "/api/v1/jwt/refresh";

  /*
   * ============ User ============ *
   */
  /// [GET], [PUT], [PATCH], [DEL] User profile info
  static const String userProfile = "/api/v1/user/profile";

  /// [POST] User creation
  static const String userCreation = "/api/v1/user";

  /// [POST] User password reset send code
  static const String userPasswordResetStart = "/api/v1/user/password/reset";

  /// [POST] User password reset verify code and new password
  static const String userPasswordResetVerify =
      "/api/v1/user/password/reset/verify";

  /// [POST] User password change
  static const String userPasswordChange = "/api/v1/user/password/change";

  /*
   * ============ Email code ============ *
   */
  /// [POST] Send email code
  static const String emailCodeSend = "/api/v1/email_code/send";

  /// [POST] Verify sent email code
  static const String emailCodeVerify = "/api/v1/email_code/verify";
}
