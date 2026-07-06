class EtherscanUrlBuilder {
  static Uri sepoliaTx(String txHash) {
    return Uri.parse('https://sepolia.etherscan.io/tx/$txHash');
  }
}
