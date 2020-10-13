import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PlaneDetectionPage extends StatefulWidget {
  @override
  _PlaneDetectionPageState createState() => _PlaneDetectionPageState();
}

class _PlaneDetectionPageState extends State<PlaneDetectionPage> {
  ARKitController arkitController;
  ARKitPlane plane;
  ARKitNode node;
  ARKitPlane innerPlane;
  ARKitReferencePostNode innerNode;
  String anchorId;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Plane Detection Sample')),
        body: Container(
          child: ARKitSceneView(
            showFeaturePoints: true,
            planeDetection: ARPlaneDetection.horizontalAndVertical,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor.identifier != anchorId) {
      return;
    }
    final ARKitPlaneAnchor planeAnchor = anchor;
    node.position =
        vector.Vector3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;

    innerNode.position =
        vector.Vector3(planeAnchor.center.x, -0.1, planeAnchor.center.z);
    innerPlane.width.value = planeAnchor.extent.x / 2;
    innerPlane.height.value = planeAnchor.extent.z / 2;

    print(
        '*** plane extent x, y -> ${planeAnchor.extent.x}, ${planeAnchor.extent.z}');
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    print('*** plane extent x, y -> ${anchor.extent.x}, ${anchor.extent.z}');

    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );

    node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );

    // ARKitReferencePostNode
    innerPlane = ARKitPlane(
      width: anchor.extent.x / 2,
      height: anchor.extent.z / 2,
      materials: [
        ARKitMaterial(
          transparency: 0.7,
          diffuse: ARKitMaterialProperty(color: Colors.blue),
        )
      ],
    );

    innerNode = ARKitReferencePostNode(
      avatar: null,
      description: null,
      raw: "TEXT",
      type: "HOLAAAAAAA",
      username: "USER 1",
      likes: 0,
      views: 1,
      scale: vector.Vector3(0.5, 0.5, 0.5),
      position: vector.Vector3(anchor.center.x, 0.01, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );

    // controller.add(node, parentNodeName: anchor.nodeName);
    controller.addUIView(innerNode, parentNodeName: anchor.nodeName);
  }
}
