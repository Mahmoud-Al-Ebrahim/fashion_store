import 'package:bloc/bloc.dart';

abstract class NavBarEvent {

}

class ChangeNavBar extends NavBarEvent {
  final int index;
  ChangeNavBar({required this.index});

}

class NavBarState {
  final int currentIndex;
  const NavBarState({this.currentIndex = 0});

  NavBarState copyWith({int? currentIndex}) {
    return NavBarState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

}


class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarState()) {
    on<ChangeNavBar>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
}
