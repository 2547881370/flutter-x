/// 浏览记录
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/core/widget/list/no_image_item.dart';
import 'package:tutu/core/widget/list/one_image_item.dart';
import 'package:tutu/core/widget/list/three_image_item.dart';
import 'package:tutu/models/posts_praise_error_model.dart';
import 'package:tutu/models/query_history_list_model.dart';
import 'package:tutu/utils/sputils.dart';

class PostsHistoryListtQueryForm {
  final int limit;
  int page;
  int userId;
  PostsHistoryListtQueryForm({this.limit = 10, this.page, this.userId});
}

class UserHistoryPage extends StatefulWidget {
  @override
  _UserHistoryPageState createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  bool _value = false;

  // 编辑状态
  bool isUpdateStatus = false;

  // 全选状态
  bool isAllStatus = false;

  PostsHistoryListtQueryForm queryForm;
  QueryHistoryListModel _data;

  Widget _myAppBar() {
    return AppBar(
      elevation: 0.0, //去掉阴影效果
      backgroundColor: Colors.white,
      leading: IconButton(
        color: Colors.black,
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "浏览记录",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
      actions: <Widget>[
        TextButton(child: Text("编辑"), onPressed: () {}),
        TextButton(
            child: Text("清空"),
            onPressed: () {
              showDialog(context: context, builder: (ctx) => _buildDialog());
            }),
      ],
    );
  }

  Widget _buildDialog() => Dialog(
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          width: 50,
          child: DeleteDialog(submitCallback: () {
            print("确定清楚");
            Navigator.of(context).pop();
          }),
        ),
      );

  Widget _searchSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var info = _data.data[index];
          int imgLength = info.posts.images.length;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.blue,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: _item(imgLength: imgLength, info: info.posts),
                ),
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       _value = !_value;
                //     });
                //   },
                //   child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 10),
                //       alignment: Alignment.centerLeft,
                //       color: Colors.green,
                //       child: Checkbox(
                //         value: _value,
                //         onChanged: (bool value) {
                //           setState(() {
                //             _value = value;
                //           });
                //         },
                //       )),
                // ),
              ],
            ),
          );
        },
        childCount: _data?.data?.length,
      ),
    );
  }

  Widget _item({int imgLength, Posts info}) {
    if (imgLength >= 3) {
      info.images = info.images.sublist(0, 3);
      return ThreeImageItem(
          postId: info.postId,
          images: info.images.map((b) => b.url).toList(),
          title: info.title,
          userName: info.user.username,
          detail: info.detail,
          commentCount: info.commentCount,
          hit: info.hit);
    } else if (imgLength >= 1) {
      return OneImageItem(
          postId: info.postId,
          images: info.images.map((b) => b.url).toList(),
          title: info.title,
          userName: info.user.username,
          detail: info.detail,
          commentCount: info.commentCount,
          hit: info.hit);
    } else {
      return NoImageItem(
        postId: info.postId,
        images: info.images.map((b) => b.url).toList(),
        title: info.title,
        userName: info.user.username,
        detail: info.detail,
        commentCount: info.commentCount,
        hit: info.hit,
      );
    }
  }

  Future _queryHistoryListApi() async {
    try {
      final response = await XHttp.postJson(NWApi.queryHistoryList, {
        "limit": 10,
        "page": queryForm.page,
        "userId": SPUtils.getUserInfo().data.userId
      });
      QueryHistoryListModel res = QueryHistoryListModel.fromJson(response);
      setState(() {
        _data = res;
      });
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
      return false;
    } finally {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();

    queryForm = PostsHistoryListtQueryForm(
      page: 1,
    );

    _queryHistoryListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  child: EasyRefresh(
                footer: MaterialFooter(),
                onLoad: () async {
                  // queryForm.page = queryForm.page + 1;
                  // return await _getPostsList();
                },
                child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      _searchSliverList(),
                    ]),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final Function submitCallback;

  const DeleteDialog({Key key, this.submitCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildBar(context),
          _buildContent(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        ' 您确定删除所有浏览记录吗?',
        style: TextStyle(color: Colors.black, fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildFooter(context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15.0, top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
              onTap: submitCallback,
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.green),
                child: Text('确定',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.orangeAccent),
              child: Text('取消',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  _buildBar(context) => Container(
        height: 30,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 10, top: 5),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      );
}
