import 'package:dart_jsona/src/models/jsona_types.dart';
import 'package:dart_jsona/src/builders/json_deserializer.dart';
import 'package:dart_jsona/src/builders/property_mapper.dart';

class Jsona {
  AbsModelPropertiesMapper modelPropertiesMapper;
  JsonPropertiesMapper jsonPropertiesMapper = new JsonPropertiesMapper();

//  Map<String, Object> serialize(Map<String, Object> stuff, [List<String> includeNames]){
//    if (stuff == null) {
//      throw 'Jsona can not serialize, stuff is not passed';
//    }
//  }

  dynamic deserialize(Map<String, Object> body) {
    if(body == null) {
      throw 'Json can not deserialize, body is not passed';
    }

    JsonDeserializer modelBuilder = new JsonDeserializer(jsonPropertiesMapper);
    modelBuilder.setJsonParsedObject(body);

    return modelBuilder.build();
  }
}