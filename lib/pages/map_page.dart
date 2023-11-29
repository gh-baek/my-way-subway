import 'package:flutter/material.dart';
import 'package:subway/style.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

//TODO: 맵 가로모드
class _MapPageState extends State<MapPage> {
  final _viewTransformationController = TransformationController();

  @override
  void initState() {
    final zoomFactor = 2.0;
    final xTranslate = 300.0;
    final yTranslate = 300.0;
    _viewTransformationController.value.setEntry(0, 0, zoomFactor);
    _viewTransformationController.value.setEntry(1, 1, zoomFactor);
    _viewTransformationController.value.setEntry(2, 2, zoomFactor);
    _viewTransformationController.value.setEntry(0, 3, -xTranslate);
    _viewTransformationController.value.setEntry(1, 3, -yTranslate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: primaryBlue,
          toolbarHeight: 100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: Text(
                      '노선도',
                      style: appBarTitleStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _viewTransformationController,
          maxScale: 6.0,
          minScale: 1.0,
          child: Image.asset(
            'lib/assets/images/map.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
