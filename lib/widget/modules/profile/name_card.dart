import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  const NameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 25,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: const Text(
                  'DC',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Name'),
                Text('youremail@mail.com'),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Color(0xFF3077E3),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
