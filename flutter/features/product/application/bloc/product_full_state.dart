part of 'product_full_cubit.dart';

sealed class ProductFullState extends Equatable {
  const ProductFullState();

  @override
  List<Object?> get props => [];
}

final class ProductFullInitial extends ProductFullState {
  const ProductFullInitial();
}

final class ProductFullLoading extends ProductFullState {
  const ProductFullLoading();
}

final class ProductFullLoaded extends ProductFullState {
  const ProductFullLoaded({
    required this.product,
    required this.traceLogs,
    required this.verified,
    required this.isVerifying,
  });

  final ProductFull product;
  final List<TraceLog> traceLogs;
  final bool verified;
  final bool isVerifying;

  ProductFullLoaded copyWith({
    ProductFull? product,
    List<TraceLog>? traceLogs,
    bool? verified,
    bool? isVerifying,
  }) {
    return ProductFullLoaded(
      product: product ?? this.product,
      traceLogs: traceLogs ?? this.traceLogs,
      verified: verified ?? this.verified,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }

  @override
  List<Object?> get props => [product, traceLogs, verified, isVerifying];
}

final class ProductFullError extends ProductFullState {
  const ProductFullError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}


