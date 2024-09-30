abstract class NavigationEvent {}

class PageSelected extends NavigationEvent {
  final int index;
  PageSelected(this.index);
}