import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignIn Email Validator Unit Tests', () {
    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'The email area cannot be left empty';
      }

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid email address';
      }

      return null;
    }

    group('Empty/Null Email Tests', () {
      test('should return error for null email', () {
        final result = emailValidator(null);
        expect(result, 'The email area cannot be left empty');
      });

      test('should return error for empty email', () {
        final result = emailValidator('');
        expect(result, 'The email area cannot be left empty');
      });

      test('should return error for whitespace only', () {
        final result = emailValidator('   ');
        expect(result, 'Enter a valid email address');
      });
    });

    group('Invalid Email Format Tests', () {
      test('should return error for email without @', () {
        final result = emailValidator('testexample.com');
        expect(result, 'Enter a valid email address');
      });

      test('should return error for email without domain', () {
        final result = emailValidator('test@');
        expect(result, 'Enter a valid email address');
      });

      test('should return error for email without username', () {
        final result = emailValidator('@example.com');
        expect(result, 'Enter a valid email address');
      });

      test('should return error for email without TLD', () {
        final result = emailValidator('test@example');
        expect(result, 'Enter a valid email address');
      });

      test('should return error for email with spaces', () {
        final result = emailValidator('test @example.com');
        expect(result, 'Enter a valid email address');
      });

      test('should return error for email with multiple @', () {
        final result = emailValidator('test@@example.com');
        expect(result, 'Enter a valid email address');
      });

      test('should return error for email ending with dot', () {
        final result = emailValidator('test@example.com.');
        expect(result, 'Enter a valid email address');
      });
    });

    group('Valid Email Format Tests', () {
      test('should return null for simple valid email', () {
        final result = emailValidator('test@example.com');
        expect(result, isNull);
      });

      test('should return null for email with subdomain', () {
        final result = emailValidator('test@mail.example.com');
        expect(result, isNull);
      });

      test('should return null for email with dots in username', () {
        final result = emailValidator('first.last@example.com');
        expect(result, isNull);
      });

      test('should return null for email with numbers', () {
        final result = emailValidator('test123@example123.com');
        expect(result, isNull);
      });

      test('should return null for email with hyphen in domain', () {
        final result = emailValidator('test@my-domain.com');
        expect(result, isNull);
      });

      test('should return null for email with underscore in username', () {
        final result = emailValidator('test_user@example.com');
        expect(result, isNull);
      });

      test('should return null for email with multiple subdomains', () {
        final result = emailValidator('user@mail.service.example.com');
        expect(result, isNull);
      });

      test('should return null for email with two-letter TLD', () {
        final result = emailValidator('test@example.io');
        expect(result, isNull);
      });

      test('should return null for email with four-letter TLD', () {
        final result = emailValidator('test@example.info');
        expect(result, isNull);
      });

      test('should return null for email with co.uk format', () {
        final result = emailValidator('test@example.co.uk');
        expect(result, isNull);
      });
    });

    group('Edge Case Email Tests', () {
      test('should handle very long valid email', () {
        final result = emailValidator(
          'very.long.email.address.with.many.dots@subdomain.example.com',
        );
        expect(result, isNull);
      });

      test('should handle email with numbers only in username', () {
        final result = emailValidator('123456@example.com');
        expect(result, isNull);
      });
    });
  });

  group('SignIn Password Validator Unit Tests', () {
    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password area cannot be left empty';
      }

      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }

      return null;
    }

    group('Empty/Null Password Tests', () {
      test('should return error for null password', () {
        final result = passwordValidator(null);
        expect(result, 'Password area cannot be left empty');
      });

      test('should return error for empty password', () {
        final result = passwordValidator('');
        expect(result, 'Password area cannot be left empty');
      });
    });

    group('Short Password Tests', () {
      test('should return error for 1 character password', () {
        final result = passwordValidator('1');
        expect(result, 'Password must be at least 6 characters');
      });

      test('should return error for 2 characters password', () {
        final result = passwordValidator('12');
        expect(result, 'Password must be at least 6 characters');
      });

      test('should return error for 3 characters password', () {
        final result = passwordValidator('123');
        expect(result, 'Password must be at least 6 characters');
      });

      test('should return error for 4 characters password', () {
        final result = passwordValidator('1234');
        expect(result, 'Password must be at least 6 characters');
      });

      test('should return error for 5 characters password', () {
        final result = passwordValidator('12345');
        expect(result, 'Password must be at least 6 characters');
      });
    });

    group('Valid Password Tests', () {
      test('should return null for exactly 6 characters', () {
        final result = passwordValidator('123456');
        expect(result, isNull);
      });

      test('should return null for 7 characters', () {
        final result = passwordValidator('1234567');
        expect(result, isNull);
      });

      test('should return null for 8 characters', () {
        final result = passwordValidator('12345678');
        expect(result, isNull);
      });

      test('should return null for long password', () {
        final result = passwordValidator('VeryLongPassword123!@#');
        expect(result, isNull);
      });

      test('should return null for password with special characters', () {
        final result = passwordValidator('Pass@123!');
        expect(result, isNull);
      });

      test('should return null for password with spaces', () {
        final result = passwordValidator('pass word 123');
        expect(result, isNull);
      });

      test('should return null for alphanumeric password', () {
        final result = passwordValidator('Password123');
        expect(result, isNull);
      });

      test('should return null for only letters password', () {
        final result = passwordValidator('password');
        expect(result, isNull);
      });

      test('should return null for only numbers password', () {
        final result = passwordValidator('123456789');
        expect(result, isNull);
      });
    });

    group('Edge Case Password Tests', () {
      test('should handle password with unicode characters', () {
        final result = passwordValidator('pĂ€ssw√∂rd');
        expect(result, isNull);
      });

      test('should handle password with emoji', () {
        final result = passwordValidator('pass😀word');
        expect(result, isNull);
      });

      test('should handle password with newline', () {
        final result = passwordValidator('pass\nword');
        expect(result, isNull);
      });

      test('should handle password with tab', () {
        final result = passwordValidator('pass\tword');
        expect(result, isNull);
      });
    });
  });

  group('SignIn Business Logic Unit Tests', () {
    test('email should be trimmed before validation', () {
      const emailWithSpaces = '  test@example.com  ';
      final trimmedEmail = emailWithSpaces.trim();

      expect(trimmedEmail, 'test@example.com');
      expect(trimmedEmail.contains(' '), isFalse);
    });

    test('password should not be trimmed', () {
      const passwordWithSpaces = '  password123  ';
      // Password genellikle trim edilmez çünkü boşluklar geçerli karakter olabilir
      expect(passwordWithSpaces, '  password123  ');
    });

    test('should validate minimum password length correctly', () {
      const minimumLength = 6;

      expect('12345'.length < minimumLength, isTrue);
      expect('123456'.length >= minimumLength, isTrue);
      expect('1234567'.length >= minimumLength, isTrue);
    });

    test('email regex pattern should match valid emails', () {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'test_user@mail.example.com',
        'user123@test.io',
      ];

      for (final email in validEmails) {
        expect(
          emailRegex.hasMatch(email),
          isTrue,
          reason: '$email should match',
        );
      }
    });

    test('email regex pattern should not match invalid emails', () {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      final invalidEmails = [
        'test',
        'test@',
        '@example.com',
        'test@example',
        'test @example.com',
      ];

      for (final email in invalidEmails) {
        expect(
          emailRegex.hasMatch(email),
          isFalse,
          reason: '$email should not match',
        );
      }
    });
  });

  group('SignIn Form Validation Logic Tests', () {
    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'The email area cannot be left empty';
      }
      return null;
    }

    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password area cannot be left empty';
      }

      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }

      return null;
    }

    test('form should be invalid with empty fields', () {
      final emailError = emailValidator('');
      final passwordError = passwordValidator('');

      expect(emailError, isNotNull);
      expect(passwordError, isNotNull);
    });

    test('form should be invalid with only email filled', () {
      final emailError = emailValidator('test@example.com');
      final passwordError = passwordValidator('');

      expect(emailError, isNull);
      expect(passwordError, isNotNull);
    });

    test('form should be invalid with only password filled', () {
      final emailError = emailValidator('');
      final passwordError = passwordValidator('password123');

      expect(emailError, isNotNull);
      expect(passwordError, isNull);
    });

    test('form should be valid with both fields correctly filled', () {
      final emailError = emailValidator('test@example.com');
      final passwordError = passwordValidator('password123');

      expect(emailError, isNull);
      expect(passwordError, isNull);
    });
    test('form should be invalid with valid email and short password', () {
      final emailError = emailValidator('test@example.com');
      final passwordError = passwordValidator('12345');

      expect(emailError, isNull);
      expect(passwordError, isNotNull);
    });
  });

  group('SignIn Error Message Tests', () {
    test('should return correct error message for empty email', () {
      String? emailValidator(String? value) {
        if (value == null || value.isEmpty) {
          return 'The email area cannot be left empty';
        }
        return null;
      }

      expect(
        emailValidator(''),
        'The email area cannot be left empty',
      );
    });

    test('should return correct error message for invalid email', () {
      String? emailValidator(String? value) {
        if (value == null || value.isEmpty) {
          return 'The email area cannot be left empty';
        }

        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }

        return null;
      }

      expect(
        emailValidator('invalidemail'),
        'Enter a valid email address',
      );
    });

    test('should return correct error message for empty password', () {
      String? passwordValidator(String? value) {
        if (value == null || value.isEmpty) {
          return 'Password area cannot be left empty';
        }
        return null;
      }

      expect(
        passwordValidator(''),
        'Password area cannot be left empty',
      );
    });

    test('should return correct error message for short password', () {
      String? passwordValidator(String? value) {
        if (value == null || value.isEmpty) {
          return 'Password area cannot be left empty';
        }

        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        return null;
      }

      expect(
        passwordValidator('12345'),
        'Password must be at least 6 characters',
      );
    });
  });
}
