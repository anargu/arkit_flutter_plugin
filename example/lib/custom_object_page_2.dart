import 'dart:math';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CustomObjectPage2 extends StatefulWidget {
  @override
  _CustomObjectPage2State createState() => _CustomObjectPage2State();
}

class _CustomObjectPage2State extends State<CustomObjectPage2> {
  ARKitController arkitController;
  ARKitReferencePostNode node;
  String anchorId;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Custom object on plane Sample')),
        body: Container(
          child: ARKitSceneView(
            showFeaturePoints: true,
            showWorldOrigin: true,
            planeDetection: ARPlaneDetection.horizontal,
            onARKitViewCreated: onARKitViewCreated,
            enableTapRecognizer: true,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    // this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    node = ARKitReferencePostNode(
        position: vector.Vector3(0, 0.1, -4),
        scale: vector.Vector3(1, 1, 1),
        description: 'hello',
        username: 'joe',
        raw: 'https://media.giphy.com/media/frNEzcyLLtuOwEtwzo/giphy.gif',
        type: 'IMAGE',
        likes: 4,
        views: 0);

    final node2 = ARKitReferencePostNode(
        position: vector.Vector3(2, 0, -2),
        scale: vector.Vector3(1, 1, 1),
        description: 'hello',
        username: 'joe',
        raw: 'Hello',
        type: 'TEXT',
        likes: 4,
        views: 0);
    final node3 = ARKitReferencePostNode(
        position: vector.Vector3(1, 0, -2),
        scale: vector.Vector3(1, 1, 1),
        description: 'hello',
        username: 'joe',
        raw: 'https://media.giphy.com/media/xT5LMJmXRmrn3ft04w/giphy.gif',
        type: 'IMAGE',
        likes: 4,
        views: 0);
    final node4 = ARKitReferencePostNode(
        position: vector.Vector3(3, 0, -2),
        scale: vector.Vector3(1, 1, 1),
        description: 'hello',
        username: 'joe',
        raw: 'GOOD BYE',
        type: 'TEXT',
        likes: 4,
        views: 0);
    this.arkitController.addUIView(node);
    this.arkitController.addUIView(node2);
    this.arkitController.addUIView(node3);
    this.arkitController.addUIView(node4);

    this.arkitController.onNodeTap = (nodes) {
      print('nodes ${nodes.toString()}');
    };
  }

  // void _handleAddAnchor(ARKitAnchor anchor) {
  //   if (!(anchor is ARKitPlaneAnchor)) {
  //     return;
  //   }
  //   _addUiView(arkitController, anchor);
  // }

  // void _addUiView(ARKitController controller, ARKitPlaneAnchor anchor) {
  //   anchorId = anchor.identifier;
  //   if (node != null) {
  //     controller.remove(node.name);
  //   }
  //   node = ARKitReferencePostNode(
  //       url: 'models.scnassets/eevee.dae',
  //       position: vector.Vector3(0, 0, 0),
  //       scale: vector.Vector3(1, 1, 1),
  //       description: 'hello',
  //       username: 'joe',
  //       raw: 'world',
  //       type: 'TEXT',
  //       likes: 3);
  //   controller.addUIView(node, parentNodeName: anchor.nodeName);
  // }
}
