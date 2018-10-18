import 'package:dart_jsona/src/builders/property_mapper.dart' show RELATIONSHIP_NAMES_PROP;

final Map<String, dynamic> country1 = {
  'model': {
    'type': 'country',
    'id': '34',
    'name': 'Spain'
  },
  'json': {
    'type': 'country',
    'id': '34',
    'attributes': {
      'name': 'Spain'
    }
  }
};

final Map<String, dynamic> country2 = {
  'model': {
    'type': 'country',
    'id': '25',
    'name': 'China'
  },
  'json': {
    'type': 'country',
    'id': '25',
    'attributes': {
      'name': 'China'
    }
  }
};

final Map<String, dynamic> town1 = {
  'model': {
    'type': 'town',
    'id': '21',
    'name': 'Shanghai',
    'country': country1['model'],
    RELATIONSHIP_NAMES_PROP: ['country']
  },
  'json': {
    'type': 'town',
    'id': '21',
    'attributes': {
      'name': 'Shanghai',
    },
    'relationships': {
      'country': {
        'data': {
          'type': 'country',
          'id': country1['model']['id'],
        }
      }
    }
  }
};


final Map<String, dynamic> town2 = {
  'model': {
    'type': 'town',
    'id': '80',
    'name': 'Barcelona',
    'country': country2['model'],
    RELATIONSHIP_NAMES_PROP: ['country']
  },
  'json': {
    'type': 'town',
    'id': '80',
    'attributes': {
      'name': 'Barcelona',
    },
    'relationships': {
      'country': {
        'data': {
          'type': 'country',
          'id': country2['model']['id'],
        }
      }
    }
  }
};

final Map<String, dynamic> specialty1 = {
  'model': {
    'type': 'specialty',
    'id': '1',
    'title': 'mycategory1'
  },
  'json': {
    'type': 'specialty',
    'id': '1',
    'attributes': {
      'title': 'mycategory1'
    }
  }
};


final Map<String, dynamic> specialty2 = {
  'model': {
    'type': 'specialty',
    'id': '2',
    'title': 'mycategory2'
  },
  'json': {
    'type': 'specialty',
    'id': '2',
    'attributes': {
      'title': 'mycategory2'
    }
  }
};

final Map<String, dynamic> user1 = {
  'model': {
    'type': 'user',
    'id': '1',
    'name': 'myName1',
    'active': false,
    'town': town1['model'],
    'specialty': [specialty1['model']],
    RELATIONSHIP_NAMES_PROP: ['town', 'specialty']
  },
  'json': {
    'type': 'user',
    'id': '1',
    'attributes': {
      'name': 'myName1',
      'active': false,
    },
    'relationships': {
      'town': {
        'data': {
          'type': 'town',
          'id': town1['model']['id'],
        }
      },
      'specialty': {
        'data': [{
          'type': 'specialty',
          'id': specialty1['model']['id']
        }]
      }
    }
  },
  'included': {
    'townOnly': [
      town1['json']
    ]
  }
};

final Map<String, dynamic> user2 = {
  'model': {
    'type': 'user',
    'id': '2',
    'name': 'myName2',
    'active': true,
    'town': town2['model'],
    'specialty': [specialty1['model'], specialty2['model']],
    RELATIONSHIP_NAMES_PROP: ['town', 'specialty']
  },
  'modelWithoutIncluded': {
    'type': 'user',
    'id': '2',
    'name': 'myName2',
    'active': true,
    'town': {
      'id': town2['model']['id'],
      'type': town2['model']['type'],
    },
    'specialty': [{
      'id': specialty1['model']['id'],
      'type': specialty1['model']['type'],
    }, {
      'id': specialty2['model']['id'],
      'type': specialty2['model']['type'],
    }],
    RELATIONSHIP_NAMES_PROP: ['town', 'specialty']
  },
  'json': {
    'type': 'user',
    'id': '2',
    'attributes': {
      'name': 'myName2',
      'active': true,
    },
    'relationships': {
      'town': {
        'data': {
          'type': 'town',
          'id': town2['model']['id'],
        }
      },
      'specialty': {
        'data': [{
          'type': 'specialty',
          'id': specialty1['model']['id']
        }, {
          'type': 'specialty',
          'id': specialty2['model']['id']
        }]
      }
    }
  },
  'includeNames': {
    'townOnly': ['town']
  },
  'included': {
    'townOnly': [
      town2['json']
    ]
  }
};

final article1 = {
  'model': {
    'type': 'article',
    'id': 1,
    'likes': 5550,
    'author': user1['model'],
    'country': country1['model'],
    RELATIONSHIP_NAMES_PROP: ['author', 'country']
  },
  'json': {
    'type': 'article',
    'id': 1,
    'attributes': {
      'likes': 5550
    },
    'relationships': {
      'author': {
        'data': {
          'type': 'user',
          'id': user1['model']['id']
        }
      },
      'country': {
        'data': {
          'type': 'country',
          'id': country1['model']['id']
        }
      }
    }
  }
};

final article2 = {
  'model': {
    'type': 'article',
    'id': 2,
    'likes': 100,
    'author': user2['model'],
    'country': country2['model'],
    RELATIONSHIP_NAMES_PROP: ['author', 'country']
  },
  'json': {
    'type': 'article',
    'id': 2,
    'attributes': {
      'likes': 100
    },
    'relationships': {
      'author': {
        'data': {
          'type': 'user',
          'id': user2['model']['id'],
        }
      },
      'country': {
        'data': {
          'type': 'country',
          'id': country2['model']['id'],
        }
      }
    }
  },
  'includeNames': [
    'author.town.contry',
    'author.specialty',
    'country'
  ],
};

final articleWithoutAuthor = {
  'model': {
    'type': 'article',
    'id': 3,
    'likes': 0,
    'author': null,
    RELATIONSHIP_NAMES_PROP: ['author']
  },
  'json': {
    'type': 'article',
    'id': 3,
    'attributes': {
      'likes': 0,
    },
    'relationships': {
      'author': {
        'data': null,
      },
    },
  },
  'includeNames': [
    'author'
  ],
};


final jsonApiExample = {
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

final jsonApiModel = [
  {
    'type': 'articles',
    'id': 1,
    'title': 'JSON API paints my bikeshed!',
    'links': {
      'self': 'http://example.com/articles/1'
    },
    'author': {
      'type': 'people',
      'id': 9,
      'firstName': 'Dan',
      'lastName': 'Gebhardt',
      'twitter': 'dgeb',
      'links': {
        'self': 'http://example.com/people/9'
      }
    },
    'comments': [{
      'type': 'comments',
      'id': 5,
      'body': 'First!',
      'links': {
        'self': 'http://example.com/comments/5'
      },
      'author': {
        'type': 'people',
        'id': 2
      },
      'relationshipNames': ['author']
    },
    {
      'type': 'comments',
      'id': 12,
      'body': 'I like XML better',
      'links': {
        'self': 'http://example.com/comments/12'
      },
      'author': {
        'type': 'people',
        'id': 9,
        'firstName': 'Dan',
        'lastName': 'Gebhardt',
        'twitter': 'dgeb',
        'links': {
          'self': 'http://example.com/people/9'
        }
      },
      'relationshipNames': ['author']
    }],
    'relationshipNames': ['author', 'comments']
  }
];
