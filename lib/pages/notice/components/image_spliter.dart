import 'package:flutter/material.dart';

class ImageSpliter extends StatelessWidget {
  final List<String> images;
  const ImageSpliter({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      //단일 이미지
      return Container(
        child: Image.network(
          images[0],
          fit: BoxFit.cover,
        ),
      );
    } else if (images.length == 2) {
      //2장
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
            images[0],
            fit: BoxFit.cover,
          ))
        ],
      );
    } else if (images.length > 2) {
      //3장 이상
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
              images[0],
              fit: BoxFit.cover,
            )),
            SizedBox(
              height: 5,
            ),
            if (images.length == 3)
              Expanded(
                  child: Image.network(
                images[0],
                fit: BoxFit.cover,
              )),
            if (images.length > 3)
              Expanded(
                  child: Stack(children: [
                Positioned.fill(
                  child: Container(
                    child: Image.network(
                      images[0],
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
    return Container();
  }
}
