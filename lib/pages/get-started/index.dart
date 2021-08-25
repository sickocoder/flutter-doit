import 'package:doit/models/quote.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

final String assetName = 'assets/svg/employee-with-workload.svg';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quote = ModalRoute.of(context)!.settings.arguments;
    final double navigationBarHeight = MediaQuery.of(context).padding.bottom;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: ScalableText(
                        'Dê fim aos dias improdutivos cheios de tarefas não orquestradas',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Container(height: 64.0),
                    SvgPicture.asset(
                      assetName,
                      semanticsLabel: 'GetStarted image',
                    ),
                    Container(height: height * 0.1),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              pressedOpacity: 0.9,
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: navigationBarHeight),
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: 48,
                  child: Center(
                    child: ScalableText(
                      "Vamos A Isso!!!",
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: quote,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
