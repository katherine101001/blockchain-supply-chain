import '../../domain/entities/blockchain_record.dart';
import '../../domain/repositories/explorer_repository.dart';
import '../datasources/etherscan_url_builder.dart';

class ExplorerRepositoryImpl implements ExplorerRepository {
  @override
  Uri buildExplorerUrl(BlockchainRecord record) {
    if (record.network == 'sepolia') {
      return EtherscanUrlBuilder.sepoliaTx(record.transactionHash);
    }

    throw UnsupportedError('Network not supported');
  }
}
