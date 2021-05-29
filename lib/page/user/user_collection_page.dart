/// 我的点赞

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/core/widget/list/no_image_item.dart';
import 'package:tutu/core/widget/list/one_image_item.dart';
import 'package:tutu/core/widget/list/three_image_item.dart';
import 'package:tutu/core/widget/loading_dialog.dart';
import 'package:tutu/models/posts_praise_error_model.dart';
import 'package:tutu/models/query_collection_list_model.dart';
import 'package:tutu/utils/sputils.dart';

class PostsCollectionListtQueryForm {
  final int limit;
  int page;
  int userId;
  PostsCollectionListtQueryForm({this.limit = 10, this.page, this.userId});
}

class ChcekCollectionItem {
  Datum data;
  bool isStatus;
  ChcekCollectionItem({this.data, this.isStatus = false});
}

class PostsCollectionDeleteArrStatus {
  static int arr = 1;
}

class PostsCollectionQueryForm {
  int userId;
  List<int> praiseIds = [];
  int arrDelete;
  PostsCollectionQueryForm({this.userId, this.praiseIds, this.arrDelete});
}

class UserCollectionPage extends StatefulWidget {
  @override
  _UserCollectionPageState createState() => _UserCollectionPageState();
}

class _UserCollectionPageState extends State<UserCollectionPage> {
  // 加载控制器
  EasyRefreshController _controller;

  // 编辑状态
  bool isUpdateStatus = false;

  // 全选状态
  bool isAllStatus = false;

  PostsCollectionListtQueryForm queryForm;

