import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_app_everyday921/domain/record.dart';
import 'package:one_app_everyday921/presentation/web_page/web_page.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

// class YellowBird extends StatefulWidget {
//   const YellowBird({ Key? key }) : super(key: key);
//
//   @override
//   State<YellowBird> createState() => _YellowBirdState();
// }
//
// class _YellowBirdState extends State<YellowBird> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: const Color(0xFFFFE306));
//   }
// }
String memoContent = '';

class DailyPage extends StatelessWidget {
  //DailyDataを保存してみる
  // RxList<DailyData> memo = <DailyData>[].obs;
  // void getDailyData() async {
  //   await Hive.openBox('dailydata');
  //   final box2 = await Hive.openBox('dailydata');
  //   memo.value = jsonDecode(box2.get('memo'))
  //       .map((el) => DailyData.fromJson(el))
  //       .toList()
  //       .cast<DailyData>() as List<DailyData>;
  // }

  //しんじさんのコード
  RxList<Record> urls = <Record>[].obs;
  void getUrls() async {
    await Hive.openBox('url');
    final box = await Hive.openBox('url');
    urls.value = jsonDecode(box.get('records'))
        .map((el) => Record.fromJson(el))
        .toList()
        .cast<Record>() as List<Record>;

    // print(urls.value[0].url);
    // print(urls.value[1].url);
    // print(urls.value[2].url);
    // print(urls.value[3].url);
    // print(urls.value.length);
    // final list = [];
  }

  //   // print(urls.value[0].url);
  //   // print(urls.value[1].url);
  //   // print(urls.value[2].url);
  //   // print(urls.value[3].url);
  //   // print(urls.value.length);
  //   // final list = [];
  // }

