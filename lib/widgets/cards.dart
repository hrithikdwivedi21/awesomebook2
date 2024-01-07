import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          cardHeader(),
          CardMedia(),
          CardIcons(),
          Container(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 3),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10 likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text('Hrithik Dwivedi  ',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(
                    'Yeah the view is amazing...',
                  ),
                ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 25,
            thickness: 0.1,
            indent: 2,
            endIndent: 2,
          ),
        ],
      ),
    );
  }

  Container CardMedia() {
    return Container(
      child: Image.network(
          'https://learnopencv.com/wp-content/uploads/2021/04/image-15.png'),
    );
  }

  Container CardIcons() {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.favorite_border_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.comment_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
          Spacer(),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.bookmark_border_outlined))
        ],
      ),
    );
  }

  Container cardHeader() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10,left: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(
                  'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg'),
            ),
            Text(" hrithikdwivedi"),
            Spacer(),
            // IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
}
