part of 'product_summary_cubit.dart';

sealed class ProductSummaryState extends Equatable {
  const ProductSummaryState();

  @override
  List<Object?> get props => [];
}

final class ProductSummaryInitial extends ProductSummaryState {}

final class ProductSummaryLoading extends ProductSummaryState {}

final class ProductSummaryLoaded extends ProductSummaryState {
  const ProductSummaryLoaded(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

final class ProductSummaryError extends ProductSummaryState {
  const ProductSummaryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}


