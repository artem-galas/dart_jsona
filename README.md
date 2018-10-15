# dart_jsona

Is'a ported to dart - [Jsona TS](https://github.com/olosegres/jsona)

Framework agnostic, customizable library that provide data formatters to simplify work with JSON API v1.0 specification.

This package don't have any dependencies and pretty simple. It used `Map<String, dynamic>` a lot 😑

It was designed to work with [json_serializable](https://pub.dartlang.org/packages/json_serializable)

## Usage

### Deserializer - creates simplified object(s) from json

```
import 'package:dart_jsona/dart_jsona.dart';

main() {
  Jsona jsona = new Jsona();

  final body = {
    'data': {
      'type': 'town',
      'id': '123',
      'attributes': {
        'name': 'Barcelona',
      },
      'relationships': {
        'country': {
          'data': {
            'type': 'country',
            'id': '32',
          }
        }
      }
    },
    'included': [{
      'type': 'country',
      'id': '32',
      'attributes': {
        'name': 'Spain',
      }
    }]
  };

  final town = jsona.deserialize(body);

  print(town);
  /**
   * {
   *   type: town,
   *   id: 123,
   *   name: Barcelona,
   *   country: {
   *     type: country,
   *     id: 32, name: Spain
   *   },
   *   relationshipNames: [country]
   * }
   */
}
```

### Serializer - creates json from simplified object(s)
```
import 'package:dart_jsona/dart_jsona.dart';
main() {
    Jsona jsona = new Jsona();

    Map<String dynamic> newJson = jsona.serialize(stuff: town, includedNames: ['country']);

    print(newJson);

    /**
    * {
    *   data: {
    *     id: 123,
    *     type: town,
    *     attributes: {
    *       name: Barcelona
    *     },
    *     relationships: {
    *       country: {
    *         data: {
    *           id: 32, type: country
    *         }
    *       }
    *     }
    *   },
    *   included: [{
    *     id: 32,
    *     type: country,
    *     attributes: {
    *       name: Spain
    *     }
    *   }]
    * }
    */
}
```

## Contributing

Contributing are welcome.

This package on an early stage, and I'll be happy if you fix or create a new feature.

You just need follow these steps:
- Fork the repo
- Make new branch
- Write code magic
- Write tests
- Create PR

## License
Jsona, examples provided in this repository and in the documentation are [MIT licensed](./LICENSE).
