import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/entities/product_scan.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeLoadingState()) {
    // Initial load event
    on<HomeLoadEvent>((event, emit) async {
      emit(HomeLoadingState());
      try {
        final scans = await repository.getRecentScans();
        emit(HomeLoadedState(recentScans: scans));
      } catch (e) {
        // emit(HomeErrorState(e.toString())); // TODO: Add Error State
        emit(HomeLoadedState(recentScans: [])); // Fallback
      }
    });

    // Scan event handler
    on<HomeScanEvent>((event, emit) async {
      if (state is HomeLoadedState) {
        try {
          await repository.addScan(event.sku);

          // Re-fetch to get updated data
          final scans = await repository.getRecentScans();
          emit(HomeLoadedState(recentScans: scans));
        } catch (e) {
          // Handle error - keep current state
        }
      }
    });
  }
}

// Event definition
class HomeScanEvent extends HomeEvent {
  final String sku;
  const HomeScanEvent(this.sku);

  @override
  List<Object?> get props => [sku];
}
