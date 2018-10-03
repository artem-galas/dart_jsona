import 'package:dart_jsona/dart_jsona.dart';
import 'package:test/test.dart';
import 'dart:convert';

import 'package:dart_jsona/src/models/jsona_types.dart';

JsonApiBody user;

void main() {
  group('Jsona', () {
    Jsona jsona;

    setUp(() {
      jsona = new Jsona();
    });

    group('deserialize', () {
      test('should deserialize item without included', () {
        final personJson = {
          'data': {
            'id': '1',
            'type': 'person',
            'attributes': {
              'name': 'Artem',
              'age': 25
            }
          }
        };

        var serialized = jsona.deserialize(personJson);

        expect(serialized['name'], equals('Artem'));
        expect(serialized['age'], equals(25));
      });

      test('should desserialize collection without included', () {
        final personsJson = {
          'data': [
            {
              'id': '1',
              'type': 'person',
              'attributes': {
                'name': 'Artem',
                'age': 25
              }
            },
            {
              'id': '2',
              'type': 'person',
              'attributes': {
                'name': 'Luke',
                'age': 34
              }
            }
          ]
        };

        var serialized = jsona.deserialize(personsJson);

        print(serialized);
      });

      test('should deserialize object with relation', () {
        final townJson = {
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

        var serialized = jsona.deserialize(townJson);

        print(serialized);
      });
    });
  });
}


String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);