  List<ChcekCollectionItem> chcekCollectionItem;

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
        "我的喜欢",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(!isUpdateStatus ? "编辑" : '取消'),
            onPressed: () {
              _handerCloseEditButtonClick();
            }),
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
            _handerDeleteHistoryArrItemClick();
            Navigator.of(context).pop();
          }),
        ),
      );

  Widget _searchSliverList() {
    return chcekCollectionItem != null
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var info = chcekCollectionItem[index];
                int imgLength = info.data.posts.images.length;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        margin:
                            isUpdateStatus ? EdgeInsets.only(left: 50) : null,
                        child: _item(
                          imgLength: imgLength,
                          info: info.data.posts,
                        ),
                      ),
                      //  增加了Positioned.fill 可以让Contentr 自动填充整个Stack
                      isUpdateStatus
                          ? Positioned.fill(
                              child: InkWell(
                                onTap: () {
                                  _handerHistoryItemChange(index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox(
                                    value: info.isStatus,
                                    onChanged: (bool value) {
                                      _handerHistoryItemChange(index);
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
              childCount: chcekCollectionItem.length,
            ),
          )
        : SliverToBoxAdapter();
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

  Future _queryHistoryListApi({bool refresh = false}) async {
    try {
      final response = await XHttp.postJson(
          NWApi.postsQueryUserCollectionList, {
        "limit": 10,
        "page": queryForm.page,
        "userId": SPUtils.getUserInfo().data.userId
      });
      QueryCollectionListModel res =
          QueryCollectionListModel.fromJson(response);

      List<ChcekCollectionItem> _chcekCollectionItem = res.data.map((Datum b) {
        return ChcekCollectionItem(data: b, isStatus: isAllStatus);
      }).toList();

      if (refresh) {
        setState(() {
          chcekCollectionItem = _chcekCollectionItem;
        });
      }

      if (_chcekCollectionItem.length != 0) {
        if (chcekCollectionItem != null) {
          var chcekCollectionItemCopy = chcekCollectionItem;
          chcekCollectionItemCopy.addAll(_chcekCollectionItem);
          setState(() {
            chcekCollectionItem = chcekCollectionItemCopy;
          });
        } else {
          setState(() {
            chcekCollectionItem = _chcekCollectionItem;
          });
        }
      }
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
      return false;
    } finally {
      return true;
    }
  }

  /// 全选change事件
  void _handerAllStatusButtonChanged() {
    isAllStatus = !isAllStatus;

    chcekCollectionItem = chcekCollectionItem.map((ChcekCollectionItem b) {
      b.isStatus = isAllStatus;
      return b;
    }).toList();

    setState(() {
      isAllStatus = isAllStatus;
      chcekCollectionItem = chcekCollectionItem;
    });
  }

  /// 全选删除click
  Future _handerDeleteHistoryItemClick() async {
    List<ChcekCollectionItem> _chcekCollectionItem =
        chcekCollectionItem.where((ChcekCollectionItem b) {
      return b.isStatus == true;
    }).toList();

    List<int> praiseIds = _chcekCollectionItem
        .map((ChcekCollectionItem e) => e.data.praiseId)
        .toList();

    PostsCollectionQueryForm queryForm = PostsCollectionQueryForm(
      userId: SPUtils.getUserInfo().data.userId,
      praiseIds: praiseIds,
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: Colors.black38,
            loadingView: SpinKitCircle(color: Colors.white),
          );
        });
    try {
      await XHttp.postJson(NWApi.postsDeleteCollection, {
        "userId": queryForm.userId,
        "praiseIds": praiseIds,
      });
      _refresh();
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
      return false;
    } finally {
      Navigator.pop(context);
      return true;
    }
  }

  /// 确定清楚全部
  Future _handerDeleteHistoryArrItemClick() async {
    PostsCollectionQueryForm queryForm = PostsCollectionQueryForm(
      userId: SPUtils.getUserInfo().data.userId,
      arrDelete: PostsCollectionDeleteArrStatus.arr,
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: Colors.black38,
            loadingView: SpinKitCircle(color: Colors.white),
          );
        });
    try {
      await XHttp.postJson(NWApi.postsDeleteCollection, {
        "userId": queryForm.userId,
        "arrDelete": queryForm.arrDelete,
      });
      _refresh();
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
      return false;
    } finally {
      Navigator.pop(context);
      return true;
    }
  }

  /// 编辑/取消编辑 click
  void _handerCloseEditButtonClick() {
    isUpdateStatus = !isUpdateStatus;

    List<ChcekCollectionItem> _chcekCollectionItem = chcekCollectionItem;
    if (!isUpdateStatus) {
      _chcekCollectionItem = chcekCollectionItem.map((ChcekCollectionItem b) {
        b.isStatus = isUpdateStatus;
        return b;
      }).toList();
    }

    setState(() {
      isUpdateStatus = isUpdateStatus;
      chcekCollectionItem = _chcekCollectionItem;
    });
  }

  /// 历史记录change事件
  void _handerHistoryItemChange(int index) {
    chcekCollectionItem[index].isStatus = !chcekCollectionItem[index].isStatus;

    List<ChcekCollectionItem> activeChcekCollectionItems =
        chcekCollectionItem.where((ChcekCollectionItem b) {
      return b.isStatus;
    }).toList();

    setState(() {
      isAllStatus =
          activeChcekCollectionItems.length == chcekCollectionItem.length;
      chcekCollectionItem[index].isStatus = chcekCollectionItem[index].isStatus;
    });
  }

  /// 历史记录重新刷新
  Future _refresh() async {
    queryForm.page = 1;
    chcekCollectionItem = null;
    await _queryHistoryListApi(refresh: true);
    _controller.finishRefresh(noMore: true);
    return true;
  }

  @override
  void initState() {
    super.initState();

    _controller = EasyRefreshController();

    queryForm = PostsCollectionListtQueryForm(
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
                child: Stack(
                  children: <Widget>[
                    /// 历史记录
                    EasyRefresh(
                      enableControlFinishRefresh: true,
                      enableControlFinishLoad: true,
                      controller: _controller,
                      header: MaterialHeader(),
                      footer: MaterialFooter(),
                      onLoad: () async {
                        queryForm.page = queryForm.page + 1;
                        await _queryHistoryListApi();
                        _controller.finishLoad(noMore: true);
                      },
                      onRefresh: () async {
                        await _refresh();
                      },
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: <Widget>[
                          _searchSliverList(),
                        ],
                      ),
                    ),

                    /// 底部全选
                    isUpdateStatus
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: isAllStatus,
                                          onChanged: (bool value) {
                                            _handerAllStatusButtonChanged();
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _handerAllStatusButtonChanged();
                                          },
                                          child: Text("全选"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    child: Text("删除"),
                                    onPressed: () {
                                      _handerDeleteHistoryItemClick();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
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
