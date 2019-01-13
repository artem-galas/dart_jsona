import 'package:dart_jsona/src/models/jsona_types.dart';

class JsonDeserializer {
  dynamic body;
  AbsJsonPropertiesMapper propertiesMapper;
  Map<String, Object> includedInObject;
  Map<String, Object> cachedModels = {};

  JsonDeserializer(propertiesMapper) {
    setPropertiesMapper(propertiesMapper);
  }

  void setPropertiesMapper(pm) {
    propertiesMapper = pm;
  }

  String createEntityKey(data) {
    if (data['type'] != null && data['id'] != null) {
      return '${data['type']}-${data['id']}';
    }
    return '';
  }

  void setJsonParsedObject(Map<String, dynamic> body) {
    this.body = body;
  }

  dynamic build() {
    var data = body['data'];
    var stuff;

    if (data is List) {
      stuff = [];
      var collectionLength = data.length;

      for (var i = 0; i < collectionLength; i++) {
        if (data[i] != null) {
          var model = buildModelByData(data[i]);

          if (model != null) {
            stuff.add(model);
          }
        }
      }
    } else if (data != null) {
      stuff = buildModelByData(data);
    }

    return stuff;
  }

  Map<String, dynamic> buildModelByData(Map<String, Object> data) {
    var entityKey = createEntityKey(data);

    var model = propertiesMapper.createModel(data['type']);

    if (model != null) {
      if (entityKey != null) {
        cachedModels[entityKey] = model;
      }
      propertiesMapper.setId(model, data['id']);

      if (data['attributes'] != null) {
        propertiesMapper.setAttributes(model, data['attributes']);
      }

      if (data['meta'] != null) {
        propertiesMapper.setMeta(model, data['meta']);
      }

      if (data['links'] != null) {
        propertiesMapper.setLinks(model, data['links']);
      }

      var relationships = buildRelationsByData(data, model);

      if (relationships != null) {
        propertiesMapper.setRelationships(model, relationships);
      }
    }

    return model;
  }

  Map<String, dynamic> buildRelationsByData(Map<String, dynamic> data, Map<String, dynamic> model) {
    Map<String, dynamic> readyRelations = {};

    if (data['relationships'] != null) {
      if (data['relationships'] is Map) {
        data['relationships'].keys.forEach((k) {
          Map<String, dynamic> relation = data['relationships'][k];

          if (relation['data'] is Iterable) {
            readyRelations[k] = [];

            int relationItemsLength = relation['data'].length;
            var relationItem;

            for (int i = 0; i < relationItemsLength; i++) {
              relationItem = relation['data'][i];

              if (relationItem == null) {
                return null;
              }

              var dataItem = buildDataFromIncludedOrData(relationItem['id'], relationItem['type']);
              readyRelations[k].add(buildModelByData(dataItem));
            }
          } else if (relation['data'] != null) {
            var dataItem = buildDataFromIncludedOrData(relation['data']['id'], relation['data']['type']);
            readyRelations[k] = buildModelByData(dataItem);
          } else if (relation['data'] == null) {
            readyRelations[k] = null;
          }

          if (relation['links'] != null) {
            propertiesMapper.setRelationshipLinks(model, k, relation['links']);
          }

          if (relation['meta'] != null) {
            propertiesMapper.setRelationshipMeta(model, k, relation['meta']);
          }
        });
      }
    }

    if (readyRelations.keys.length > 0) {
      return readyRelations;
    }

    return null;
  }

  Map<String, Object> buildDataFromIncludedOrData(String id, String type) {
    Map<String, Object> included = buildIncludedInObject();
    var dataItem = included[type + id];

    if (dataItem != null) {
      return dataItem;
    } else {
      return {'id': id, 'type': type};
    }
  }

  Map<String, Object> buildIncludedInObject() {
    if (includedInObject == null) {
      includedInObject = {};

      if (body['included'] != null) {
        int includedLength = body['included'].length;

        for (int i = 0; i < includedLength; i++) {
          var item = body['included'][i];
          var key = item['type'] + item['id'];
          includedInObject[key] = item;
        }
      }
    }

    return includedInObject;
  }
}
