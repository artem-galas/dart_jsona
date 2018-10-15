import 'package:dart_jsona/src/models/jsona_types.dart';

final RELATIONSHIP_NAMES_PROP = 'relationshipNames';

class ModelPropertiesMapper implements AbsModelPropertiesMapper {
  @override
  String getId(Map<String, dynamic> model) {
    return model['id'];
  }

  @override
  String getType(Map<String, dynamic> model) {
    return model['type'];
  }

  @override
  dynamic getRelationShips(Map<String, dynamic> model) {
    List<String> relationshipNames = model[RELATIONSHIP_NAMES_PROP];

    if (relationshipNames == null) {
      return;
    }

    Map<String, dynamic> relationships = {};
    relationshipNames.forEach((relationName) {
      if (model[relationName] != null) {
        relationships[relationName] = model[relationName];
      }
    });

    return relationships;
  }

  @override
  dynamic getAttributes(Map<String, dynamic> model) {
    List<String> exceptProps = ['id', 'type', RELATIONSHIP_NAMES_PROP];

    if (model[RELATIONSHIP_NAMES_PROP] is List) {
      exceptProps.addAll(model[RELATIONSHIP_NAMES_PROP]);
    } else if (model[RELATIONSHIP_NAMES_PROP] != null) {
      print("Can't getAttributes correctly, ${RELATIONSHIP_NAMES_PROP} property of ${model['type']}-${model['id']} modelisn't array of relationship names");
    }

    var attributes = {};
    model.keys.forEach((attrName) {
      if (exceptProps.indexOf(attrName) == -1) {
        attributes[attrName] = model[attrName];
      }
    });

    return attributes;
  }

}

class JsonPropertiesMapper implements AbsJsonPropertiesMapper {
  @override
  Map<String, dynamic> createModel(String type) {
    return {
      'type': type
    };
  }

  @override
  setId(Map<String, dynamic> model, String id) {
    model['id'] = id;
  }

  @override
  void setAttributes(Map<String, dynamic> model, Map<String, dynamic> attributes) {
    attributes.keys.forEach((propName) => model[propName] = attributes[propName]);
  }

  @override
  void setMeta(Map<String, dynamic> model, Map<String, dynamic>  meta) {
    model['meta'] = meta;
  }

  @override
  void setLinks(Map<String, dynamic>  model, JsonApiLinks links) {
    model['links'] = links;
  }

  @override
  void setRelationshipLinks(Map<String, dynamic> parentModel, String relationName, JsonApiLinks links) {
    // TODO: implement setRelationshipLinks
  }

  @override
  void setRelationshipMeta(Map<String, dynamic> parentModel, String relationName, Map<String, dynamic> meta) {
    // TODO: implement setRelationshipMeta
  }

  @override
  void setRelationships(Map<String, dynamic> model, Map<String, dynamic > relationships) {
    relationships.keys.forEach((propName) {
      model[propName] = relationships[propName];
    });

    List<String> newNames = relationships.keys.toList();

    model[RELATIONSHIP_NAMES_PROP] = newNames;
  }

}