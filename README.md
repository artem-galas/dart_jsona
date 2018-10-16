# dart_jsona

Is'a ported to dart - [Jsona TS](https://github.com/olosegres/jsona)

Framework agnostic, cutomizeble library that provide data formatters to simplify work with JSON API v1.0 specification.

## Usage

A simple usage example:

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
       *  type: town,
       *  id: 123,
       *  name: Barcelona,
       *  country: {
       *    type: country,
       *    id: 32, name: Spain
       *  },
       *  relationshipNames: [country]}
       */
    }

