import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class ChangeBottomNavigation extends BottomNavigationEvent {
  final int selectedIndex;

  const ChangeBottomNavigation(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
