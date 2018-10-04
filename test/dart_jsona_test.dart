import 'package:test/test.dart';

import 'package:dart_jsona/dart_jsona.dart';
import 'package:dart_jsona/src/models/jsona_types.dart';

import 'mock.dart';

JsonApiBody user;

void main() {
  group('Jsona', () {
    Jsona jsona;

    setUp(() {
      jsona = new Jsona();
    });

    group('deserialize', () {
      test('should deserialize item without included', () {
        var userModel = jsona.deserialize({'data': user2['json']});

        expect(userModel, equals(user2['modelWithoutIncluded']));
      });

      test('should desserialize collection without included', () {
        var townsCollection = jsona.deserialize({
          'data': [town1['json'], town2['json']],
          'included': [country1['json'], country2['json']]
        });

        expect(townsCollection, equals([town1['model'], town2['model']]));
      });
    });
  });
}
