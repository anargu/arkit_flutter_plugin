import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;

class CustomObjectPage3 extends StatefulWidget {
  @override
  _CustomObjectPageState3 createState() => _CustomObjectPageState3();
}

class _CustomObjectPageState3 extends State<CustomObjectPage3> {
  ARKitController arkitController;
  ARKitReferenceNode node;
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
            planeDetection: ARPlaneDetection.horizontal,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    if (node != null) {
      controller.remove(node.name);
    }
    node = ARKitReferenceNode(
      url: 'models.scnassets/Stormtrooper.dae',
      position: vector.Vector3(0, 0, 0),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
      scale: vector.Vector3(0.02, 0.02, 0.02),
    );
    controller.add(node, parentNodeName: anchor.nodeName);
  }
}
