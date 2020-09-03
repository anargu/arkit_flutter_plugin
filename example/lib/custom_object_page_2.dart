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
    _addUiView(arkitController, anchor);
  }

  void _addUiView(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    if (node != null) {
      controller.remove(node.name);
    }
    node = ARKitReferencePostNode(
        url: 'models.scnassets/eevee.dae',
        position: vector.Vector3(0, 0, 0),
        scale: vector.Vector3(0.2, 0.2, 0.2),
        description: 'hello',
        username: 'joe',
        raw: 'world',
        likes: 3);
    controller.addUIView(node, parentNodeName: anchor.nodeName);
  }
}
