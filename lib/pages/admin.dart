import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import './remote_storage.dart';
import '../scoped-models/main_model.dart';
import '../widgets/logout_tile.dart';

class AdminPage extends StatelessWidget {
  final MainModel model;

  AdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Actions'),
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('All Products'),
                onTap: () => Navigator.pushReplacementNamed(context, '/all'),
              ),
              Divider(),
              LogoutTile(),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            indicatorColor: Colors.yellowAccent,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.create), text: 'Create Product'),
              Tab(icon: Icon(Icons.list), text: 'My Products'),
              Tab(icon: Icon(Icons.settings_remote), text: 'Remote Storage'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(),
            ProductListPage(model),
            RemoteStoragePage(
              asSetup: false,
            ),
          ],
        ),
      ),
    );
  }
}
