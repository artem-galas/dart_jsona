// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(json['name'] as String, json['age'] as int);
}

Map<String, dynamic> _$PersonToJson(Person instance) =>
    <String, dynamic>{'name': instance.name, 'age': instance.age};
