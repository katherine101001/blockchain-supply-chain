import '../entities/blockchain_record.dart';

abstract class ExplorerRepository {
  Uri buildExplorerUrl(BlockchainRecord record);
}
