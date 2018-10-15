## 0.0.1
- Create Deserializer and Simple Serializer
```
Jsona jsona = new Jsona();
final town = jsona.deserialize(body);

final newJson = jsona.serialize(stuff: town, includedNames: ['country']);
```
