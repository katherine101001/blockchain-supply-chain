import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_summary_state.dart';

class ProductSummaryCubit extends Cubit<ProductSummaryState> {
  ProductSummaryCubit(this._repository) : super(ProductSummaryInitial());

  final ProductRepository _repository;

  Future<void> load(String sku) async {
    emit(ProductSummaryLoading());
    try {
      final product = await _repository.getProductSummary(sku);
      emit(ProductSummaryLoaded(product));
    } catch (e) {
      emit(ProductSummaryError(e.toString()));
    }
  }
}


