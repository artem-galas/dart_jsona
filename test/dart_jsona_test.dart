import 'package:test/test.dart';

import 'package:dart_jsona/dart_jsona.dart';

import 'mock.dart';

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

      test('should deserialize example from JSONapi.org', () {

        dynamic jsonApiModel = jsona.deserialize(jsonApiExample);

        expect(jsonApiModel, equals(jsonApiModel));
      });
    });

    group('serialize', () {
      test('should build json with item, without included', () {
        var jsonBody = jsona.serialize(stuff: town1['model']);

        expect(jsonBody['data'], equals(town1['json']));
        expect(jsonBody['included'], equals(null));
      });

      test('should build json with collection, with included', () {
        var jsonBody = jsona.serialize(stuff: user2['model'], includeNames: ['specialty', 'town']);

        expect(jsonBody['data'], equals(user2['json']));
        expect(jsonBody['included'], equals([specialty1['json'], specialty2['json'], town2['json']]));
      });
    });
  });
}
