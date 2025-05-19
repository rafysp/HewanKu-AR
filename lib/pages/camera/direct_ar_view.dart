// // direct_ar_view.dart (menggunakan plane detection standar)
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin_2/models/ar_node.dart';
// import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
// import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class DirectARView extends StatefulWidget {
//   final String modelUrl;
//   final String animalName;
  
//   const DirectARView({Key? key, required this.modelUrl, required this.animalName}) : super(key: key);

//   @override
//   _DirectARViewState createState() => _DirectARViewState();
// }

// class _DirectARViewState extends State<DirectARView> with WidgetsBindingObserver {
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;
//   ARAnchorManager? arAnchorManager;
//   ARNode? animalNode;
//   ARAnchor? anchor;
//   bool isLoading = true;
//   bool isPlaced = false;
//   bool isLocked = true; // Kunci model secara default
//   double scaleFactor = 0.2;
//   final double scaleStep = 0.05;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       if (arSessionManager != null) {
//         arSessionManager!.onInitialize();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           widget.animalName,
//           style: TextStyle(
//             color: Colors.white, 
//             fontWeight: FontWeight.bold,
//             shadows: [
//               Shadow(
//                 offset: Offset(1, 1),
//                 blurRadius: 3,
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//         leading: Container(
//           margin: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.7),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () => Get.back(),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // AR View dengan plane detection
//           ARView(
//             onARViewCreated: onARViewCreated,
//             planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//           ),
          
//           // Loading indicator
//           if (isLoading)
//             Container(
//               color: Colors.black54,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: 60, 
//                       height: 60,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 5,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       "Sedang menyiapkan AR...",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Mohon tunggu sebentar",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
          
//           // Instruksi untuk penempatan
//           if (!isLoading && !isPlaced)
//             Positioned(
//               bottom: MediaQuery.of(context).size.height / 2 - 50,
//               left: 0,
//               right: 0,
//               child: Container(
//                 alignment: Alignment.center,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     "Arahkan kamera ke permukaan datar dan tap untuk menempatkan model",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
          
//           // Instruksi setelah model ditempatkan
//           if (!isLoading && isPlaced)
//             Positioned(
//               top: kToolbarHeight + 20,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: TweenAnimationBuilder<double>(
//                   tween: Tween(begin: 0.0, end: 1.0),
//                   duration: Duration(seconds: 1),
//                   builder: (_, value, child) {
//                     return Opacity(
//                       opacity: value,
//                       child: child,
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       isLocked 
//                           ? "Model terkunci pada posisi" 
//                           : "Geser untuk menggerakkan, putar dengan dua jari",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
          
//           // Control buttons - hanya tampilkan setelah model ditempatkan
//           if (isPlaced)
//             Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildControlButton(
//                     icon: Icons.remove,
//                     label: "Perkecil",
//                     color: Colors.red[400]!,
//                     onTap: () => changeScale(false),
//                   ),
//                   const SizedBox(width: 16),
//                   _buildControlButton(
//                     icon: Icons.refresh,
//                     label: "Reset",
//                     color: Colors.blue[400]!,
//                     onTap: resetPlacement,
//                   ),
//                   const SizedBox(width: 16),
//                   _buildControlButton(
//                     icon: Icons.add,
//                     label: "Perbesar",
//                     color: Colors.green[400]!,
//                     onTap: () => changeScale(true),
//                   ),
//                 ],
//               ),
//             ),
          
//           // Lock/Unlock button - hanya setelah model ditempatkan
//           if (isPlaced)
//             Positioned(
//               bottom: 100,
//               right: 20,
//               child: ElevatedButton.icon(
//                 onPressed: toggleLock,
//                 icon: Icon(isLocked ? Icons.lock_open : Icons.lock),
//                 label: Text(isLocked ? "Gerakkan" : "Kunci"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//               ),
//             ),
          
//           // Deteksi plane indicator
//           if (!isLoading && !isPlaced)
//             Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         "Sedang mendeteksi permukaan...",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon),
//       label: Text(label),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }

//   void onARViewCreated(
//       ARSessionManager arSessionManager,
//       ARObjectManager arObjectManager,
//       ARAnchorManager arAnchorManager,
//       ARLocationManager arLocationManager) {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;
//     this.arAnchorManager = arAnchorManager;

