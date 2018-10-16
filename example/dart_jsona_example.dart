import 'package:dart_jsona/dart_jsona.dart';

void main() {
  Jsona jsona = new Jsona();

  Map<String, dynamic> body = {
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

  final dynamic town = jsona.deserialize(body);

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


  Map<String, Object> jsonBody = jsona.serialize(stuff: town, includeNames: ['country']);

  print(jsonBody);
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
