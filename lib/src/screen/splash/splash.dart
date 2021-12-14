import 'package:cats_vs_dogs/src/application.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = context.watch<SplashProvider>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: getWidth(100)),
          if (provider.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                provider.image!,
                width: getWidth(90),
                height: getWidth(90),
                fit: BoxFit.cover,
              ),
            ),
          if (provider.result != null)
            CustomText(
              text: provider.resultAsText,
              fontSize: 25,
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.pickAnImage,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