//     // Inisialisasi AR dengan plane detection
//     this.arSessionManager!.onInitialize(
//       showFeaturePoints: true, // Tampilkan titik fitur untuk visual feedback
//       showPlanes: true, // Tampilkan bidang terdeteksi
//       handleTaps: true, // Aktifkan tap untuk menempatkan objek
//       handlePans: !isLocked,
//       handleRotation: !isLocked,
//     );
    
//     // Inisialisasi object manager
//     this.arObjectManager!.onInitialize();
    
//     // Inisialisasi anchor manager
//     this.arAnchorManager!.onInitialize();
    
//     // Handle tap pada bidang terdeteksi
//     this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    
//     // Setup gesture handlers jika tidak terkunci
//     setupGestureHandlers();
    
//     // Set status loading selesai
//     Future.delayed(Duration(milliseconds: 500), () {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     });
//   }
  
//   Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
//     if (isPlaced) return; // Jika sudah ditempatkan, abaikan tap
    
//     // Pilih hasil hit test pertama
//     ARHitTestResult? hit;
//     for (final result in hitTestResults) {
//       // Prioritaskan hit pada bidang horizontal
//       if (result.type == ARHitTestResultType.plane) {
//         hit = result;
//         break;
//       }
//     }
    
//     if (hit != null) {
//       setState(() {
//         isLoading = true;
//       });
      
//       try {
//         // Buat anchor pada titik tap
//         anchor = ARPlaneAnchor(transformation: hit.worldTransform);
//         bool? anchorAdded = await arAnchorManager?.addAnchor(anchor!);
        
//         if (anchorAdded == true) {
//           // Buat node yang terhubung ke anchor
//           animalNode = ARNode(
//             type: NodeType.webGLB,
//             uri: widget.modelUrl,
//             scale: vector.Vector3(scaleFactor, scaleFactor, scaleFactor),
//             rotation: vector.Vector4(1, 0, 0, 0),
//             position: vector.Vector3(0, 0, 0), // Posisi relatif terhadap anchor
//           );
          
//           bool? nodeAdded = await arObjectManager?.addNode(animalNode!, planeAnchor: anchor);
          
//           if (nodeAdded == true) {
//             setState(() {
//               isPlaced = true;
//               isLoading = false;
//             });
            
//             // Tampilkan snackbar sukses
//             Get.snackbar(
//               "Berhasil",
//               "Model ${widget.animalName} berhasil ditempatkan",
//               backgroundColor: Colors.green.withOpacity(0.7),
//               colorText: Colors.white,
//               duration: Duration(seconds: 2),
//               snackPosition: SnackPosition.TOP,
//             );
//           } else {
//             showErrorMessage("Gagal menambahkan model");
//             setState(() {
//               isLoading = false;
//             });
//           }
//         } else {
//           showErrorMessage("Gagal membuat anchor");
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         print("Error menempatkan model: $e");
//         showErrorMessage("Error: $e");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
  
//   void setupGestureHandlers() {
//     if (arObjectManager == null) return;
    
//     if (!isLocked) {
//       // Aktifkan gestures jika tidak terkunci
//       arObjectManager!.onPanStart = onPanStarted;
//       arObjectManager!.onPanChange = onPanChanged;
//       arObjectManager!.onPanEnd = onPanEnded;
//       arObjectManager!.onRotationStart = onRotationStarted;
//       arObjectManager!.onRotationChange = onRotationChanged;
//       arObjectManager!.onRotationEnd = onRotationEnded;
//     } else {
//       // Nonaktifkan gestures jika terkunci
//       arObjectManager!.onPanStart = null;
//       arObjectManager!.onPanChange = null;
//       arObjectManager!.onPanEnd = null;
//       arObjectManager!.onRotationStart = null;
//       arObjectManager!.onRotationChange = null;
//       arObjectManager!.onRotationEnd = null;
//     }
//   }
  
//   void resetPlacement() {
//     setState(() {
//       isLoading = true;
//       isPlaced = false;
//     });
    
