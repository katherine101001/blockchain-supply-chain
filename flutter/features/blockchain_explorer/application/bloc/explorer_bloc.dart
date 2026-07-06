import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/blockchain_record.dart';
import '../../domain/repositories/explorer_repository.dart';
import '../../application/bloc/explorer_event.dart';
import '../../application/bloc/explorer_state.dart';

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final ExplorerRepository repository;

  ExplorerBloc(this.repository) : super(ExplorerInitial()) {
    on<VerifyOnChainRequested>((event, emit) {
      try {
        final record = BlockchainRecord(
          network: 'sepolia',
          transactionHash: event.txHash,
        );

        final url = repository.buildExplorerUrl(record);
        emit(ExplorerReady(url));
      } catch (e) {
        emit(ExplorerError(e.toString()));
      }
    });

    on<ExplorerBrowseRequested>((event, emit) {
      try {
        final record = BlockchainRecord(
          network: 'sepolia',
          transactionHash: '',
        );
        final url = repository.buildExplorerUrl(record);
        emit(ExplorerReady(url));
      } catch (e) {
        emit(ExplorerError(e.toString()));
      }
    });
  }
}
