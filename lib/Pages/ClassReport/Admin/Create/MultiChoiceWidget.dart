import 'package:flutter/material.dart';


class MultiChoiceWidget extends StatefulWidget {
  final Function(dynamic) onSave;
  final dynamic initialValue;
  final List<dynamic> dataSource;
  const MultiChoiceWidget(this.onSave, this.initialValue, this.dataSource);
  @override
  _MultiChoiceWidgetState createState() => _MultiChoiceWidgetState();
}

class _MultiChoiceWidgetState extends State<MultiChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}