abstract class NavigationState {}

class PageLoading extends NavigationState {}

class PageLoaded extends NavigationState {
  final int selectedIndex;
  PageLoaded(this.selectedIndex);
}