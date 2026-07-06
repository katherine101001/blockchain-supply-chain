import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/trace_log.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_full_state.dart';

class ProductFullCubit extends Cubit<ProductFullState> {
  ProductFullCubit(this._repository) : super(ProductFullInitial());

  final ProductRepository _repository;

  Future<void> load(String sku) async {
    emit(const ProductFullLoading());
    try {
      final (product, traceLogs, verified) =
          await _repository.getFullProduct(sku, verify: false);
      emit(ProductFullLoaded(
        product: product,
        traceLogs: traceLogs,
        verified: verified,
        isVerifying: false,
      ));
    } catch (e) {
      emit(ProductFullError(e.toString()));
    }
  }

  Future<void> verifyOnChain(String sku) async {
    final current = state;
    if (current is! ProductFullLoaded) {
      return;
    }

    emit(current.copyWith(isVerifying: true));

    try {
      final (product, traceLogs, verified) =
          await _repository.getFullProduct(sku, verify: true);
      emit(ProductFullLoaded(
        product: product,
        traceLogs: traceLogs,
        verified: verified,
        isVerifying: false,
      ));
    } catch (e) {
      emit(ProductFullError(e.toString()));
    }
  }
}


