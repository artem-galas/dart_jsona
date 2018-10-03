//import 'package:dart_jsona/src/models/jsona_types.dart';
//
//
//class ModelSerializer {
//  AbsModelPropertiesMapper  propertiesMapper;
//  Map<String, Object> stuff;
//  Map<String, Object> includeNamesTree;
//
//  ModelPropertiesMapper([AbsModelPropertiesMapper propertiesMapper]) {
//    this.setPropertiesMapper(propertiesMapper);
//  }
//
//  setPropertiesMapper(AbsModelPropertiesMapper setPropertiesMapper) {
//    this.propertiesMapper = propertiesMapper;
//  }
//
//  setStuff(Map<String, Object> stuff) {
//    this.stuff = stuff;
//  }
//
//  setIncludedNames(List<String> includeNames) {}
//
//  Map<String, Object> build() {
//    if (propertiesMapper == null) {
//      throw 'ModelsSerializer cannot build, propertiesMapper is not set';
//    } else if (stuff == null) {
//      throw 'ModelsSerializer cannot build, stuff is not set';
//    }
//
//    Map<String, dynamic> body = {};
//    Map<String, Object> uniqueIncluded = {};
//
//    if (stuff != null && stuff.runtimeType == Iterable) {
//      int collectionLength = stuff.length;
//      List<Object> data = [];
//
//      for(int i = 0; i < collectionLength; i ++) {
//        data.add(buildDataByModel(stuff[i]));
//
//        buildIncludedByModel(
//            stuff[i],
//            this.includeNamesTree,
//            uniqueIncluded
//        );
//      }
//
//      body['data'] = data;
//    } else if (stuff != null) {
//      body['data'] = buildDataByModel(stuff);
//      this.buildIncludedByModel(
//          stuff,
//          this.includeNamesTree,
//          uniqueIncluded
//      );
//    } else if (stuff == null) {
//      body['data'] = null;
//    }
//
//    if(uniqueIncluded.keys.length > 0) {
//      body['included'] = [];
//      List<String> includeUniqueKeys = uniqueIncluded.keys;
//
//      includeUniqueKeys.forEach((key) {
//        body['included'].add(uniqueIncluded[key]);
//      });
//    }
//
//    return body;
//  }
//
//  Map<String, Object> buildDataByModel(Map<String, Object> model) {
//    Map<String, Object> data = {
//      'id': propertiesMapper.getId(model),
//      'type': propertiesMapper.getType(model),
//      'attributes': propertiesMapper.getAttributes(model)
//    };
//
//    if (data['type'] == null) {
//      throw 'ModelsSerializer cannot buildDataByModel, type is not set or incorrect';
//    }
//
//    var relationships = this.buildRelationshipsByModel(model);
//
//    if (relationships != null) {
//      data['relationships'] = relationships;
//    }
//
//    return data;
//  }
//
//  Map<String, Object> buildRelationshipsByModel(Map<String, dynamic> model) {
//    var relations = propertiesMapper.getRelationShips(model);
//
//    if(relations == null) {
//      return;
//    }
//
//    var relationships = {};
//
//    relations.keys.forEach((key) {
//      dynamic relation = relations[key];
//
//      if(relation.runtimeType == Iterable) {
//        List<dynamic> relationshipData = [];
//        int relationLength = relation.length;
//
//        for(int i = 0; i < relationLength; i ++) {
//          Map<String,Object> item = {
//            'id': propertiesMapper.getId(relation[i]),
//            'type': propertiesMapper.getType(relation[i])
//          };
//
//          if (item['id'] != null && item['type'] != null) {
//            relationshipData.add(item);
//          }
//        }
//
//        relationships[key] = {
//          'data': relationshipData
//        };
//      } else if (relation != null) {
//        Map<String,Object> item = {
//          'id': propertiesMapper.getId(relation[i]),
//          'type': propertiesMapper.getType(relation[i])
//        };
//
//        if(item['type'] != null) {
//          relationships[key] = {
//            'data': item
//          };
//        } else {
//          print("Can't create data for relationship $k, it doesn't have 'type', it was skipped")
//        }
//      } else {
//        relationships[key] = {
//          'data': relation
//        };
//      }
//    });
//
//    return relationships;
//  }
//}
