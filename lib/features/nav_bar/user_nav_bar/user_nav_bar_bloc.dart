import 'package:bloc/bloc.dart';

abstract class NavBarEvent {}

class ChangeNavBar extends NavBarEvent {
  final int index;

  /// Which tab the Explore screen should show once it is on top - 0 for
  /// products, 1 for stores. Only meaningful when [index] selects Explore;
  /// null leaves whichever tab the user was last on.
  final int? exploreTab;

  ChangeNavBar({required this.index, this.exploreTab});
}

class NavBarState {
  final int currentIndex;

  /// The Explore tab requested by the last [ChangeNavBar] that named one.
  final int exploreTab;

  /// Incremented on every request so that asking for the tab you are
  /// already on still moves the screen. Without it a second "see more" tap
  /// emitted an identical state and the listener never fired.
  final int exploreTabRequest;

  const NavBarState({
    this.currentIndex = 0,
    this.exploreTab = 0,
    this.exploreTabRequest = 0,
  });

  NavBarState copyWith({
    int? currentIndex,
    int? exploreTab,
    int? exploreTabRequest,
  }) {
    return NavBarState(
      currentIndex: currentIndex ?? this.currentIndex,
      exploreTab: exploreTab ?? this.exploreTab,
      exploreTabRequest: exploreTabRequest ?? this.exploreTabRequest,
    );
  }
}

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarState()) {
    on<ChangeNavBar>((event, emit) {
      emit(
        state.copyWith(
          currentIndex: event.index,
          exploreTab: event.exploreTab,
          exploreTabRequest: event.exploreTab == null
              ? null
              : state.exploreTabRequest + 1,
        ),
      );
    });
  }
}
