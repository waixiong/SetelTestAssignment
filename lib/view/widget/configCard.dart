import 'package:Setel_Test_Assignment/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConfigCard extends StatelessWidget {

  final Widget trailingWidget;
  final String title;
  final String item;

  ConfigCard(this.title, this.item, {this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 90,
        padding: EdgeInsets.all(12),
        child: ListTile(
          title: Text(title),
          subtitle: Text(item),
          trailing: trailingWidget,
        ),
      ),
    );
  }
}