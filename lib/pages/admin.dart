import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class AdminPage extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;

  AdminPage(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductCreatePage(addProduct, deleteProduct),
            ProductListPage(),
          ],
        ),
      ),
    );
  }
}
