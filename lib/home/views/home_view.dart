import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silkroad/utils/views/theme_input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: SizedBox(
                  height: 50,
                  child: ThemeInputField(
                    labelText: 'Your name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              _buildActionSelectButton(
                context,
                label: 'Send',
                svgPath: 'assets/svg_icons/transfer-in.svg',
                onPressed: () => Navigator.pushNamed(context, '/send'),
              ),
              _buildActionSelectButton(
                context,
                label: 'Receive',
                svgPath: 'assets/svg_icons/transfer-out.svg',
                onPressed: () => Navigator.pushNamed(context, '/receive'),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Widget _buildActionSelectButton(BuildContext context, {required String label, required String svgPath, void Function()? onPressed}){
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
        child: ElevatedButton(
          key: ValueKey<String>(label),
          onPressed: onPressed,
          child: SizedBox(
            height: 200,
            // width: 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  svgPath,
                  height: 90,
                  color: MediaQuery.platformBrightnessOf(context) == Brightness.dark ? Colors.white : Colors.black,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
