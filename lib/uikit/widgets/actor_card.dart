import 'package:flutter/material.dart';

class ActorCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Function() onTap;

  const ActorCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
