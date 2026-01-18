import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot_di/spot_di.dart';
import 'package:trip_planner/config/routing/routes.dart';
import 'package:trip_planner/screens/auth/signin_screen.dart';
import 'package:trip_planner/services/auth_service.dart';

// Mock AuthService
class MockAuthService extends AuthService {
  bool signInCalled = false;
  AuthUser? mockUser;
  bool shouldThrow = false;

  @override
  Future<AuthUser?> signInWithGoogle() async {
    signInCalled = true;
    if (shouldThrow) {
      throw Exception('Mock Sign In Error');
    }
    return mockUser;
  }
}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    try {
      // Try to get existing mock if already initialized
      mockAuthService = spot<AuthService>() as MockAuthService;
    } catch (e) {
      // If not initialized or not our mock, initialize it
      mockAuthService = MockAuthService();
      Spot.init((factory, single) {
        single<AuthService, AuthService>((get) => mockAuthService);
      });
    }

    // Reset state for each test
    mockAuthService.signInCalled = false;
    mockAuthService.mockUser = null;
    mockAuthService.shouldThrow = false;
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(home: SignInScreen());
  }

  testWidgets('SignInScreen shows Google Sign In button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.login), findsOneWidget);
    expect(find.text('Sign In with Google'), findsOneWidget);
  });

  testWidgets('Tapping Sign In calls AuthService.signInWithGoogle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.login));
    await tester.pump();

    expect(mockAuthService.signInCalled, isTrue);
  });

  testWidgets('Successful sign in navigates to Home', (
    WidgetTester tester,
  ) async {
    mockAuthService.mockUser = AuthUser(uid: '123', email: 'test@example.com');

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          Routes.home: (context) => const Scaffold(body: Text('Home Screen')),
          '/login': (context) => const SignInScreen(),
        },
        initialRoute: '/login',
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('Failed sign in shows SnackBar', (WidgetTester tester) async {
    mockAuthService.shouldThrow = true;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.login));

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Sign in failed'), findsOneWidget);
  });
}
