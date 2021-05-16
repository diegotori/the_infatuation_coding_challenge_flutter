import 'package:flutter/material.dart';

class GithubRepoRow extends StatelessWidget {
  const GithubRepoRow({
    Key? key,
    required this.fullName,
    this.desc,
    required this.language,
    required this.stargazersCount,
  }) : super(key: key);
  final String fullName;
  final String? desc;
  final String language;
  final int stargazersCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        fullName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (desc != null) ...[
            Text(desc!),
            SizedBox(
              height: 2,
            ),
          ],
          Text(language),
          Text("Stars: $stargazersCount"),
        ],
      ),
    );
  }
}
