enum Flavor {
  dev,
  prod,
}

extension FlavorName on Flavor {
  String get name => toString().split('.').last;
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Nss';
      case Flavor.prod:
        return 'Nss';
      default:
        return 'title';
    }
  }

  static final Map<String, dynamic> sharedMap = {};

  static final devMap = {
    // 'baseURL': 'https://api.kliknss.co.id',
    // //'baseURL': 'http://apiv2.kliknss.test',
    // 'socketURL': 'https://www.kliknss.co.id',

    // 'baseURL': 'https://api.kliknss.co.id',
    // 'socketURL': 'https://www.kliknss.co.id',
  
    // staging
    'baseURL': 'https://api-dev2.kliknss.co.id:8443',
    'socketURL': 'https://api-dev2.kliknss.co.id:8443',
   
    'baseURLImages':'https://staging.kliknss.co.id:8443/images/',
    // 'baseURL': 'https://api.kliknss.co.id',
    // 'socketURL': 'https://www.kliknss.co.id',
    ...sharedMap,
    // 'baseURL': 'https://api-dev2.kliknss.co.id',
    // //'baseURL': 'http://apiv2.kliknss.test',
    // 'socketURL': 'https://v2.kliknss.co.id',
    // ...sharedMap,
  };

  static final prodMap = {
    'baseURLImages': 'https://kliknss.co.id/images/',
    'baseURL': 'https://api.kliknss.co.id',
    'socketURL': 'https://www.kliknss.co.id',
    ...sharedMap,
  };

  static Map<String, dynamic> get variables {
    switch (appFlavor) {
      case Flavor.dev:
        return devMap;
      case Flavor.prod:
        return prodMap;
      default:
        return devMap;
    }
  }
}
