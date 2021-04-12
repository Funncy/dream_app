import 'package:flutter/material.dart';

class ImageSpliter extends StatelessWidget {
  final List<String> images;
  const ImageSpliter({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.length == 0) {
      return Container();
    }
    switch (images.length) {
      case 1:
        return Container(
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
          ),
        );
        break;
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Image.network(
              images[0],
              fit: BoxFit.cover,
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Image.network(
              images[1],
              fit: BoxFit.cover,
            ))
          ],
        );
        break;
      case 3:
      default:
        return ThreeDivisionImages(images: images);
        break;
    }
  }
}

class ThreeDivisionImages extends StatelessWidget {
  const ThreeDivisionImages({
    Key key,
    @required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          child: Image.network(
        images[0],
        fit: BoxFit.cover,
      )),
      SizedBox(
        width: 8,
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Image.network(
            images[1],
            fit: BoxFit.cover,
          )),
          SizedBox(
            height: 5,
          ),
          if (images.length == 3)
            Expanded(
                child: Image.network(
              images[2],
              fit: BoxFit.cover,
            )),
          if (images.length > 3)
            Expanded(
                child: Stack(children: [
              Positioned.fill(
                child: Container(
                  child: Image.network(
                    images[2],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                  child: Container(
                decoration: BoxDecoration(color: Colors.black54),
                child: Center(
                  child: Text(
                    "+${images.length - 2}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
            ])),
        ],
      ))
    ]);
  }
}
