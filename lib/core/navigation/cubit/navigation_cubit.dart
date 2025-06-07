import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum NavigationTab {
  home,
  discovery,
  gallery,
  solarSystem,
  profile
}

// Navigation State
abstract class NavigationState extends Equatable {
  final NavigationTab currentTab;
  
  const NavigationState({required this.currentTab});
  
  @override
  List<Object> get props => [currentTab];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial({required NavigationTab currentTab}) 
      : super(currentTab: currentTab);
}

class NavigationChanged extends NavigationState {
  const NavigationChanged({required NavigationTab currentTab}) 
      : super(currentTab: currentTab);
}

// Navigation Cubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationInitial(currentTab: NavigationTab.home));

  void changeTab(NavigationTab tab) {
    if (state.currentTab != tab) {
      emit(NavigationChanged(currentTab: tab));
    }
  }

  void goToHome() => changeTab(NavigationTab.home);
  void goToDiscovery() => changeTab(NavigationTab.discovery);
  void goToGallery() => changeTab(NavigationTab.gallery);
  void goToSolarSystem() => changeTab(NavigationTab.solarSystem);
  void goToProfile() => changeTab(NavigationTab.profile);
}