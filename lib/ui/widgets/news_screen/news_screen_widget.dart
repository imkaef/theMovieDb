import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class NewsScreenWidget extends StatefulWidget {
  const NewsScreenWidget({
    Key? key,
  }) : super(key: key);
  @override
  _NewsScreenWidgetState createState() => _NewsScreenWidgetState();
}

class _NewsScreenWidgetState extends State<NewsScreenWidget> {
  List<Image> images = [];
  late PaletteGenerator paletColor;

  late List<PaletteGenerator> colors;
  @override
  void initState() {
    super.initState();
    //  colors = [];

    images.addAll(
      [
        Image.network(
          'https://sun1-19.userapi.com/s/v1/ig1/DQO8ENeBVPGNwCSgSLpaECuCsy781Pidg-Q-attLpaL7k_GwTrUW9pRGowhDcHTkduTJckLD.jpg?size=200x200&quality=96&crop=1,119,954,954&ava=1',
          filterQuality: FilterQuality.high,
        ),
        // Image.network(
        //   'https://sun1-29.userapi.com/s/v1/if1/R2KrOmcll_adCk3MUo9L60Rp-L8Aa7pWIjkzER13TsrjBpatg1HJtVfyTlV4JUFm-m_ljfdY.jpg?size=200x200&quality=96&crop=107,61,1046,1046&ava=1',
        //   filterQuality: FilterQuality.high,
        // ),
      ],
    );
    _updatePalettes();
  }

  _updatePalettes() async {
    if (images.isEmpty) return;
    for (var image in images) {
      // colors.add(await _generatePalette(image))
      paletColor = await _generatePalette(image);
    }
  }

  // final PaletteGenerator palette;  color: palette.darkMutedColor.color.withOpacity(0.8),
  Future<PaletteGenerator> _generatePalette(Image image) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(image.image);
    return _paletteGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: paletColor.dominantColor?.color,
      child: ListView(
        children: images,
      ),
    );
  }
}
