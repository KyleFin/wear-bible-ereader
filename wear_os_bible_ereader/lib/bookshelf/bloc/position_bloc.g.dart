// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionState _$PositionStateFromJson(Map<String, dynamic> json) =>
    PositionState(
      json['bookTitle'] as String?,
      json['scriptureBookIndex'] as int?,
      json['chapterIndex'] as int?,
      json['epubCfi'] as String?,
      latestBookFilename: json['latestBookFilename'] as String,
      loadingDocument: json['loadingDocument'] as bool,
    );

Map<String, dynamic> _$PositionStateToJson(PositionState instance) =>
    <String, dynamic>{
      'latestBookFilename': instance.latestBookFilename,
      'bookTitle': instance.bookTitle,
      'scriptureBookIndex': instance.scriptureBookIndex,
      'chapterIndex': instance.chapterIndex,
      'epubCfi': instance.epubCfi,
      'loadingDocument': instance.loadingDocument,
    };
