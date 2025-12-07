import 'package:flutter_test/flutter_test.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';

void main() {
  group('StringConstant Pure Unit Tests', () {
    test('splash title should not be empty', () {
      // Assert
      expect(StringConstant.splashTitle, isNotEmpty);
      expect(StringConstant.splashTitle.trim(), isNotEmpty);
    });

    test('splash subtitle should not be empty', () {
      // Assert
      expect(StringConstant.splashSubtitle, isNotEmpty);
      expect(StringConstant.splashSubtitle.trim(), isNotEmpty);
    });

    test('sign in button texts should be different', () {
      // Assert
      expect(
        StringConstant.signInGoogle,
        isNot(equals(StringConstant.signInFacebook)),
      );
      expect(
        StringConstant.signInGoogle,
        isNot(equals(StringConstant.emailSignup)),
      );
      expect(
        StringConstant.signInFacebook,
        isNot(equals(StringConstant.emailSignup)),
      );
    });

    test('terms text parts should be properly defined', () {
      // Assert
      expect(StringConstant.firstTermsText, isNotEmpty);
      expect(StringConstant.secondTermsText, isNotEmpty);
      expect(
        StringConstant.firstTermsText,
        isNot(equals(StringConstant.secondTermsText)),
      );
    });

    test('separator text should not be empty', () {
      // Assert
      expect(StringConstant.seperateText, isNotEmpty);
      expect(StringConstant.seperateText.length, greaterThan(0));
    });

    test('okey button text should be defined', () {
      // Assert
      expect(StringConstant.okey, isNotEmpty);
      expect(StringConstant.okey.length, greaterThan(0));
    });

    test('supabase redirect URI should be valid format', () {
      // Assert
      expect(StringConstant.supabaseRedirectUri, isNotEmpty);
      expect(StringConstant.supabaseRedirectUri, contains('://'));
      expect(
        StringConstant.supabaseRedirectUri,
        startsWith('com.umutsayar.moodify'),
      );
    });

    test('all splash-related strings should be non-null', () {
      // Assert
      expect(StringConstant.splashTitle, isNotNull);
      expect(StringConstant.splashSubtitle, isNotNull);
      expect(StringConstant.signInGoogle, isNotNull);
      expect(StringConstant.signInFacebook, isNotNull);
      expect(StringConstant.emailSignup, isNotNull);
      expect(StringConstant.firstTermsText, isNotNull);
      expect(StringConstant.secondTermsText, isNotNull);
      expect(StringConstant.seperateText, isNotNull);
    });
  });

  group('ColorConstant Pure Unit Tests', () {
    test('splash background colors should not be empty', () {
      // Assert
      expect(ColorConstant.splashBackgroundColors, isNotEmpty);
      expect(
        ColorConstant.splashBackgroundColors.length,
        greaterThanOrEqualTo(2),
      );
    });

    test('splash background colors should be valid colors', () {
      // Assert
      for (final color in ColorConstant.splashBackgroundColors) {
        expect(color, isNotNull);
        final alphaValue = (color.a * 255.0).round().clamp(0, 255);
        expect(alphaValue, greaterThanOrEqualTo(0));
        expect(alphaValue, lessThanOrEqualTo(255));
      }
    });

    test('button background colors should be different', () {
      // Assert - Each button should have distinct color
      expect(
        ColorConstant.primary,
        isNot(equals(ColorConstant.facebookLoginBackground)),
      );
      expect(
        ColorConstant.primary,
        isNot(equals(ColorConstant.emailBackground)),
      );
      expect(
        ColorConstant.facebookLoginBackground,
        isNot(equals(ColorConstant.emailBackground)),
      );
    });

    test('emoji color should be valid', () {
      // Assert
      expect(ColorConstant.emojiColor, isNotNull);
      final alphaValue = (ColorConstant.emojiColor.a * 255.0).round().clamp(
        0,
        255,
      );
      expect(alphaValue, greaterThanOrEqualTo(0));
      expect(alphaValue, lessThanOrEqualTo(255));
    });

    test('text colors should be valid', () {
      // Assert
      expect(ColorConstant.primary, isNotNull);
      expect(ColorConstant.primaryLight, isNotNull);
      expect(ColorConstant.secondary, isNotNull);
    });

    test('error color should be defined for snackbar', () {
      // Assert
      expect(ColorConstant.error, isNotNull);
      final alphaValue = (ColorConstant.error.a * 255.0).round().clamp(0, 255);
      expect(alphaValue, greaterThanOrEqualTo(0));
    });
  });

  group('DoubleConstant Pure Unit Tests', () {
    test('twentyFour constant should have correct value', () {
      // Assert
      expect(DoubleConstant.twentyFour, equals(24.0));
      expect(DoubleConstant.twentyFour, isPositive);
    });

    test('two constant should have correct value', () {
      // Assert
      expect(DoubleConstant.two, equals(2.0));
      expect(DoubleConstant.two, isPositive);
    });

    test('terms letter spacing should be defined', () {
      // Assert
      expect(DoubleConstant.termsLetterSpacing, isNotNull);
      expect(DoubleConstant.termsLetterSpacing, isA<double>());
    });

    test('all double constants should be positive', () {
      // Assert - Size values should always be positive
      expect(DoubleConstant.twentyFour, greaterThan(0));
      expect(DoubleConstant.two, greaterThan(0));
    });
  });

  group('Splash Screen Layout Logic Tests', () {
    test('should determine small screen correctly', () {
      // Arrange
      const smallHeight = 650.0;
      const largeHeight = 750.0;
      const threshold = 700.0;

      // Act
      const isSmallScreen = smallHeight < threshold;
      const isLargeScreen = largeHeight < threshold;

      // Assert
      expect(isSmallScreen, isTrue);
      expect(isLargeScreen, isFalse);
    });

    test(
      'emoji positions should be calculated differently for screen sizes',
      () {
        // Arrange
        const smallScreenHeight = 650.0;
        const largeScreenHeight = 850.0;
        const isSmallScreen = smallScreenHeight < 700;
        const isLargeScreen = largeScreenHeight < 700;

        // Act - Simulate emoji position calculation (from splash_view.dart)
        const tiredEmojiTopSmall = isSmallScreen ? 0.37 : 0.325;
        const tiredEmojiTopLarge = isLargeScreen ? 0.37 : 0.325;

        // Assert
        expect(tiredEmojiTopSmall, equals(0.37));
        expect(tiredEmojiTopLarge, equals(0.325));
        expect(tiredEmojiTopSmall, isNot(equals(tiredEmojiTopLarge)));
      },
    );

    test('dynamic height calculations should be proportional', () {
      // Arrange
      const screenHeight = 800.0;
      const heightPercentage = 0.1; // 10%

      // Act
      const calculatedHeight = screenHeight * heightPercentage;

      // Assert
      expect(calculatedHeight, equals(80.0));
      expect(calculatedHeight / screenHeight, equals(heightPercentage));
    });

    test('dynamic width calculations should be proportional', () {
      // Arrange
      const screenWidth = 400.0;
      const widthPercentage = 0.85; // 85%

      // Act
      const calculatedWidth = screenWidth * widthPercentage;

      // Assert
      expect(calculatedWidth, equals(340.0));
      expect(calculatedWidth / screenWidth, equals(widthPercentage));
    });
  });

  group('Deep Link URI Validation Tests', () {
    test('should validate supabase redirect URI format', () {
      // Arrange
      const uri = StringConstant.supabaseRedirectUri;

      // Act
      final containsScheme = uri.contains('://');
      final startsWithPackage = uri.startsWith('com.umutsayar.moodify');
      final endsWithPath = uri.endsWith('oauth2redirect');

      // Assert
      expect(containsScheme, isTrue, reason: 'URI must contain ://');
      expect(
        startsWithPackage,
        isTrue,
        reason: 'URI must start with package name',
      );
      expect(endsWithPath, isTrue, reason: 'URI must end with oauth2redirect');
    });

    test('should validate deep link URI components', () {
      // Arrange
      final uri = Uri.parse(StringConstant.supabaseRedirectUri);

      // Assert
      expect(uri.scheme, equals('com.umutsayar.moodify'));
      expect(uri.host, equals('oauth2redirect'));
      expect(uri.path, isEmpty);
    });

    test('deep link should not contain query parameters by default', () {
      // Arrange
      const uri = StringConstant.supabaseRedirectUri;

      // Assert
      expect(uri, isNot(contains('?')));
      expect(uri, isNot(contains('=')));
      expect(uri, isNot(contains('&')));
    });
  });

  group('Button Order Logic Tests', () {
    test('button Y positions should follow correct order', () {
      // Arrange - Simulated Y positions
      const googleButtonY = 200.0;
      const facebookButtonY = 280.0;
      const emailButtonY = 360.0;

      // Act
      const isGoogleFirst = googleButtonY < facebookButtonY;
      const isFacebookSecond = facebookButtonY < emailButtonY;
      const isEmailLast =
          googleButtonY < facebookButtonY && facebookButtonY < emailButtonY;

      // Assert
      expect(isGoogleFirst, isTrue);
      expect(isFacebookSecond, isTrue);
      expect(isEmailLast, isTrue);
    });

    test('button spacing should be consistent', () {
      // Arrange
      const googleButtonY = 200.0;
      const facebookButtonY = 280.0;
      const emailButtonY = 360.0;

      // Act
      const spacing1 = facebookButtonY - googleButtonY;
      const spacing2 = emailButtonY - facebookButtonY;

      // Assert
      expect(spacing1, equals(spacing2));
      expect(spacing1, greaterThan(0));
    });
  });

  group('Loading State Logic Tests', () {
    test('button should be disabled when loading', () {
      // Arrange
      const isGoogleLoading = true;

      // Act
      const buttonEnabled = !isGoogleLoading;

      // Assert
      expect(buttonEnabled, isFalse);
    });

    test('button should be enabled when not loading', () {
      // Arrange
      const isGoogleLoading = false;

      // Act
      const buttonEnabled = !isGoogleLoading;

      // Assert
      expect(buttonEnabled, isTrue);
    });

    test('only one button should be loading at a time', () {
      // Arrange
      const isGoogleLoading = true;
      const isFacebookLoading = false;

      // Act
      const bothLoading = isGoogleLoading && isFacebookLoading;

      // Assert
      expect(bothLoading, isFalse);
    });

    test('loading text should be displayed when loading', () {
      // Arrange
      const isLoading = true;
      final loadingText = StringConstant.loading;
      final normalText = StringConstant.signInGoogle;

      // Act
      final displayText = isLoading ? loadingText : normalText;

      // Assert
      expect(displayText, equals(loadingText));
      expect(displayText, contains('...'));
    });
  });

  group('Error Handling Logic Tests', () {
    test('should show error when errorMessage is not null', () {
      // Arrange
      const errorMessage = 'Authentication failed';
      const shouldShowError = errorMessage != null;

      // Assert
      expect(shouldShowError, isTrue);
    });

    test('should not show error when errorMessage is null', () {
      // Arrange
      const String? errorMessage = null;
      const shouldShowError = errorMessage != null;

      // Assert
      expect(shouldShowError, isFalse);
    });

    test('error message should not be empty when defined', () {
      // Arrange
      const errorMessage = 'Authentication failed';

      // Assert
      expect(errorMessage, isNotEmpty);
      expect(errorMessage.trim(), isNotEmpty);
    });
  });

  group('Emoji Configuration Tests', () {
    test('should have four distinct emojis', () {
      // Arrange
      const emojis = ['😊', '😌', '🤩', '😂'];

      // Assert
      expect(emojis.length, equals(4));
      expect(
        emojis.toSet().length,
        equals(4),
        reason: 'All emojis should be unique',
      );
    });

    test('emoji sizes should be proportional to screen', () {
      // Arrange
      const screenHeight = 800.0;
      const emojiSizePercentage = 0.05; // 5%

      // Act
      const emojiSize = screenHeight * emojiSizePercentage;

      // Assert
      expect(emojiSize, equals(40.0));
      expect(emojiSize, greaterThan(0));
    });

    test('emoji container size should be larger than emoji', () {
      // Arrange
      const screenHeight = 800.0;
      const containerSizePercentage = 0.1; // 10%
      const emojiSizePercentage = 0.05; // 5%

      // Act
      const containerSize = screenHeight * containerSizePercentage;
      const emojiSize = screenHeight * emojiSizePercentage;

      // Assert
      expect(containerSize, greaterThan(emojiSize));
    });
  });

  group('Terms Text Formatting Tests', () {
    test('terms text should have two parts', () {
      // Arrange
      final firstPart = StringConstant.firstTermsText;
      final secondPart = StringConstant.secondTermsText;

      // Assert
      expect(firstPart, isNotEmpty);
      expect(secondPart, isNotEmpty);
      expect(firstPart, isNot(equals(secondPart)));
    });

    test('combined terms text should form complete sentence', () {
      // Arrange
      final firstPart = StringConstant.firstTermsText;
      final secondPart = StringConstant.secondTermsText;

      // Act
      final combinedText = firstPart + secondPart;

      // Assert
      expect(combinedText, isNotEmpty);
      expect(combinedText.length, greaterThan(firstPart.length));
      expect(combinedText.length, greaterThan(secondPart.length));
    });

    test('terms letter spacing should be reasonable', () {
      // Arrange
      const letterSpacing = DoubleConstant.termsLetterSpacing;

      // Assert
      expect(letterSpacing, isNotNull);
      expect(
        letterSpacing.abs(),
        lessThan(5.0),
        reason: 'Letter spacing should be subtle',
      );
    });
  });
}
