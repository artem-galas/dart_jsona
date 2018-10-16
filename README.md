# dart_jsona

It's a ported to dart - [Jsona TS](https://github.com/olosegres/jsona)

Framework agnostic, customizable library that provide data formatters to simplify work with JSON API v1.0 specification.

This package don't have any dependencies and pretty simple. It used `Map<String, dynamic>` a lot 😑

It was designed to work with [json_serializable](https://pub.dartlang.org/packages/json_serializable)

## Usage

### Deserializer - creates simplified object(s) from json

```
import 'package:dart_jsona/dart_jsona.dart';

main() {
  Jsona jsona = new Jsona();

  final body = {
    'data': {
      'type': 'town',
      'id': '123',
      'attributes': {
        'name': 'Barcelona',
      },
      'relationships': {
        'country': {
          'data': {
            'type': 'country',
            'id': '32',
          }
        }
      }
    },
    'included': [{
      'type': 'country',
      'id': '32',
      'attributes': {
        'name': 'Spain',
      }
    }]
  };

  final town = jsona.deserialize(body);

  print(town);
  /**
   * {
   *   type: town,
   *   id: 123,
   *   name: Barcelona,
   *   country: {
   *     type: country,
   *     id: 32, name: Spain
   *   },
   *   relationshipNames: [country]
   * }
   */
}
```

### Serializer - creates json from simplified object(s)
```
import 'package:dart_jsona/dart_jsona.dart';
main() {
    Jsona jsona = new Jsona();

    Map<String dynamic> newJson = jsona.serialize(stuff: town, includedNames: ['country']);

    print(newJson);

    /**
    * {
    *   data: {
    *     id: 123,
    *     type: town,
    *     attributes: {
    *       name: Barcelona
    *     },
    *     relationships: {
    *       country: {
    *         data: {
    *           id: 32, type: country
    *         }
    *       }
    *     }
    *   },
    *   included: [{
    *     id: 32,
    *     type: country,
    *     attributes: {
    *       name: Spain
    *     }
    *   }]
    * }
    */
}
```

### Deserialize example from https://jsonapi.org/

```
var jsonApi = {
  "links": {
    "self": "http://example.com/articles",
    "next": "http://example.com/articles?page[offset]=2",
    "last": "http://example.com/articles?page[offset]=10"
  },
  "data": [{
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON API paints my bikeshed!"
    },
    "relationships": {
      "author": {
        "links": {
          "self": "http://example.com/articles/1/relationships/author",
          "related": "http://example.com/articles/1/author"
        },
        "data": { "type": "people", "id": "9" }
      },
      "comments": {
        "links": {
          "self": "http://example.com/articles/1/relationships/comments",
          "related": "http://example.com/articles/1/comments"
        },
        "data": [
          { "type": "comments", "id": "5" },
          { "type": "comments", "id": "12" }
        ]
      }
    },
    "links": {
      "self": "http://example.com/articles/1"
    }
  }],
  "included": [{
    "type": "people",
    "id": "9",
    "attributes": {
      "firstName": "Dan",
      "lastName": "Gebhardt",
      "twitter": "dgeb"
    },
    "links": {
      "self": "http://example.com/people/9"
    }
  }, {
    "type": "comments",
    "id": "5",
    "attributes": {
      "body": "First!"
    },
    "relationships": {
      "author": {
        "data": { "type": "people", "id": "2" }
      }
    },
    "links": {
      "self": "http://example.com/comments/5"
    }
  }, {
    "type": "comments",
    "id": "12",
    "attributes": {
      "body": "I like XML better"
    },
    "relationships": {
      "author": {
        "data": { "type": "people", "id": "9" }
      }
    },
    "links": {
      "self": "http://example.com/comments/12"
    }
  }]
};

var jsonApiModel = jsona.deserialize(jsonApi);

print(jsonApiModel);

/**
  [
    {
      type: 'articles',
      id: 1,
      title: 'JSON API paints my bikeshed!',
      links: {
        self: 'http://example.com/articles/1'
      },
      author: {
        type: 'people',
        id: 9,
        firstName: 'Dan',
        lastName: 'Gebhardt',
        twitter: 'dgeb',
        links: {
          self: 'http://example.com/people/9'
        }
      },
      comments: [{
        type: 'comments',
        id: 5,
        body: 'First!',
        links: {
          self: 'http://example.com/comments/5'
        },
        author: {
          type: 'people',
          id: 2
        },
        relationshipNames: [author]
      },
      {
        type: 'comments',
        id: 12,
        body: 'I like XML better',
        links: {
          self: 'http://example.com/comments/12'
        },
        author: {
          type: 'people',
          id: 9,
          firstName: 'Dan',
          lastName: 'Gebhardt',
          twitter: 'dgeb',
          links: {
            self: 'http://example.com/people/9'
          }
        },
        relationshipNames: [author]
      }],
      relationshipNames: [author, comments]
    }
  ];
**/
```

### Deserialize in angular service

```
// post_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:dart_jsona/dart_jsona.dart';

class PostService {

  static final _postUrl = 'api/posts';
  final Client _http;

  PostService(this._http);

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _http.get('${apiUrl}/${_postUrl}');

      // create a new post from json
      final posts = (_extractData(response) as List)
          .map((value) => PostModel.fromJson(value))
          .toList();
      return posts;
    } catch(e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) {
    // initialze Jsona
    Jsona jsona = new Jsona();

    // convert to `Map<String, dynamic>` from `String`
    var response = json.decode(resp.body)

    // deserialize response body
    return jsona.deserialize(response);
  }

  Exception _handleError(dynamic e) {
    return Exception('Server error; cause: $e');
  }
}
```

```
// post_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String body;
  final String image;
  PostModel(this.body, this.image);

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
```

## Contributing

Contributing are welcome.

This package on an early stage, and I'll be happy if you fix or create a new feature.

You just need follow these steps:
- Fork the repo
- Make new branch
- Write code magic
- Write tests
- Create PR

## License
Jsona, examples provided in this repository and in the documentation are [MIT licensed](./LICENSE).
