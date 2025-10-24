enum OptionEditProduct {
  all('ALL'),
  empty('NULL'),
  sell('SELL'),
  import('IMPORT');

  const OptionEditProduct(this.title);
  
  final String title;
}