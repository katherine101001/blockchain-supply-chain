part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<ProductScan> recentScans;
  const HomeLoadedState({required this.recentScans});

  @override
  List<Object?> get props => [recentScans];
}
