part of 'product_verification_cubit.dart';

abstract class ProductVerificationState extends Equatable {
  const ProductVerificationState();

  @override
  List<Object?> get props => [];
}

class ProductVerificationInitial extends ProductVerificationState {}

class ProductVerificationLoading extends ProductVerificationState {}

class ProductVerificationLoaded extends ProductVerificationState {
  const ProductVerificationLoaded({
    required this.traceLogs,
    required this.verified,
  });

  final List<TraceLog> traceLogs;
  final bool verified;

  @override
  List<Object?> get props => [traceLogs, verified];
}

class ProductVerificationError extends ProductVerificationState {
  const ProductVerificationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

