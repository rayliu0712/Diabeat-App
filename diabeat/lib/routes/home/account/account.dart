import 'package:diabeat/core/session.dart' as session;
import 'package:diabeat/util.dart' as util;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatelessWidget {
  final _insulinImage = const AssetImage('assets/insulin.jpg');
  final _healthImage = const AssetImage('assets/health.jpg');
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(_insulinImage, context);
    precacheImage(_healthImage, context);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: Text(session.username),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(
              context,
              _insulinImage,
              'AI 糖尿病風險檢測',
              '/account/predict_diabetes',
            ),
            const SizedBox(height: 20),
            _card(context, _healthImage, 'AI 健康諮詢', '/account/consult'),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                _logOut(context);
              },
              style: util.filledPageButtonStyle(),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('登出'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logOut(BuildContext context) async {
    await session.logOutAndDelete();
    context.go('/guest');
  }

  Widget _card(
    BuildContext context,
    ImageProvider image,
    String label,
    String path,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push(path);
        },
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              Ink.image(
                image: image,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 18,
                right: 18,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(230, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
