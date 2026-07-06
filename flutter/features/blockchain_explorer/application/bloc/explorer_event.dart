abstract class ExplorerEvent {}

class VerifyOnChainRequested extends ExplorerEvent {
  final String txHash;

  VerifyOnChainRequested(this.txHash);
}

class ExplorerBrowseRequested extends ExplorerEvent {}
