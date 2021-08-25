import 'package:doit/models/quote.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:flutter/material.dart';

class QuoteOfDay extends StatelessWidget {
  final Quote quote;
  QuoteOfDay({
    Key? key,
    required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: ScalableText(
            '🍀',
            style: TextStyle(fontSize: 40),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScalableText(
                'Frase do dia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Container(height: 4),
              RichText(
                text: TextSpan(
                  text: '${this.quote.quote}',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' (por: ${this.quote.author})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
