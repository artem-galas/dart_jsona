import 'package:dart_jsona/src/models/jsona_types.dart';

final RELATIONSHIP_NAMES_PROP = 'relationshipNames';

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