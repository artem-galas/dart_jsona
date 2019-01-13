void createIncludeNamesTree(
  String namesChain, Map<String, Object> includeTree) {
  List<String> namesArray = namesChain.split('.');
  String currentIncludeName = namesArray.removeAt(0);
  int chainHasMoreNames = namesArray.length;

  var subTree = null;

  if (chainHasMoreNames > 0) {
    subTree = includeTree[currentIncludeName];
    createIncludeNamesTree(namesArray.join('.'), subTree);
  }

  includeTree[currentIncludeName] = subTree;
}
