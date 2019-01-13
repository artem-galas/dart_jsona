import 'package:dart_jsona/src/models/jsona_types.dart';
import 'package:dart_jsona/src/builders/util.dart';

class ModelSerializer implements JsonaModelBuilder {
  AbsModelPropertiesMapper propertiesMapper;
  Map<String, Object> stuff;
  Map<String, Object> includeNamesTree = {};

  ModelSerializer([AbsModelPropertiesMapper propertiesMapper]) {
    setPropertiesMapper(propertiesMapper);
  }

  void setPropertiesMapper(AbsModelPropertiesMapper setPropertiesMapper) {
    propertiesMapper = setPropertiesMapper;
  }

  void setStuff(Map<String, Object> stuff) {
    this.stuff = stuff;
  }

  void setIncludedNames(List<String> includeNames) {
    Map<String, Object> includeNamesTree = {};
    includeNames.forEach((nameChain) {
      createIncludeNamesTree(nameChain, includeNamesTree);
    });

    this.includeNamesTree = includeNamesTree;
  }

  @override
  Map<String, dynamic> build() {
    if (propertiesMapper == null) {
      throw ArgumentError(
        'ModelsSerializer cannot build, propertiesMapper is not set');
    } else if (stuff == null) {
      throw ArgumentError('ModelsSerializer cannot build, stuff is not set');
    }

    Map<String, dynamic> body = {};
    Map<String, Object> uniqueIncluded = {};

    if (stuff != null && stuff is Iterable) {
      int collectionLength = stuff.length;
      List<Object> data = [];

      for (int i = 0; i < collectionLength; i++) {
        data.add(buildDataByModel(stuff[i]));

        buildIncludedByModel(stuff[i], includeNamesTree, uniqueIncluded);
      }
      body['data'] = data;
    } else if (stuff != null) {
      body['data'] = buildDataByModel(stuff);
      buildIncludedByModel(stuff, includeNamesTree, uniqueIncluded);
    } else if (stuff == null) {
      body['data'] = null;
    }

    if (uniqueIncluded.keys.length > 0) {
      body['included'] = [];
      List<String> includeUniqueKeys = uniqueIncluded.keys.toList();

      includeUniqueKeys.forEach((key) {
        body['included'].add(uniqueIncluded[key]);
      });
    }

    return body;
  }

  Map<String, Object> buildDataByModel(Map<String, Object> model) {
    Map<String, Object> data = {
      'id': propertiesMapper.getId(model),
      'type': propertiesMapper.getType(model),
      'attributes': propertiesMapper.getAttributes(model)
    };

    if (data['type'] == null) {
      throw 'ModelsSerializer cannot buildDataByModel, type is not set or incorrect';
    }

    var relationships = buildRelationshipsByModel(model);

    if (relationships != null) {
      data['relationships'] = relationships;
    }

    return data;
  }

  dynamic buildRelationshipsByModel(Map<String, dynamic> model) {
    var relations = propertiesMapper.getRelationShips(model);

    if (relations == null) {
      return null;
    }

    var relationships = {};

    relations.keys.forEach((key) {
      dynamic relation = relations[key];

      if (relation is List) {
        List<dynamic> relationshipData = [];
        int relationLength = relation.length;

        for (int i = 0; i < relationLength; i++) {
          Map<String, Object> item = {
            'id': propertiesMapper.getId(relation[i]),
            'type': propertiesMapper.getType(relation[i])
          };

          if (item['id'] != null && item['type'] != null) {
            relationshipData.add(item);
          }
        }

        relationships[key] = {'data': relationshipData};
      } else if (relation != null) {
        Map<String, Object> item = {
          'id': propertiesMapper.getId(relation),
          'type': propertiesMapper.getType(relation)
        };

        if (item['type'] != null) {
          relationships[key] = {'data': item};
        } else {
          print(
            "Can't create data for relationship $key, it doesn't have 'type', it was skipped");
        }
      } else {
        relationships[key] = {'data': relation};
      }
    });

    return relationships;
  }

  void buildIncludedByModel(Map<String, Object> model,
    Map<String, dynamic> includeTree, Map<String, Object> builtIncluded) {
    if (includeTree == null) {
      return;
    }

    var modelRelationships = propertiesMapper.getRelationShips(model);

    if (modelRelationships == null) {
      return;
    }

    var includeNames = includeTree.keys.toList();
    var includeNamesLength = includeNames.length;

    for (int i = 0; i < includeNamesLength; i++) {
      String currentRelationName = includeNames[i];
      var relation = modelRelationships[currentRelationName];

      if (relation != null) {
        if (relation is List) {
          var relationModelsLength = relation.length;

          for (int r = 0; r < relationModelsLength; r++) {
            var relationModel = relation[r];
            buildIncludedItem(
              relationModel, includeTree[currentRelationName], builtIncluded);
          }
        } else {
          buildIncludedItem(
            relation, includeTree[currentRelationName], builtIncluded);
        }
      }
    }
  }

  void buildIncludedItem(
    Map<String, dynamic> relationModel, subIncludeTree, builtIncluded) {
    var includeKey = propertiesMapper.getType(relationModel) +
      propertiesMapper.getId(relationModel);

    if (builtIncluded[includeKey] == null) {
      builtIncluded[includeKey] = buildDataByModel(relationModel);

      if (subIncludeTree != null) {
        buildIncludedByModel(relationModel, subIncludeTree, builtIncluded);
      }
    }
  }
}