//     try {
//       // Hapus node dan anchor yang ada
//       if (animalNode != null) {
//         arObjectManager?.removeNode(animalNode!);
//         animalNode = null;
//       }
      
//       if (anchor != null) {
//         arAnchorManager?.removeAnchor(anchor!);
//         anchor = null;
//       }
      
//       // Reset session AR
//       arSessionManager?.onInitialize(
//         showFeaturePoints: true,
//         showPlanes: true,
//         handleTaps: true,
//         handlePans: !isLocked,
//         handleRotation: !isLocked,
//       );
      
//       // Aktifkan kembali tap handler
//       arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
      
//       // Status loading selesai
//       Future.delayed(Duration(milliseconds: 300), () {
//         if (mounted) {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       });
      
//       // Notifikasi pengguna
//       Get.snackbar(
//         "Reset",
//         "Silakan pilih permukaan untuk menempatkan model",
//         backgroundColor: Colors.blue.withOpacity(0.7),
//         colorText: Colors.white,
//         duration: Duration(seconds: 2),
//       );
//     } catch (e) {
//       print("Error saat reset: $e");
//       setState(() {
//         isLoading = false;
//       });
//       showErrorMessage("Gagal reset model: $e");
//     }
//   }
  
//   void changeScale(bool increase) {
//     if (animalNode == null) return;
    
//     setState(() {
//       isLoading = true;
//     });
    
//     try {
//       // Perbarui faktor skala
//       if (increase) {
//         scaleFactor += scaleStep;
//       } else {
//         scaleFactor = max(0.1, scaleFactor - scaleStep); // Cegah skala terlalu kecil
//       }
      
//       // Update skala node yang ada
//       animalNode!.scale = vector.Vector3(scaleFactor, scaleFactor, scaleFactor);
      
//       // Perbarui node
//       arObjectManager?.updateNode(animalNode!);
      
//       // Status loading selesai
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error mengubah ukuran: $e");
//       setState(() {
//         isLoading = false;
//       });
//       showErrorMessage("Gagal mengubah ukuran: $e");
//     }
//   }
  
//   void toggleLock() {
//     setState(() {
//       isLocked = !isLocked;
//     });
    
//     // Update session settings
//     if (arSessionManager != null) {
//       arSessionManager!.onInitialize(
//         showFeaturePoints: true,
//         showPlanes: true,
//         handleTaps: !isPlaced, // Hanya aktifkan tap jika belum ditempatkan
//         handlePans: !isLocked, // Toggle gestures
//         handleRotation: !isLocked, // Toggle gestures
//       );
//     }
    
//     // Update gesture handlers
//     setupGestureHandlers();
    
//     // Notifikasi pengguna
//     Get.snackbar(
//       isLocked ? "Model Terkunci" : "Model Dapat Digerakkan",
//       isLocked 
//           ? "Model berada di posisi tetap" 
//           : "Sekarang Anda dapat menggerakkan model",
//       duration: Duration(seconds: 2),
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
  
//   void showErrorMessage(String message) {
//     Get.snackbar(
//       "Error",
//       message,
//       backgroundColor: Colors.red.withOpacity(0.7),
//       colorText: Colors.white,
//       duration: Duration(seconds: 3),
//     );
//   }
  
//   // Gesture callbacks
//   void onPanStarted(String nodeName) {
//     print("Pan started on node: $nodeName");
//   }
  
//   void onPanChanged(String nodeName) {
//     // Update node terakhir yang dimanipulasi
//   }
  
//   void onPanEnded(String nodeName, Matrix4 transform) {
//     print("Pan ended on node: $nodeName");
//   }
  
//   void onRotationStarted(String nodeName) {
//     print("Rotation started on node: $nodeName");
//   }
  
//   void onRotationChanged(String nodeName) {
//     // Update node terakhir yang dirotasi
//   }
  
//   void onRotationEnded(String nodeName, Matrix4 transform) {
//     print("Rotation ended on node: $nodeName");
//   }
  
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     arSessionManager?.dispose();
//     super.dispose();
//   }
  
//   // Helper untuk mencegah skala terlalu kecil
//   double max(double a, double b) {
//     return a > b ? a : b;
//   }
// }