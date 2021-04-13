import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeReply extends StatelessWidget {
  const NoticeReply({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 30.w,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/test-img.jpeg'),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "유저 아이디",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('더드림/시온/두드림 . 25분전'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        width: 180.w,
                        child: Text(
                          "본문 ~~~~ ~~~ \n ~~~~~~~~~~~~~~~ \n ~~~~~~~~~~~~~~ asdjaskdljaslkdjalksjdlkasjdlkjaslkdjaslkjdlkasjdlkjasldkjaslkdjlaksjdlkasjdlkasjdlkajsdlkjaslkdjaslkdjlaksjdlkasjdlkj",
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Text(
                            "공감하기",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    //Reply List
                    Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(child: Icon(Icons.more_vert)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
