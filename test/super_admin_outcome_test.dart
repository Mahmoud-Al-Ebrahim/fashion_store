import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/blocs/super_admin_bloc/super_admin_bloc.dart';

/// Regression tests for the two wrong-message bugs reported on the admin
/// screens.
///
/// Both had the same cause: action statuses were sticky. Nothing ever moved
/// them back to `init`, so a screen reacting with
/// `if (a == success) ... else if (b == success) ...` kept matching an
/// action the user had run minutes earlier.
void main() {
  group('the reported bugs, reproduced against the old sticky behaviour', () {
    test('banning after an unban used to announce "unbanned"', () {
      // The user unbans somebody...
      var state = SuperAdminState(unbanUserStatus: UnbanUserStatus.success);

      // ...then bans somebody else. Without the reset, BOTH statuses read
      // `success` and the old if/else chain announced whichever came first.
      final sticky = state.copyWith(
        revokeUserTokenStatus: RevokeUserTokenStatus.success,
      );
      expect(
        sticky.unbanUserStatus,
        UnbanUserStatus.success,
        reason: 'this is the stale value that hijacked the message',
      );

      // With the fix, starting the ban clears the previous outcome first.
      state = state
          .clearActionOutcomes()
          .copyWith(revokeUserTokenStatus: RevokeUserTokenStatus.loading);
      expect(state.unbanUserStatus, UnbanUserStatus.init);

      state = state.copyWith(
        revokeUserTokenStatus: RevokeUserTokenStatus.success,
      );
      expect(state.actionOutcome, SuperAdminOutcome.banned);
    });

    test('a successful role add used to replay the previous error', () {
      // First attempt fails: "المستخدم لديه الدور مسبقا".
      var state = SuperAdminState()
          .clearActionOutcomes()
          .copyWith(addRoleStatus: AddRoleStatus.loading);
      state = state.copyWith(
        addRoleStatus: AddRoleStatus.failure,
        errorMessage: 'المستخدم لديه الدور مسبقا',
      );
      expect(state.actionOutcome, SuperAdminOutcome.failure);
      expect(state.errorMessage, isNotEmpty);

      // Second attempt starts. The old code kept `errorMessage` populated,
      // so the stale text was shown again before the success message.
      state = state
          .clearActionOutcomes()
          .copyWith(addRoleStatus: AddRoleStatus.loading);
      expect(state.errorMessage, isEmpty);
      expect(
        state.actionOutcome,
        SuperAdminOutcome.none,
        reason: 'nothing to announce while the request is in flight',
      );

      state = state.copyWith(addRoleStatus: AddRoleStatus.success);
      expect(state.actionOutcome, SuperAdminOutcome.roleAdded);
    });
  });

  _decisionTests();

  group('actionOutcome', () {
    test('is none on a fresh state', () {
      expect(SuperAdminState().actionOutcome, SuperAdminOutcome.none);
    });

    test('never reports an error left over from a finished action', () {
      // A failure, then a *successful* different action: the error text is
      // still in the state, but it must not win.
      final state = SuperAdminState(
        errorMessage: 'stale failure text',
      ).clearActionOutcomes().copyWith(
            deleteUserStatus: DeleteUserStatus.success,
          );
      expect(state.actionOutcome, SuperAdminOutcome.deleted);
    });

    test('reports an error only once an action actually failed', () {
      // errorMessage set but every action status still init - e.g. a failed
      // *read*. Nothing to announce as an action failure.
      final state = SuperAdminState(errorMessage: 'a list failed to load');
      expect(state.actionOutcome, SuperAdminOutcome.none);
    });

    test('maps each action to its own outcome', () {
      final cases = <SuperAdminState, SuperAdminOutcome>{
        SuperAdminState(revokeUserTokenStatus: RevokeUserTokenStatus.success):
            SuperAdminOutcome.banned,
        SuperAdminState(unbanUserStatus: UnbanUserStatus.success):
            SuperAdminOutcome.unbanned,
        SuperAdminState(deleteUserStatus: DeleteUserStatus.success):
            SuperAdminOutcome.deleted,
        SuperAdminState(addRoleStatus: AddRoleStatus.success):
            SuperAdminOutcome.roleAdded,
        SuperAdminState(removeRoleStatus: RemoveRoleStatus.success):
            SuperAdminOutcome.roleRemoved,
      };
      cases.forEach((state, expected) {
        expect(state.actionOutcome, expected);
      });
    });

    test('clearActionOutcomes leaves loaded data alone', () {
      // Resetting outcomes must not wipe the lists the screen is showing.
      final state = SuperAdminState(
        addRoleStatus: AddRoleStatus.success,
        getActiveUsersStatus: GetActiveUsersStatus.success,
      ).clearActionOutcomes();

      expect(state.addRoleStatus, AddRoleStatus.init);
      expect(
        state.getActiveUsersStatus,
        GetActiveUsersStatus.success,
        reason: 'read statuses are not action outcomes',
      );
    });
  });
}

/// Approve and reject share `storeRequestDecisionStatus`, so the screen used
/// to announce "approved" for both. `lastDecisionWasApproval` disambiguates.
void _decisionTests() {
  group('store request decision', () {
    test('an approval is flagged as one', () {
      final state = SuperAdminState().clearActionOutcomes().copyWith(
            storeRequestDecisionStatus: StoreRequestDecisionStatus.success,
            lastDecisionWasApproval: true,
          );
      expect(state.lastDecisionWasApproval, isTrue);
      expect(state.actionOutcome, SuperAdminOutcome.storeRequestDecided);
    });

    test('a rejection is not mistaken for an approval', () {
      final state = SuperAdminState().clearActionOutcomes().copyWith(
            storeRequestDecisionStatus: StoreRequestDecisionStatus.success,
            lastDecisionWasApproval: false,
          );
      expect(
        state.lastDecisionWasApproval,
        isFalse,
        reason: 'this is what made a rejection say "approved"',
      );
    });

    test('rejecting after approving does not inherit the previous flag', () {
      var state = SuperAdminState().clearActionOutcomes().copyWith(
            storeRequestDecisionStatus: StoreRequestDecisionStatus.success,
            lastDecisionWasApproval: true,
          );
      state = state.clearActionOutcomes().copyWith(
            storeRequestDecisionStatus: StoreRequestDecisionStatus.loading,
            lastDecisionWasApproval: false,
          );
      expect(state.lastDecisionWasApproval, isFalse);
    });
  });
}
