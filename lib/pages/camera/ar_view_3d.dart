// import 'package:ar_flutter_plugin_engine/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin_engine/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin_engine/datatypes/hittest_result_types.dart';
// import 'package:ar_flutter_plugin_engine/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin_engine/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin_engine/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin_engine/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin_engine/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin_engine/models/ar_anchor.dart';
// import 'package:ar_flutter_plugin_engine/models/ar_hittest_result.dart';
// import 'package:ar_flutter_plugin_engine/models/ar_node.dart';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart' as vectorMath64;

// class ArView3d extends StatefulWidget {
//   final String name;
//   final String model3dUrl;

//   const ArView3d({
//     Key? key,
//     required this.name,
//     required this.model3dUrl,
//   }) : super(key: key);

//   @override
//   State<ArView3d> createState() => _ArView3dState();
// }

// class _ArView3dState extends State<ArView3d> {
//   ARSessionManager? sessionManagerAR;
//   ARObjectManager? objectManagerAR;
//   ARAnchorManager? anchorManagerAR;
//   List<ARNode> allNodesList = [];
//   List<ARAnchor> allAnchors = [];
//   double scaleFactor = 0.62;

//   createARView(
//       ARSessionManager arSessionManager,
//       ARObjectManager arObjectManager,
//       ARAnchorManager arAnchorManager,
//       ARLocationManager locationManagerAR) {
//     sessionManagerAR = arSessionManager;
//     objectManagerAR = arObjectManager;
//     anchorManagerAR = arAnchorManager;

//     sessionManagerAR!.onInitialize(
//       handleRotation: true,
//       handlePans: true,
//       showWorldOrigin: true,
//       showFeaturePoints: false,
//       showPlanes: true,
//     );
//     objectManagerAR!.onInitialize();

//     sessionManagerAR!.onPlaneOrPointTap = detectPlaneAndLetUserTap;
//     objectManagerAR!.onPanStart = duringOnPanStarted;
//     objectManagerAR!.onPanChange = duringOnPanChanged;
//     objectManagerAR!.onPanEnd = duringOnPanEnded;
//     objectManagerAR!.onRotationStart = duringOnRotationStarted;
//     objectManagerAR!.onRotationChange = duringOnRotationChanged;
//     objectManagerAR!.onRotationEnd = duringOnRotationEnded;
//   }

//   duringOnPanStarted(String object3DNodeName) {
//     print('Panning Node Started = ' + object3DNodeName);
//   }

//   duringOnPanChanged(String object3DNodeName) {
//     print('Panning Node Changed = ' + object3DNodeName);
//   }

//   duringOnPanEnded(String object3DNodeName, Matrix4 transformMatrix4) {
//     print('Panning Node Ended = ' + object3DNodeName);
//     final pannedNode =
//         allNodesList.firstWhere((node) => node.name == object3DNodeName);
//   }

//   duringOnRotationStarted(String object3DNodeName) {
//     print('Rotation Node Started = ' + object3DNodeName);
//   }

//   duringOnRotationChanged(String object3DNodeName) {
//     print('Rotation Node Changed = ' + object3DNodeName);
//   }

//   duringOnRotationEnded(String object3DNodeName, Matrix4 transformMatrix4) {
//     print('Rotation Node Ended = ' + object3DNodeName);
//     final pannedNode =
//         allNodesList.firstWhere((node) => node.name == object3DNodeName);
//   }

//   Future<void> detectPlaneAndLetUserTap(
//       List<ARHitTestResult> hitTapResultsList) async {
//     var userHitTapResultsList = hitTapResultsList.firstWhere(
//         (ARHitTestResult userHitPoint) =>
//             userHitPoint.type == ARHitTestResultType.plane);
//     {
//       var planeARAnchor =
//           ARPlaneAnchor(transformation: userHitTapResultsList.worldTransform);

//       bool? anchorAdded = await anchorManagerAR!.addAnchor(planeARAnchor);

//       if (anchorAdded!) {
//         allAnchors.add(planeARAnchor);

//         var object3DNewNode = ARNode(
//             type: NodeType.webGLB,
//             uri: widget.model3dUrl,
//             scale: vectorMath64.Vector3(0.62, 0.62, 0.62),
//             position: vectorMath64.Vector3(0, 0, 0),
//             rotation: vectorMath64.Vector4(1, 0, 0, 0));

//         bool? addARNodeToAnchor = await objectManagerAR!
//             .addNode(object3DNewNode, planeAnchor: planeARAnchor);
//         if (addARNodeToAnchor!) {
//           allNodesList.add(object3DNewNode);
//         } else {
//           sessionManagerAR!.onError('Node to Anchor attachment failed');
//         }
//       } else {
//         sessionManagerAR!.onError('Failed. addition failed');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('${widget.name} 3D',
//               style: const TextStyle(
//                   letterSpacing: 3, fontWeight: FontWeight.bold)),
//           centerTitle: true,
//         ),
//         body: Stack(
//           children: [
//             ARView(
//               planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//               onARViewCreated: createARView,
//             ),
//           ],
//         ));
//   }
// }