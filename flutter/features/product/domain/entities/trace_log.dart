import 'package:equatable/equatable.dart';

class TraceLog extends Equatable {
  final DateTime timestamp;
  final String blockchainNetwork;
  final String status;
  final String txHash;
  final bool? verified;

  const TraceLog({
    required this.timestamp,
    required this.blockchainNetwork,
    required this.status,
    required this.txHash,
    required this.verified,
  });

  @override
  List<Object?> get props => [timestamp, blockchainNetwork, status, txHash, verified];
}


