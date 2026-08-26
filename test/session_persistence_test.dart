import 'package:fashion_store/core/utils/my_shared_pref.dart';
import 'package:fashion_store/core/utils/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guards the two things that silently break a session: the onboarding
/// "seen" flag and the persisted login state that decides which surface a
/// returning user lands on.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await MySharedPref.init();
  });

  group('onboarding', () {
    test('defaults to unseen, then stays seen once marked', () async {
      expect(MySharedPref.getOnBoardingSeen(), isFalse);

      await MySharedPref.setOnBoardingSeen();
      expect(MySharedPref.getOnBoardingSeen(), isTrue);

      // Simulate a fresh app launch reading the same store.
      await MySharedPref.init();
      expect(MySharedPref.getOnBoardingSeen(), isTrue);
    });

    test('survives signing out', () async {
      await MySharedPref.setOnBoardingSeen();
      await MySharedPref.clearAuthData();
      expect(MySharedPref.getOnBoardingSeen(), isTrue);
    });
  });

  group('login persistence', () {
    test('token, refresh token, roles and user id round-trip', () async {
      await MySharedPref.saveToken('access-123');
      await MySharedPref.saveRefreshToken('refresh-456');
      await MySharedPref.saveRoles([ApiRoles.user, ApiRoles.storeOwner]);
      await MySharedPref.saveUserId('user-789');
      await MySharedPref.saveEmail('someone@example.com');

      await MySharedPref.init(); // fresh launch

      expect(MySharedPref.getToken(), 'access-123');
      expect(MySharedPref.getRefreshToken(), 'refresh-456');
      expect(MySharedPref.getRoles(), [ApiRoles.user, ApiRoles.storeOwner]);
      expect(MySharedPref.getUserId(), 'user-789');
      expect(MySharedPref.getEmail(), 'someone@example.com');
    });

    test('signing out clears every auth artefact', () async {
      await MySharedPref.saveToken('t');
      await MySharedPref.saveRefreshToken('r');
      await MySharedPref.saveRoles([ApiRoles.superAdmin]);
      await MySharedPref.saveUserId('u');

      await MySharedPref.clearAuthData();

      expect(MySharedPref.getToken(), isNull);
      expect(MySharedPref.getRefreshToken(), isNull);
      expect(MySharedPref.getRoles(), isEmpty);
      expect(MySharedPref.getUserId(), isNull);
      expect(Session.role, AppRole.guest);
    });
  });

  group('role resolution', () {
    Future<void> signInAs(List<String> roles) async {
      await MySharedPref.saveToken('token');
      await MySharedPref.saveRoles(roles);
    }

    test('no token means guest even if roles linger', () async {
      await MySharedPref.saveRoles([ApiRoles.superAdmin]);
      expect(Session.role, AppRole.guest);
      expect(Session.isSignedIn, isFalse);
    });

    test('plain user', () async {
      await signInAs([ApiRoles.user]);
      expect(Session.role, AppRole.user);
      expect(Session.canManageStore, isFalse);
      expect(Session.canTopUpWallets, isFalse);
    });

    test('store owner', () async {
      await signInAs([ApiRoles.user, ApiRoles.storeOwner]);
      expect(Session.role, AppRole.storeOwner);
      expect(Session.canManageStore, isTrue);
      expect(Session.canTopUpWallets, isFalse);
    });

    test('payment employee', () async {
      await signInAs([ApiRoles.user, ApiRoles.paymentEmployee]);
      expect(Session.role, AppRole.paymentEmployee);
      expect(Session.canTopUpWallets, isTrue);
      expect(Session.canManageStore, isFalse);
    });

    test('super admin outranks the other roles it also holds', () async {
      await signInAs([
        ApiRoles.user,
        ApiRoles.storeOwner,
        ApiRoles.superAdmin,
      ]);
      expect(Session.role, AppRole.superAdmin);
      expect(Session.canManageStore, isTrue);
      expect(Session.canTopUpWallets, isTrue);
    });
  });

  // Every signed-in user, whatever their role, must recognise their own
  // comments so the edit/delete menu appears on them.
  group('comment ownership is role independent', () {
    for (final role in [
      ApiRoles.user,
      ApiRoles.storeOwner,
      ApiRoles.paymentEmployee,
      ApiRoles.superAdmin,
    ]) {
      test('$role owns its own comment but not another user\'s', () async {
        await MySharedPref.saveToken('token');
        await MySharedPref.saveRoles([role]);
        await MySharedPref.saveUserId('me-123');

        expect(Session.owns('me-123'), isTrue);
        expect(Session.owns('someone-else'), isFalse);
      });
    }

    test('guests own nothing', () async {
      expect(Session.currentUserId, isNull);
      expect(Session.owns('me-123'), isFalse);
    });

    test('falls back to the JWT when the stored id is missing', () async {
      // A token whose nameidentifier claim is "jwt-user-1", simulating a
      // session created before the id was persisted separately.
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5'
          'L2NsYWltcy9uYW1laWRlbnRpZmllciI6Imp3dC11c2VyLTEifQ.'
          'signature';
      await MySharedPref.saveToken(token);
      await MySharedPref.saveRoles([ApiRoles.user]);

      expect(Session.currentUserId, 'jwt-user-1');
      expect(Session.owns('jwt-user-1'), isTrue);
      expect(Session.owns('other'), isFalse);
    });
  });
}