  final wc = Get.put(WebController());
  @override
  Widget build(BuildContext context) {
    getUrls();
    // print(urls.value);
    // var todayData = wc.records.toList().obs;
    // var todayUrls = todayData.map((el) => (el.url)).toList().obs;
    // var todayUrls = urls;
    RxList items = List<int>.generate(urls.length, (int index) => index).obs;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 360,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      onChanged: (string) {
                        memoContent = string;
                        // print(name);
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    //ここにデータの保存について記載
                    void saveDailyData() async {
                      await Hive.openBox('dailydata');
                      final box = await Hive.openBox('dailydata');
                      box.put('data', memoContent);
                      print('${box.get('data').toString()}');
                    }

                    saveDailyData();
                  },
                  child: Text('保\n' + '存'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(10, 95),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 530,
            child: GestureDetector(
              onLongPress: () {},
              child: Obx(
                () => ReorderableListView(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    for (int index = 0; index < urls.length; index++)
                      Slidable(
                        key: Key('$index'),
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: GestureDetector(
                          onLongPress: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 320,
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(bottom: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                child: const Text('金利'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: const StadiumBorder(),
                                                ),
                                                onPressed: () {
                                                  //ここにタグの表示非表示切り替え処理を書く
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text('日経平均'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: const StadiumBorder(),
                                                ),
                                                onPressed: () {},
                                              ),
                                              ElevatedButton(
                                                child: const Text('米国株'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: const StadiumBorder(),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            child: Text('Close BottomSheet'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: 380,
                                  child: SimpleUrlPreview(
                                    url: urls[index].url,
                                    bgColor: Colors.white,
                                    titleLines: 1,
                                    descriptionLines: 2,
                                    imageLoaderColor: Colors.white,
                                    previewHeight: 150,
                                    previewContainerPadding: EdgeInsets.all(5),
                                    onTap: () {
                                      // Get.to(WebContentPage());
                                    },
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    descriptionStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    siteNameStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                ReorderableDragStartListener(
                                  index: index,
                                  child: const Icon(Icons.drag_handle),
                                ),
                              ],
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              // wc.records[index].hide = true;
                              // setState(() {
                              //   todayData[index].hide = true;
                              // },
                              // );
                            },
                          ),
                        ],
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    // final int item = items.removeAt(oldIndex);//元のコード
                    // urls.value = urls..removeAt(oldIndex); //山村さんのコード
                    final int item = items.removeAt(oldIndex); //試してみる

                    // items.value = items..insert(newIndex, item);//元のコード
                    // urls.value = urls
                    //   ..insert(newIndex, urls[oldIndex]); //山村さんのコード
                    items.insert(newIndex, item); //自分のコード

                    //ここがリストが入れ替わらないエラーの原因かも
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MemoPage extends StatefulWidget {
//   MemoPage(this.passedValue);
//   final List<Record> passedValue;
//   DateTime now = DateTime.now();
//   DateFormat outputFormat = DateFormat('yyyy-MM-dd');
//
//   @override
//   State<MemoPage> createState() => MemoPageState();
// }
//
// class MemoPageState extends State<MemoPage> {
//   // List<String> todayUrls = <String>[];
//   // List<String> day = <String>[];
//
//   List<int> _items = List<int>.generate(100, (int index) => index);
//
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   int _selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     // final urls = widget.passedValue.map((element) => (element.url)).toList();
//     final days = widget.passedValue.map((element) => (element.day)).toList();
//     final now = widget.now;
//     String date = widget.outputFormat.format(now);
//     var todayData = widget.passedValue
//         .where((el) => el.day == date && el.hide == false)
//         .toList();
//     var todayUrls = todayData.map((element) => (element.url)).toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${date}'),
//       ),
//
//       body: Column(
//         children: [
//           TextField(
//             keyboardType: TextInputType.multiline,
//             maxLines: null,
//           ),
//           GestureDetector(
//             onLongPress: () {},
//             child: ReorderableListView(
//               padding: const EdgeInsets.symmetric(horizontal: 0),
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               children: <Widget>[
//                 for (int index = 0; index < todayUrls.length; index++)
//                   Slidable(
//                     key: Key('$index'),
//                     actionPane: SlidableDrawerActionPane(),
//                     actionExtentRatio: 0.25,
//                     child: GestureDetector(
//                       onLongPress: () {
//                         showModalBottomSheet<void>(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return Container(
//                               height: 320,
//                               color: Colors.white,
//                               child: Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.only(bottom: 30),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           ElevatedButton(
//                                             child: const Text('金利'),
//                                             style: ElevatedButton.styleFrom(
//                                               primary: Colors.white,
//                                               onPrimary: Colors.black,
//                                               shape: const StadiumBorder(),
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                           ElevatedButton(
//                                             child: const Text('日経平均'),
//                                             style: ElevatedButton.styleFrom(
//                                               primary: Colors.white,
//                                               onPrimary: Colors.black,
//                                               shape: const StadiumBorder(),
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                           ElevatedButton(
//                                             child: const Text('米国株'),
//                                             style: ElevatedButton.styleFrom(
//                                               primary: Colors.white,
//                                               onPrimary: Colors.black,
//                                               shape: const StadiumBorder(),
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       child: ElevatedButton(
//                                         child: Text('Close BottomSheet'),
//                                         onPressed: () => Navigator.pop(context),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       child: Container(
//                         height: 150,
//                         width: double.infinity,
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 380,
//                               child: SimpleUrlPreview(
//                                 url: todayUrls[_items[index]],
//                                 bgColor: Colors.white,
//                                 // isClosable: true,
//                                 titleLines: 1,
//                                 descriptionLines: 2,
//                                 imageLoaderColor: Colors.white,
//                                 previewHeight: 150,
//                                 previewContainerPadding: EdgeInsets.all(5),
//                                 onTap: () {
//                                   // print('ccc');
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => WebPage(
//                                               // '${todayUrls[_items[index]]}'
//                                               )));
//                                 },
//                                 titleStyle: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                                 descriptionStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                 ),
//                                 siteNameStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               child: ReorderableDragStartListener(
//                                 index: index,
//                                 child: const Icon(Icons.drag_handle),
//                               ),
//                             ),
//
//                             // Container(
//                             //     width: 10,
//                             //     child: GestureDetector(
//                             //         onTap: () {
//                             //           setState(() {
//                             //             todayData[index].hide = true;
//                             //           });
//                             //         },
//                             //         child: Icon(Icons.delete)))
//                           ],
//                         ),
//                       ),
//                     ),
//                     secondaryActions: <Widget>[
//                       IconSlideAction(
//                         caption: 'Delete',
//                         color: Colors.red,
//                         icon: Icons.delete,
//                         onTap: () {
//                           setState(() {
//                             todayData[index].hide = true;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//               ],
//               onReorder: (int oldIndex, int newIndex) {
//                 setState(() {
//                   if (oldIndex < newIndex) {
//                     newIndex -= 1;
//                   }
//                   final int item = _items.removeAt(oldIndex);
//                   _items.insert(newIndex, item);
//
//                   print(todayUrls);
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print(todayData[0].hide);
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => RecordPage(widget.passedValue)));
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.article_outlined),
//       ),
//     );
//   }
// }

//ここからメモ欄
// class MemoFieldPage extends StatefulWidget {
//   @override
//   State<MemoFieldPage> createState() => MemoFieldPageState();
// }
//
// class MemoFieldPageState extends State<MemoFieldPage> {
//   final myController = TextEditingController();
//   List<String> items = <String>['aaa', 'bbb', 'ccc', 'ddd'];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("メモ入力欄")),
//       body: Column(
//         children: [
//           Center(
//             child: TextField(controller: myController),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 // print(myController.text);
//                 setState(
//                   () {
//                     items.add(myController.text);
//                     myController.clear();
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//               child: Text('保存'))
//         ],
//       ),
//     );
//   }
// }
