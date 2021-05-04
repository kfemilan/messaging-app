enum AuthenticationStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthenticationExceptions {
  static handleException(e){
    print(e.code);
    var status;
    switch (e.code) {
      case "invalid-email":
        status = AuthenticationStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthenticationStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthenticationStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthenticationStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthenticationStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthenticationStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthenticationStatus.emailAlreadyExists;
        break;
      default:
        status = AuthenticationStatus.undefined;
    }
    return status;
  }

  static generateMessage(code){
    String message;
    switch (code) {
      case AuthenticationStatus.invalidEmail:
        message = "Your email address is invalid";
        break;
      case AuthenticationStatus.wrongPassword:
        message = "Your password is wrong.";
        break;
      case AuthenticationStatus.userNotFound:
        message = "This user does not exist.";
        break;
      case AuthenticationStatus.userDisabled:
        message = "This user has been disabled.";
        break;
      case AuthenticationStatus.tooManyRequests:
        message = "Too many requests. Please try again later.";
        break;
      case AuthenticationStatus.operationNotAllowed:
        message = "Signing in with Email and Password is not enabled.";
        break;
      case AuthenticationStatus.emailAlreadyExists:
        message =
            "An account with this email already exists.";
        break;
      default:
        message = "An undefined Error happened.";
    }
    return message;
  }

}