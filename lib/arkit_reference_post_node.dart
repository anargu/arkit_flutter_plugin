import 'package:arkit_plugin/arkit_node.dart';
import 'package:arkit_plugin/light/arkit_light.dart';
import 'package:arkit_plugin/physics/arkit_physics_body.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

///  Node that references an external serialized node graph.
class ARKitReferencePostNode extends ARKitNode {
  ARKitReferencePostNode({
    ARKitPhysicsBody physicsBody,
    ARKitLight light,
    Vector3 position,
    Vector4 rotation,
    Vector3 scale,
    Vector3 eulerAngles,
    String name,
    int renderingOrder,
    bool isHidden,
    @required this.avatar,
    @required this.raw,
    @required this.description,
    @required this.username,
    @required this.type,
    this.likes = 0,
    this.views = 0,
  }) : super(
          physicsBody: physicsBody,
          light: light,
          position: position,
          rotation: rotation,
          scale: scale,
          eulerAngles: eulerAngles,
          name: name,
          renderingOrder: renderingOrder,
          isHidden: isHidden,
        );

  /// URL location of the Node
  /// Defaults to path from Main Bundle
  /// If path from main bundle fails, will search as full file path
  final String raw;
  final String description;
  final String username;
  final String avatar;
  final String type;
  final int likes;
  final int views;

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'raw': raw,
        'description': description,
        'username': username,
        'avatar': avatar,
        'type': type,
        'likes': likes,
        'views': views,
      }..addAll(super.toMap());
}
