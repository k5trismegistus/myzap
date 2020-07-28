import 'package:flutter/material.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/widgets/waiting.dart';

abstract class LoadablePage<T> extends State<StatefulWidget> {
  String title;
  bool loading;
  Widget floatingActionButton;

  Widget buildBody(BuildContext context);

  void setLoading() {
    this.loading = true;
  }

  void unsetLoading() {
    this.loading = false;
  }

  @override
  Widget build(BuildContext context) {
    var body = buildBody(context);

    return DefaultLayout(
      title: this.title,
      page: this.loading ? WaitingWidget(bgPage: body) : body,
      floatingActionButton: (this.floatingActionButton != null) ? this.floatingActionButton : null
    );
  }
}