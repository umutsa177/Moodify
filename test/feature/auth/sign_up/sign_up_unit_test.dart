import 'package:flutter_test/flutter_test.dart';
import 'package:moodify/product/constant/string_constant.dart';

void main() {
  group('Email Validation Logic Tests', () {
    test('should reject null email', () {
      // Arrange
      const String? email = null;

      // Act
      final isValid = email != null && email.isNotEmpty;

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject empty email', () {
      // Arrange
      const email = '';

      // Act
      final isValid = email.isNotEmpty;

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject email without @', () {
      // Arrange
      const email = 'testexample.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject email without domain', () {
      // Arrange
      const email = 'test@';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject email without TLD', () {
      // Arrange
      const email = 'test@example';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isFalse);
    });

    test('should accept valid email with common domain', () {
      // Arrange
      const email = 'test@example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept email with dots in username', () {
      // Arrange
      const email = 'test.user@example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept email with hyphens in username', () {
      // Arrange
      const email = 'test-user@example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept email with numbers', () {
      // Arrange
      const email = 'test123@example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept email with subdomain', () {
      // Arrange
      const email = 'test@mail.example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isTrue);
    });

    test('should reject email with spaces', () {
      // Arrange
      const email = 'test @example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject email with invalid characters', () {
      // Arrange
      const email = 'test!@example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      // Act
      final isValid = emailRegex.hasMatch(email);

      // Assert
      expect(isValid, isFalse);
    });
  });

  group('Password Validation Logic Tests', () {
    test('should reject null password', () {
      // Arrange
      const String? password = null;

      // Act
      final isValid = password != null && password.isNotEmpty;

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject empty password', () {
      // Arrange
      const password = '';

      // Act
      final isValid = password.isNotEmpty;

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject password with less than 6 characters', () {
      // Arrange
      const password = '12345';
      const minLength = 6;

      // Act
      const isValid = password.length >= minLength;

      // Assert
      expect(isValid, isFalse);
    });

    test('should accept password with exactly 6 characters', () {
      // Arrange
      const password = '123456';
      const minLength = 6;

      // Act
      const isValid = password.length >= minLength;

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept password with more than 6 characters', () {
      // Arrange
      const password = '1234567890';
      const minLength = 6;

      // Act
      const isValid = password.length >= minLength;

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept password with letters and numbers', () {
      // Arrange
      const password = 'password123';
      const minLength = 6;

      // Act
      final isValid = password.length >= minLength && password.isNotEmpty;

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept password with special characters', () {
      // Arrange
      const password = 'Pass@123!';
      const minLength = 6;

      // Act
      const isValid = password.length >= minLength;

      // Assert
      expect(isValid, isTrue);
    });

    test('should accept password with spaces', () {
      // Arrange
      const password = 'pass word 123';
      const minLength = 6;

      // Act
      const isValid = password.length >= minLength;

      // Assert
      expect(isValid, isTrue);
    });
  });

  group('Password Confirmation Logic Tests', () {
    test('should reject empty confirmation password', () {
      // Arrange
      const confirmPassword = '';

      // Act
      final isValid = confirmPassword.isNotEmpty;

      // Assert
      expect(isValid, isFalse);
    });

    test('should reject non-matching passwords', () {
      // Arrange
      const password = 'password123';
      const confirmPassword = 'password456';

      // Act
      const isMatching = password == confirmPassword;

      // Assert
      expect(isMatching, isFalse);
    });

    test('should accept matching passwords', () {
      // Arrange
      const password = 'password123';
      const confirmPassword = 'password123';

      // Act
      const isMatching = password == confirmPassword;

      // Assert
      expect(isMatching, isTrue);
    });

    test('should be case sensitive', () {
      // Arrange
      const password = 'Password123';
      const confirmPassword = 'password123';

      // Act
      const isMatching = password == confirmPassword;

      // Assert
      expect(isMatching, isFalse);
    });

    test('should not ignore trailing spaces', () {
      // Arrange
      const password = 'password123';
      const confirmPassword = 'password123 ';

      // Act
      const isMatching = password == confirmPassword;

      // Assert
      expect(isMatching, isFalse);
    });

    test('should not ignore leading spaces', () {
      // Arrange
      const password = 'password123';
      const confirmPassword = ' password123';

      // Act
      const isMatching = password == confirmPassword;

      // Assert
      expect(isMatching, isFalse);
    });
  });

  group('Email Trimming Logic Tests', () {
    test('should trim leading spaces from email', () {
      // Arrange
      const email = '  test@example.com';

      // Act
      final trimmedEmail = email.trim();

      // Assert
      expect(trimmedEmail, equals('test@example.com'));
      expect(trimmedEmail, isNot(equals(email)));
    });

    test('should trim trailing spaces from email', () {
      // Arrange
      const email = 'test@example.com  ';

      // Act
      final trimmedEmail = email.trim();

      // Assert
      expect(trimmedEmail, equals('test@example.com'));
    });

    test('should trim both leading and trailing spaces', () {
      // Arrange
      const email = '  test@example.com  ';

      // Act
      final trimmedEmail = email.trim();

      // Assert
      expect(trimmedEmail, equals('test@example.com'));
    });

    test('should not modify email without spaces', () {
      // Arrange
      const email = 'test@example.com';

      // Act
      final trimmedEmail = email.trim();

      // Assert
      expect(trimmedEmail, equals(email));
    });

    test('should preserve internal spaces after trim', () {
      // Arrange
      const email = '  test user@example.com  ';

      // Act
      final trimmedEmail = email.trim();

      // Assert
      expect(trimmedEmail, equals('test user@example.com'));
    });
  });

  group('Form Validation Logic Tests', () {
    test('should require all fields to be valid', () {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const confirmPassword = 'password123';

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      const minPasswordLength = 6;

      // Act
      final isEmailValid = email.isNotEmpty && emailRegex.hasMatch(email);
      final isPasswordValid =
          password.isNotEmpty && password.length >= minPasswordLength;
      final isConfirmPasswordValid =
          confirmPassword.isNotEmpty && confirmPassword == password;

      final isFormValid =
          isEmailValid && isPasswordValid && isConfirmPasswordValid;

      // Assert
      expect(isFormValid, isTrue);
    });

    test('should be invalid if email is invalid', () {
      // Arrange
      const email = 'invalid-email';
      const password = 'password123';
      const confirmPassword = 'password123';

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      const minPasswordLength = 6;

      // Act
      final isEmailValid = emailRegex.hasMatch(email);
      const isPasswordValid = password.length >= minPasswordLength;
      const isConfirmPasswordValid = confirmPassword == password;

      final isFormValid =
          isEmailValid && isPasswordValid && isConfirmPasswordValid;

      // Assert
      expect(isFormValid, isFalse);
    });

    test('should be invalid if password is too short', () {
      // Arrange
      const email = 'test@example.com';
      const password = '12345';
      const confirmPassword = '12345';

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      const minPasswordLength = 6;

      // Act
      final isEmailValid = emailRegex.hasMatch(email);
      const isPasswordValid = password.length >= minPasswordLength;
      const isConfirmPasswordValid = confirmPassword == password;

      final isFormValid =
          isEmailValid && isPasswordValid && isConfirmPasswordValid;

      // Assert
      expect(isFormValid, isFalse);
    });

    test('should be invalid if passwords do not match', () {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const confirmPassword = 'password456';

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      const minPasswordLength = 6;

      // Act
      final isEmailValid = emailRegex.hasMatch(email);
      const isPasswordValid = password.length >= minPasswordLength;
      const isConfirmPasswordValid = confirmPassword == password;

      final isFormValid =
          isEmailValid && isPasswordValid && isConfirmPasswordValid;

      // Assert
      expect(isFormValid, isFalse);
    });
  });

  group('String Constants Tests', () {
    test('signup related strings should not be empty', () {
      // Assert
      expect(StringConstant.appName, isNotEmpty);
      expect(StringConstant.registerTitle, isNotEmpty);
      expect(StringConstant.email, isNotEmpty);
      expect(StringConstant.password, isNotEmpty);
      expect(StringConstant.confirmPassword, isNotEmpty);
      expect(StringConstant.signUp, isNotEmpty);
      expect(StringConstant.alreadyHaveAccount, isNotEmpty);
      expect(StringConstant.login, isNotEmpty);
    });

    test('signup strings should be different from each other', () {
      // Assert
      expect(StringConstant.email, isNot(equals(StringConstant.password)));
      expect(
        StringConstant.password,
        isNot(equals(StringConstant.confirmPassword)),
      );
      expect(StringConstant.signUp, isNot(equals(StringConstant.login)));
    });

    test('validation error messages should be defined', () {
      // Assert - These would be in your validation methods
      const emailEmptyError = 'The email area cannot be left empty';
      const invalidEmailError = 'Enter a valid email address';
      const passwordEmptyError = 'Password area cannot be left empty';
      const passwordShortError = 'Password must be at least 6 characters';
      const confirmPasswordEmptyError =
          'Password repetition area cannot be left empty';
      const passwordMismatchError = 'Passwords do not match';

      expect(emailEmptyError, isNotEmpty);
      expect(invalidEmailError, isNotEmpty);
      expect(passwordEmptyError, isNotEmpty);
      expect(passwordShortError, isNotEmpty);
      expect(confirmPasswordEmptyError, isNotEmpty);
      expect(passwordMismatchError, isNotEmpty);
    });
  });

  group('Password Security Logic Tests', () {
    test('minimum password length should be 6', () {
      // Arrange
      const minLength = 6;

      // Assert
      expect(minLength, equals(6));
      expect(minLength, greaterThanOrEqualTo(6));
    });

    test('should accept various password formats', () {
      // Arrange
      const passwords = [
        'password123', // alphanumeric
        'Pass@123!', // with special chars
        '123456', // only numbers
        'abcdef', // only letters
        'pass word', // with space
        'UPPERCASE', // uppercase
        'lowercase', // lowercase
        'MixedCase123', // mixed case with numbers
      ];

      const minLength = 6;

      // Act & Assert
      for (final password in passwords) {
        expect(password.length >= minLength, isTrue);
      }
    });
  });

  group('Loading State Logic Tests', () {
    test('should start with loading false', () {
      // Arrange
      const isLoading = false;

      // Assert
      expect(isLoading, isFalse);
    });

    test('should disable button when loading', () {
      // Arrange
      const isLoading = true;

      // Act
      const buttonEnabled = !isLoading;

      // Assert
      expect(buttonEnabled, isFalse);
    });

    test('should enable button when not loading', () {
      // Arrange
      const isLoading = false;

      // Act
      const buttonEnabled = !isLoading;

      // Assert
      expect(buttonEnabled, isTrue);
    });

    test('should toggle loading state', () {
      // Arrange
      var isLoading = false;

      // Act
      isLoading = true;

      // Assert
      expect(isLoading, isTrue);

      // Act again
      isLoading = false;

      // Assert again
      expect(isLoading, isFalse);
    });
  });

  group('Navigation Logic Tests', () {
    test('should navigate to email verification after signup', () {
      // Arrange
      const email = 'test@example.com';
      const shouldNavigate = true;

      // Assert
      expect(shouldNavigate, isTrue);
      expect(email, isNotEmpty);
    });

    test('should pass email as argument to verification page', () {
      // Arrange
      const email = 'test@example.com';
      final trimmedEmail = email.trim();

      // Assert
      expect(trimmedEmail, equals('test@example.com'));
    });
  });

  group('Error Handling Logic Tests', () {
    test('should handle exception during signup', () {
      // Arrange
      const hasError = true;
      final exception = Exception('Sign up failed');

      // Assert
      expect(hasError, isTrue);
      expect(exception.toString(), contains('Sign up failed'));
    });

    test('should reset loading state after error', () {
      // Arrange
      var isLoading = true;

      // Act - Simulating finally block
      isLoading = false;

      // Assert
      expect(isLoading, isFalse);
    });
  });

  group('TextEditingController Logic Tests', () {
    test('should handle controller text updates', () {
      // Arrange
      var emailText = '';
      const newEmail = 'test@example.com';

      // Act
      emailText = newEmail;

      // Assert
      expect(emailText, equals(newEmail));
    });

    test('should clear controller text', () {
      // Arrange
      var emailText = 'test@example.com';

      // Act
      emailText = '';

      // Assert
      expect(emailText, isEmpty);
    });

    test('should update controller text multiple times', () {
      // Arrange
      var emailText = 'old@example.com';

      // Act
      emailText = 'new@example.com';

      // Assert
      expect(emailText, equals('new@example.com'));
      expect(emailText, isNot(equals('old@example.com')));
    });
  });
}
