abstract class ExplorerState {}

class ExplorerInitial extends ExplorerState {}

class ExplorerReady extends ExplorerState {
  final Uri explorerUrl;

  ExplorerReady(this.explorerUrl);
}

class ExplorerError extends ExplorerState {
  final String message;

  ExplorerError(this.message);
}
