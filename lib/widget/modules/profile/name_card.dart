import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/auth/auth_model.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/widget/elements/skeleton.dart';

class NameCard extends ConsumerWidget {
  const NameCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GetLoggedInUserResponse> user = ref.watch(
      getLoggedUserProvider,
    );
    final String name = user.value?.data.name ?? '';
    final String initialName = name.isNotEmpty
        ? name.split('')[0].toUpperCase()
        : '';

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
                child: Text(
                  initialName,
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
                user.when(
                  data: (value) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(value.data.name), Text(value.data.email)],
                  ),
                  error: (error, stack) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      SkeletonBox(width: 100, height: 20),
                      SkeletonBox(width: 130, height: 20),
                    ],
                  ),
                  loading: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      SkeletonBox(width: 100, height: 20),
                      SkeletonBox(width: 130, height: 20),
                    ],
                  ),
                ),
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
