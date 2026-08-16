enum AccountKindValue { store, normalUser }

final List<_AccountKind> kinds = [
  _AccountKind("متجر", "assets/svg/choose_hand_made.svg", AccountKindValue.store),
  // _AccountKind("متجر", Assets.svgChooseStore, AccountKindValue.store),
  _AccountKind(
    "مستخدم عادي",
    "assets/svg/user.svg",
    AccountKindValue.normalUser,
  ),
];

class _AccountKind {
  final String title;
  final String icon;
  final AccountKindValue value;

  _AccountKind(this.title, this.icon, this.value);
}
