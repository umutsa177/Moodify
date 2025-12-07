import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/feature/splash/view/splash_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/auth_status.dart';
import 'package:provider/provider.dart';

import 'splash_view_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(
        home: SplashView(),
      ),
    );
  }

  group('SplashView Widget Tests', () {
    testWidgets('should display splash title and subtitle', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.splashTitle), findsOneWidget);
      expect(find.text(StringConstant.splashSubtitle), findsOneWidget);
    });

    testWidgets('should display all emoji widgets', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('😊'), findsOneWidget);
      expect(find.text('😌'), findsOneWidget);
      expect(find.text('🤩'), findsOneWidget);
      expect(find.text('😂'), findsOneWidget);
    });

    testWidgets('should display gradient background', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox).first,
      );
      final boxDecoration = decoratedBox.decoration as BoxDecoration;
      final gradient = boxDecoration.gradient! as LinearGradient;

      expect(gradient.colors, equals(ColorConstant.splashBackgroundColors));
    });

    testWidgets('should display Google login button', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.signInGoogle), findsOneWidget);
    });

    testWidgets('should display Facebook login button', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.signInFacebook), findsOneWidget);
    });

    testWidgets('should display email signup button', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.emailSignup), findsOneWidget);
    });

    testWidgets('should display terms text', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.firstTermsText), findsOneWidget);
      expect(find.text(StringConstant.secondTermsText), findsOneWidget);
    });

    testWidgets('should display separator text', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.seperateText), findsOneWidget);
    });

    testWidgets('should call signInWithGoogle when Google button is tapped', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);
      when(mockAuthProvider.signInWithGoogle()).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text(StringConstant.signInGoogle));
      await tester.pump();

      // Assert
      verify(mockAuthProvider.signInWithGoogle()).called(1);
    });

    testWidgets(
      'should call signInWithFacebook when Facebook button is tapped',
      (tester) async {
        // Arrange
        when(mockAuthProvider.isAuthenticated).thenReturn(false);
        when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
        when(mockAuthProvider.errorMessage).thenReturn(null);
        when(mockAuthProvider.isGoogleLoading).thenReturn(false);
        when(mockAuthProvider.isFacebookLoading).thenReturn(false);
        when(mockAuthProvider.signInWithFacebook()).thenAnswer((_) async => {});

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text(StringConstant.signInFacebook));
        await tester.pump();

        // Assert
        verify(mockAuthProvider.signInWithFacebook()).called(1);
      },
    );

    testWidgets('should disable Google button when loading', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(true);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.loading), findsOneWidget);
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.loading),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('should disable Facebook button when loading', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.loading), findsOneWidget);
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.loading),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('should show loading indicator on Google button when loading', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(true);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display all buttons in correct order', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final googleButton = find.text(StringConstant.signInGoogle);
      final facebookButton = find.text(StringConstant.signInFacebook);
      final emailButton = find.text(StringConstant.emailSignup);

      expect(googleButton, findsOneWidget);
      expect(facebookButton, findsOneWidget);
      expect(emailButton, findsOneWidget);

      final googleY = tester.getTopLeft(googleButton).dy;
      final facebookY = tester.getTopLeft(facebookButton).dy;
      final emailY = tester.getTopLeft(emailButton).dy;

      expect(googleY < facebookY, isTrue);
      expect(facebookY < emailY, isTrue);
    });

    testWidgets('should have correct button styles', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final googleButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.signInGoogle),
      );
      expect(
        googleButton.style?.backgroundColor?.resolve({}),
        ColorConstant.primary,
      );

      final facebookButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.signInFacebook),
      );
      expect(
        facebookButton.style?.backgroundColor?.resolve({}),
        ColorConstant.facebookLoginBackground,
      );

      final emailButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.emailSignup),
      );
      expect(
        emailButton.style?.backgroundColor?.resolve({}),
        ColorConstant.emailBackground,
      );
    });

    testWidgets('should position emojis correctly on small screen', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Set small screen size
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('😊'), findsOneWidget);
      expect(find.text('😌'), findsOneWidget);
      expect(find.text('🤩'), findsOneWidget);
      expect(find.text('😂'), findsOneWidget);

      // Reset
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should render correctly on large screen', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Set large screen size
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.splashTitle), findsOneWidget);
      expect(find.text(StringConstant.splashSubtitle), findsOneWidget);

      // Reset
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should have Consumer widget wrapping content', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Consumer<AuthProvider>), findsOneWidget);
    });
  });
}
