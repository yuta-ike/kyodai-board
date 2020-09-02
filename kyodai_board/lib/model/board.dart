import 'package:flutter/material.dart';
import 'package:kyodai_board/utils/dynamic_cast_map.dart';

class Board{
  const Board({
    @required this.id,
    @required this.title,
    @required this.message,
    @required this.imageUrl,
    @required this.hostName, // 暫定
  });

  Board.fromMap(Map<String, dynamic> map)
    : id = map.getString('id') ?? ''
    , title = map.getString('title') ?? ''
    , message = map.getString('message') ?? ''
    , imageUrl = map.getString('imageUrl') ?? ''
    , hostName = map.getString('hostName') ?? '';
  
  final String id;
  final String title;
  final String message;
  final String imageUrl;
  final String hostName;
}