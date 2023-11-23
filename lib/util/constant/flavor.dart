enum Flavor {
  prod,
  dev;

  String get name {
    switch (this) {
      case Flavor.prod:
        return 'prod';
      case Flavor.dev:
        return 'dev';
    }
  }

  static Flavor fromString(String name) {
    switch (name) {
      case 'prod':
        return Flavor.prod;
      case 'dev':
        return Flavor.dev;
      default:
        throw UnsupportedError(
          'this flavor is not expected',
        );
    }
  }
}
