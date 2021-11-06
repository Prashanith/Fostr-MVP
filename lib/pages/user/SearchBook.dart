import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fostr/models/Book.dart';
import 'package:fostr/models/TopReads.dart';
import 'package:fostr/models/UserModel/UserProfile.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/UserService.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
class SearchBook extends StatefulWidget {
  const SearchBook({Key? key}) : super(key: key);

  @override
  _SearchBookState createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {

  List<VolumeInfo> _items = [];
  List<ImageLinks> _imageItems = [];
  int booksCount = 0;
  TextEditingController controller = new TextEditingController();
  bool _isLoading = false;
  final subject = new PublishSubject<String>();
  UserService userServices = GetIt.I<UserService>();

  void updateProfile(Map<String, dynamic> data) async {
    await userServices.updateUserField(data);
  }

  void _textChanged(String text) {
    if(text.isEmpty) {
      setState((){_isLoading = false;});
      _clearList();
      return;
    }
    setState((){_isLoading = true;});
    _clearList();
    var url =  Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{$text}'});
    http.get(url)
        .then((response) => response.body)
        .then(json.decode)
        .then((map) => map["items"])
        .then((list) {list.forEach(_addBook);})
        .catchError(_onError)
        .then((e){setState((){_isLoading = false;});});
  }

  void _addBook(dynamic book) {
    setState(() {
      _items.add(new VolumeInfo(book['volumeInfo']['publisher'], book['volumeInfo']['title'], book['volumeInfo']['publisher'],new ImageLinks(book['volumeInfo']['imageLinks']['thumbnail'])));
    });

  }

  void _onError(dynamic d) {
    setState(() {
      _isLoading = false;
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    subject.stream.listen(_textChanged);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subject.close();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return SafeArea(
      child: Scaffold(
          body:SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: controller,
                    onChanged: (string) => (subject.add(string)),
                    decoration: InputDecoration(
                        hintText: "Search for book"
                    ),
                  ),
                ),
                _isLoading? new CircularProgressIndicator(): new Container(),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  padding: new EdgeInsets.all(8.0),
                  itemCount: _items.length < 0 ? 0:_items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        // final _userCollection = FirebaseFirestore.instance.collection("users");
                        // TopReads tr = TopReads(_items[index].title, _items[index].image.thumb);
                        // Map<String,dynamic> mp = tr.toMap();
                        // if (user.userProfile == null) {
                        //   var userProfile = UserProfile();
                        //   userProfile.topRead = ;
                        //   user.userProfile = userProfile;
                        // } else {
                        //   user.userProfile!.bio = e[1];
                        // }
                        // updateProfile({
                        //   "userProfile":
                        //   user.userProfile!.toJson(),
                        //   "id": user.id
                        // });
                        // _userCollection.doc(user.id).set({
                        //   "userProfile": {
                        //     "topRead":FieldValue.arrayUnion([
                        //       tr.toMap()
                        //     ])
                        //   }
                        //
                        //
                        // },SetOptions(merge:true)).then((value) => Navigator.of(context).pop());
                      },
                      child: new Card(
                          child: new Padding(
                              padding: new EdgeInsets.all(8.0),
                              child: new Row(
                                children: <Widget>[
                                  _items[index].image != null? Image.network(_items[index].image.thumb.toString()): new Container(),
                                  new Flexible(
                                    child: new Text(_items[index].title, maxLines: 10),
                                  ),
                                ],
                              )
                          )
                      ),
                    );
                    //  return new BookCardMinimalistic(_items[index]);
                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}
