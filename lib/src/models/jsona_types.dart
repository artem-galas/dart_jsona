abstract class AbsModelPropertiesMapper {
  String getId(Map<String, dynamic> model);
  String getType(Map<String, dynamic> model);
  dynamic getAttributes(Map<String, dynamic> model);
  dynamic getRelationShips(Map<String, dynamic> model);
}

abstract class AbsJsonPropertiesMapper {
  Map<String, Object> createModel(String type);
  void setId(Map<String, Object> model, String id);
  void setAttributes(Map<String, Object> model, Map<String, Object> attributes);
  void setMeta(Map<String, Object> model, Map<String, Object>  meta);
  void setLinks(Map<String, Object>  model, Map<String, String> links);
  void setRelationships(Map<String, Object> model, Map<String, Object> relationships);
  void setRelationshipLinks(Map<String, Object> parentModel, String relationName, Map<String, String> links);
  void setRelationshipMeta(Map<String, Object> parentModel, String relationName, Map<String, Object> meta);
}

abstract class JsonaModelBuilder {
  Map<String, dynamic> build();
}

abstract class JsonApiLinks {
  String self;
  String related;
}

abstract class JsonApiBody {
  JsonApiData data;
  List<JsonApiData> included;
}

abstract class JsonApiData {
  String type;
  String id;
  Map<String, Object> attributes;
  Map<String, Object> meta;
  JsonApiLinks links;
}

abstract class JsonApiRelationshipData {
  String type;
  String id;
}

abstract class JsonApiRelation {
  JsonApiRelationshipData data;
  JsonApiLinks link;
  Map<String, Object> meta;
}
