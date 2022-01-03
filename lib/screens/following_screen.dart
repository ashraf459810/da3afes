import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/screens/user_screen.dart';
import 'package:flutter/material.dart';

class FollowScreen extends StatefulWidget {
  List<Following> list;
  String title;

  FollowScreen(this.list, this.title) {
    if (list == null) {
      list = List<Following>();
    }
  }

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  List<Following> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(widget.title),
      body: Container(
        child: Column(
          children: <Widget>[
            new Container(
                color: Theme.of(context).primaryColor,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: _buildSearchBox())),
            new Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? _buildSearchResults()
                    : _buildUsersList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return new Card(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: () => navigate(context, UserScreen(_searchResult[i].id)),
              child: new ListTile(
                leading: new CircleAvatar(
                  child: Icon(
                    Icons.supervised_user_circle,
                    color: yellowAmber,
                  ),
                ),
                title: new Text(_searchResult[i].fullName),
              ),
            ),
          ),
          margin: const EdgeInsets.all(0.0),
        );
      },
    );
  }

  Widget _buildUsersList() {
    return new ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        return new Card(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: () =>
                  navigate(context, UserScreen(widget.list[index].followingId)),
              child: new ListTile(
                leading: new CircleAvatar(
                  child: Icon(
                    Icons.supervised_user_circle,
                    color: yellowAmber,
                  ),
                ),
                title: new Text(widget.list[index].fullName),
              ),
            ),
          ),
          margin: const EdgeInsets.all(0.0),
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'البحث', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.list.forEach((userDetail) {
      if (userDetail.fullName.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(userDetail);
        print(userDetail.fullName.toLowerCase() + " " + text.toLowerCase());
      }
    });

    setState(() {});
  }
}
