import 'package:flutter/material.dart';

class ConditionalContent extends StatelessWidget {
  final bool myConditional;
  final Function evenBuilder;
  final Function oddBuilder;

  ConditionalContent(this.myConditional, this.evenBuilder, this.oddBuilder, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => myConditional ? evenBuilder() : oddBuilder();
}