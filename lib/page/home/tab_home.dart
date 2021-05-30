import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/core/widget/list/no_image_item.dart';
import 'package:tutu/core/widget/list/one_image_item.dart';
import 'package:tutu/core/widget/list/sample_list_item.dart';
import 'package:tutu/core/widget/list/three_image_item.dart';
import 'package:tutu/models/posts_list_model.dart';
import 'package:tutu/router/route_map.gr.dart';
import 'package:tutu/router/router.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

/**
    1. 布局 Scaffold( Stack(  [ Column(  )  GZXDropDownMenu()]  ) )
    2. Column( Container(自定义tabBar) , Expanded(内容区域) )
    3. 参考布局
    3.1 https://github.com/xuelongqy/flutter_easyrefresh/blob/v2/example/lib/page/sample/nested_scroll_view.dart
    3.2 https://github.com/fluttercandies/extended_nested_scroll_view/blob/master/example/lib/pages/simple/dynamic_pinned_header_height.dart
    4. 主要使用了三个插件
    4.1 gzx_dropdown_menu : 下拉菜单
    4.2 flutter_easyrefresh : 下拉刷新
    4.3 extended_nested_scroll_view : 解决在CustomScrollView中使用tabBar和TabBarView的问题
 */

class SortCondition {
  String name;
  bool isSelected;
  final int sort_by;

  SortCondition({this.name, this.isSelected, this.sort_by});
}

class TagId {
  String name;
  int id;

  TagId({
    this.name,
    this.id,
  });
}

class CarouselMapData {
  final int postID;
  final String url;
  CarouselMapData({this.postID, this.url});
}

class PostsQueryForm {
  final int limit;
  int page;
  int tag_id;
  PostsQueryForm({this.limit = 10, this.page, this.tag_id});
}

class TabHomePage extends StatefulWidget {
  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage>
    with TickerProviderStateMixin {
  int _count = 5;
  List<String> _dropDownHeaderItemStrings = ['回复时间'];
  List<SortCondition> _distanceSortConditions = [];
  SortCondition _selectDistanceSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();
  GlobalKey _stackKey = GlobalKey();
  String _dropdownMenuChange = '';
  TabController _tabController;

  ///全部
  static const int TAB_ID_ARR = 0;

  ///原创
  static const int TAB_ID_ORIGINAL = 5601;

  ///网络
  static const int TAB_ID_NETWORK = 5602;
  List<TagId> _tagIds = [
    TagId(name: '全部', id: TAB_ID_ARR),
    TagId(name: '原创', id: TAB_ID_ORIGINAL),
    TagId(name: '网络', id: TAB_ID_NETWORK),
  ];
  ScrollController sc = ScrollController();

  // 轮播图数据
  List<CarouselMapData> urls = [
    CarouselMapData(
        postID: 0,
        url:
            'http://cdn.u1.huluxia.com/g4/M01/80/BB/rBAAdmCYBbyAGIBWAACnLvVEMuE283.jpg')
  ];

  // 全部列表数据
  PostsListModel postsListModelArrData;
  int pageArr = 1;

  // 原创数据
  PostsListModel postsListModelOriginalData;
  int originalArr = 1;

  // 网络数据
  PostsListModel postsListModelNetworkData;
  int networkArr = 1;

  // queryForm
  Map<int, PostsQueryForm> queryForm = {};
  // active appBarSelect
  SortCondition activeSortCondition;

  // 加载控制器
  EasyRefreshController _controller0;
  // 加载控制器
  EasyRefreshController _controller1;
  // 加载控制器
  EasyRefreshController _controller2;

  // 第一次加载
  bool _firstRefresh0 = true;
  bool _firstRefresh1 = true;
  bool _firstRefresh2 = true;

  @override
  void initState() {
    super.initState();

    _distanceSortConditions
        .add(SortCondition(name: '回复时间', isSelected: true, sort_by: 0));
    _distanceSortConditions
        .add(SortCondition(name: '发布时间', isSelected: false, sort_by: 1));

    _selectDistanceSortCondition = _distanceSortConditions[0];

    _tabController = TabController(vsync: this, length: _tagIds.length);

    activeSortCondition = _distanceSortConditions[0];

    _controller0 = EasyRefreshController();
    _controller1 = EasyRefreshController();
    _controller2 = EasyRefreshController();

    queryForm[0] = PostsQueryForm(page: pageArr, tag_id: TAB_ID_ARR);
    queryForm[1] = PostsQueryForm(page: originalArr, tag_id: TAB_ID_ORIGINAL);
    queryForm[2] = PostsQueryForm(page: networkArr, tag_id: TAB_ID_NETWORK);

    // _getPostsList(TAB_ID_ARR, pageArr);
    // _getPostsList(TAB_ID_ORIGINAL, originalArr);
    // _getPostsList(TAB_ID_NETWORK, networkArr);
    _initData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    sc.dispose();
    super.dispose();
  }

  Future _getPostsList({int tag_id, isBuild = true}) async {
    PostsQueryForm _queryForm = queryForm[_tabController.index];
    final response = await XHttp.postJson(NWApi.postslist, {
      "limit": 10,
      "page": _queryForm.page,
      "tag_id": tag_id != null ? tag_id : _queryForm.tag_id,
      "sort_by": activeSortCondition.sort_by
    });
    PostsListModel res = PostsListModel.fromJson(response);
    if (res.code == 200) {
      switch (tag_id != null ? tag_id : _queryForm.tag_id) {
        case TAB_ID_ARR:
          if (postsListModelArrData != null && _queryForm.page != 1) {
            var _data = postsListModelArrData;
            _data.data.addAll(res.data);
            res = _data;
          }
          postsListModelArrData = res;
          if (isBuild) {
            setState(() {
              postsListModelArrData = res;
            });
          }
          break;
        case TAB_ID_ORIGINAL:
          if (postsListModelOriginalData != null && _queryForm.page != 1) {
            var _data = postsListModelOriginalData;
            _data.data.addAll(res.data);
            res = _data;
          }
          postsListModelOriginalData = res;
          if (isBuild) {
            setState(() {
              postsListModelOriginalData = res;
            });
          }
          break;
        case TAB_ID_NETWORK:
          if (postsListModelNetworkData != null && _queryForm.page != 1) {
            var _data = postsListModelNetworkData;
            _data.data.addAll(res.data);
            res = _data;
          }
          postsListModelNetworkData = res;
          if (isBuild) {
            setState(() {
              postsListModelNetworkData = res;
            });
          }
          break;
      }
    }
    return true;
  }

  Future _getArticleCarouselMap() async {
    final response = await XHttp.get(
      NWApi.getArticleCarouselMap,
    );
    PostsListModel res = PostsListModel.fromJson(response);
    List<CarouselMapData> _urls = res.data?.map((b) {
      print(b.images);
      return CarouselMapData(url: b.images[0].url, postID: b.postId);
    }).toList();
    setState(() {
      urls = _urls;
    });
  }

  Future _initData() async {
    // 获取轮播图
    await _getArticleCarouselMap();

    await _getPostsList(tag_id: TAB_ID_ARR, isBuild: false);
    await _getPostsList(tag_id: TAB_ID_ORIGINAL, isBuild: false);
    await _getPostsList(tag_id: TAB_ID_NETWORK, isBuild: false);
    setState(() {
      postsListModelArrData = postsListModelArrData;
      postsListModelOriginalData = postsListModelOriginalData;
      postsListModelNetworkData = postsListModelNetworkData;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print(kToolbarHeight);
    print(_count);
    return Scaffold(
        body: Stack(
      key: _stackKey,
      children: <Widget>[
        Column(
          children: <Widget>[
            //=====自定义tabBar====//
            MediaQuery.removePadding(
                context: context,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //=====下拉选择=====//
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top / 2.5),
                          // color: Colors.grey,
                          alignment: Alignment.center,
                          child: TabHomeTopLeftSelect(
                              dropDownHeaderItemStrings:
                                  _dropDownHeaderItemStrings,
                              stackKey: _stackKey,
                              dropdownMenuController: _dropdownMenuController),
                        ),
                      ),

                      //=====搜索=====//
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top / 2),
                          alignment: Alignment.centerLeft,
                          // color: Colors.green,
                          child: TabHomeTopRightSearch(),
                        ),
                      ),
                    ],
                  ),
                )),

            //=====内容区域=====//
            MediaQuery.removePadding(
                context: context,
                child: Expanded(
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    alignment: Alignment.center,
                    child: extended.NestedScrollView(
                      controller: sc,
                      headerSliverBuilder: (BuildContext c, bool f) =>

                          //=====轮播图=====//
                          [SliverToBoxAdapter(child: getBannerWidget())],
                      // 缩小后的布局高度
                      pinnedHeaderSliverHeightBuilder: () {
                        return 0;
                      },
                      innerScrollPositionKeyBuilder: () {
                        String index = 'Tab';
                        index += _tabController.index.toString();
                        return Key(index);
                      },

                      //=====主体内容=====//
                      body: Column(children: <Widget>[
                        //=====TabBar=====//
                        Container(
                            color: Colors.white,
                            child: TabHomeTabBar(
                                onTap: (int index) async {
                                  print("重新build =>>>>>${index}");
                                  // await _getPostsList();
                                },
                                tabController: _tabController,
                                tagIds: _tagIds)),

                        //=====TabBarView=====//
                        Expanded(
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                              extended
                                  .NestedScrollViewInnerScrollPositionKeyWidget(
                                const Key('Tab0'),
                                EasyRefresh(
                                  enableControlFinishRefresh: true,
                                  enableControlFinishLoad: true,
                                  emptyWidget: postsListModelArrData == null
                                      ? Container(
                                          height: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(),
                                                flex: 2,
                                              ),
                                              SizedBox(
                                                width: 100.0,
                                                height: 100.0,
                                                child: Image.asset(
                                                    'assets/image/nodata.png'),
                                              ),
                                              Text(
                                                '暂无数据',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[400]),
                                              ),
                                              Expanded(
                                                child: SizedBox(),
                                                flex: 3,
                                              ),
                                            ],
                                          ),
                                        )
                                      : null,
                                  firstRefresh: _firstRefresh0,
                                  firstRefreshWidget: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Center(
                                        child: SizedBox(
                                      height: 200.0,
                                      width: 300.0,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: SpinKitFadingCube(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 25.0,
                                              ),
                                            ),
                                            Container(
                                              child: Text("加载中..."),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                                  ),
                                  controller: _controller0,
                                  header: MaterialHeader(),
                                  footer: MaterialFooter(),
                                  onRefresh: () async {
                                    queryForm[0].page = 1;
                                    await _getArticleCarouselMap();
                                    await _getPostsList();
                                    _controller0.finishRefresh(noMore: false);
                                    setState(() {
                                      _firstRefresh0 = false;
                                    });
                                  },
                                  onLoad: () async {
                                    queryForm[0].page = queryForm[0].page + 1;
                                    await _getPostsList();
                                    _controller0.finishLoad(noMore: false);
                                  },
                                  child: ListView.builder(
                                    itemCount: postsListModelArrData != null
                                        ? postsListModelArrData.data.length
                                        : 0,
                                    key: const PageStorageKey<String>('Tab0'),
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var info =
                                          postsListModelArrData.data[index];

                                      int imgLength = info.images.length;
                                      if (imgLength >= 3) {
                                        info.images = info.images.sublist(0, 3);
                                        return ThreeImageItem(
                                            postId: info.postId,
                                            images: info.images
                                                .map((b) => b.url)
                                                .toList(),
                                            title: info.title,
                                            userName: info.user.username,
                                            detail: info.detail,
                                            commentCount: info.commentCount,
                                            hit: info.hit);
                                      } else if (imgLength >= 1) {
                                        return OneImageItem(
                                            postId: info.postId,
                                            images: info.images
                                                .map((b) => b.url)
                                                .toList(),
                                            title: info.title,
                                            userName: info.user.username,
                                            detail: info.detail,
                                            commentCount: info.commentCount,
                                            hit: info.hit);
                                      } else {
                                        return NoImageItem(
                                          postId: info.postId,
                                          images: info.images
                                              .map((b) => b.url)
                                              .toList(),
                                          title: info.title,
                                          userName: info.user.username,
                                          detail: info.detail,
                                          commentCount: info.commentCount,
                                          hit: info.hit,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              extended
                                  .NestedScrollViewInnerScrollPositionKeyWidget(
                                const Key('Tab1'),
                                EasyRefresh(
                                    enableControlFinishRefresh: true,
                                    enableControlFinishLoad: true,
                                    emptyWidget: postsListModelOriginalData ==
                                            null
                                        ? Container(
                                            height: double.infinity,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(),
                                                  flex: 2,
                                                ),
                                                SizedBox(
                                                  width: 100.0,
                                                  height: 100.0,
                                                  child: Image.asset(
                                                      'assets/image/nodata.png'),
                                                ),
                                                Text(
                                                  '暂无数据',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey[400]),
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                  flex: 3,
                                                ),
                                              ],
                                            ),
                                          )
                                        : null,
                                    firstRefresh: _firstRefresh1,
                                    firstRefreshWidget: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Center(
                                          child: SizedBox(
                                        height: 200.0,
                                        width: 300.0,
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: SpinKitFadingCube(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 25.0,
                                                ),
                                              ),
                                              Container(
                                                child: Text("加载中..."),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                    ),
                                    controller: _controller1,
                                    header: MaterialHeader(),
                                    footer: MaterialFooter(),
                                    onRefresh: () async {
                                      queryForm[1].page = 1;
                                      await _getArticleCarouselMap();
                                      await _getPostsList();
                                      _controller1.finishRefresh(noMore: false);
                                      setState(() {
                                        _firstRefresh1 = false;
                                      });
                                    },
                                    onLoad: () async {
                                      queryForm[1].page = queryForm[1].page + 1;
                                      await _getPostsList();
                                      _controller1.finishLoad(noMore: false);
                                    },
                                    child: ListView.builder(
                                      itemCount:
                                          postsListModelOriginalData != null
                                              ? postsListModelOriginalData
                                                  .data.length
                                              : 0,
                                      key: const PageStorageKey<String>('Tab1'),
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var info = postsListModelOriginalData
                                            .data[index];

                                        int imgLength = info.images.length;
                                        if (imgLength >= 3) {
                                          info.images =
                                              info.images.sublist(0, 3);
                                          return ThreeImageItem(
                                              postId: info.postId,
                                              images: info.images
                                                  .map((b) => b.url)
                                                  .toList(),
                                              title: info.title,
                                              userName: info.user.username,
                                              detail: info.detail,
                                              commentCount: info.commentCount,
                                              hit: info.hit);
                                        } else if (imgLength >= 1) {
                                          return OneImageItem(
                                              postId: info.postId,
                                              images: info.images
                                                  .map((b) => b.url)
                                                  .toList(),
                                              title: info.title,
                                              userName: info.user.username,
                                              detail: info.detail,
                                              commentCount: info.commentCount,
                                              hit: info.hit);
                                        } else {
                                          return NoImageItem(
                                            postId: info.postId,
                                            images: info.images
                                                .map((b) => b.url)
                                                .toList(),
                                            title: info.title,
                                            userName: info.user.username,
                                            detail: info.detail,
                                            commentCount: info.commentCount,
                                            hit: info.hit,
                                          );
                                        }
                                      },
                                    )),
                              ),
                              extended
                                  .NestedScrollViewInnerScrollPositionKeyWidget(
                                const Key('Tab2'),
                                EasyRefresh(
                                    enableControlFinishRefresh: true,
                                    enableControlFinishLoad: true,
                                    emptyWidget: postsListModelNetworkData ==
                                            null
                                        ? Container(
                                            height: double.infinity,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(),
                                                  flex: 2,
                                                ),
                                                SizedBox(
                                                  width: 100.0,
                                                  height: 100.0,
                                                  child: Image.asset(
                                                      'assets/image/nodata.png'),
                                                ),
                                                Text(
                                                  '暂无数据',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey[400]),
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                  flex: 3,
                                                ),
                                              ],
                                            ),
                                          )
                                        : null,
                                    firstRefresh: _firstRefresh2,
                                    firstRefreshWidget: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Center(
                                          child: SizedBox(
                                        height: 200.0,
                                        width: 300.0,
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: SpinKitFadingCube(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 25.0,
                                                ),
                                              ),
                                              Container(
                                                child: Text("加载中..."),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                    ),
                                    controller: _controller2,
                                    header: MaterialHeader(),
                                    footer: MaterialFooter(),
                                    onRefresh: () async {
                                      queryForm[2].page = 1;
                                      await _getArticleCarouselMap();
                                      await _getPostsList();
                                      _controller2.finishRefresh(noMore: false);
                                      setState(() {
                                        _firstRefresh2 = false;
                                      });
                                    },
                                    onLoad: () async {
                                      queryForm[2].page = queryForm[2].page + 1;
                                      await _getPostsList();
                                      _controller2.finishLoad(noMore: false);
                                    },
                                    child: ListView.builder(
                                      itemCount:
                                          postsListModelNetworkData != null
                                              ? postsListModelNetworkData
                                                  .data.length
                                              : 0,
                                      key: const PageStorageKey<String>('Tab2'),
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var info = postsListModelNetworkData
                                            .data[index];

                                        int imgLength = info.images.length;
                                        if (imgLength >= 3) {
                                          info.images =
                                              info.images.sublist(0, 3);
                                          return ThreeImageItem(
                                              postId: info.postId,
                                              images: info.images
                                                  .map((b) => b.url)
                                                  .toList(),
                                              title: info.title,
                                              userName: info.user.username,
                                              detail: info.detail,
                                              commentCount: info.commentCount,
                                              hit: info.hit);
                                        } else if (imgLength >= 1) {
                                          return OneImageItem(
                                              postId: info.postId,
                                              images: info.images
                                                  .map((b) => b.url)
                                                  .toList(),
                                              title: info.title,
                                              userName: info.user.username,
                                              detail: info.detail,
                                              commentCount: info.commentCount,
                                              hit: info.hit);
                                        } else {
                                          return NoImageItem(
                                            postId: info.postId,
                                            images: info.images
                                                .map((b) => b.url)
                                                .toList(),
                                            title: info.title,
                                            userName: info.user.username,
                                            detail: info.detail,
                                            commentCount: info.commentCount,
                                            hit: info.hit,
                                          );
                                        }
                                      },
                                    )),
                              )
                            ]))
                      ]),
                    ),
                  ),
                ))
          ],
        ),
        // 下拉菜单
        GZXDropDownMenu(
          // controller用于控制menu的显示或隐藏
          controller: _dropdownMenuController,
          // 下拉菜单显示或隐藏动画时长
          animationMilliseconds: 300,
          // 下拉后遮罩颜色
          //  maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
          //  maskColor: Colors.red.withOpacity(0.5),
          dropdownMenuChanging: (isShow, index) {
            setState(() {
              _dropdownMenuChange = '(正在${isShow ? '显示' : '隐藏'}$index)';
              print(_dropdownMenuChange);
            });
          },
          dropdownMenuChanged: (isShow, index) {
            setState(() {
              _dropdownMenuChange = '(已经${isShow ? '显示' : '隐藏'}$index)';
              print(_dropdownMenuChange);
            });
          },
          // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
          menus: [
            GZXDropdownMenuBuilder(
                dropDownHeight: 40.0 * _distanceSortConditions.length,
                dropDownWidget:
                    _buildConditionListWidget(_distanceSortConditions, (value) {
                  _selectDistanceSortCondition = value;
                  _dropDownHeaderItemStrings[0] =
                      _selectDistanceSortCondition.name;
                  _dropdownMenuController.hide();
                  setState(() {});
                })),
          ],
        ),
      ],
    ));
  }

  /// 下拉面板
  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          // item 的个数
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1.0),
          // 添加分割线
          itemBuilder: (BuildContext context, int index) {
            return gestureDetector(items, index, itemOnTap, context);
          },
        ));
  }

  /// 下拉面板元素
  GestureDetector gestureDetector(items, int index,
      void itemOnTap(SortCondition sortCondition), BuildContext context) {
    SortCondition goodsSortCondition = items[index];
    return GestureDetector(
      onTap: () async {
        for (var value in items) {
          value.isSelected = false;
        }
        goodsSortCondition.isSelected = true;

        itemOnTap(goodsSortCondition);

        // 保存下拉框值
        activeSortCondition = _distanceSortConditions[index];

        // 初始化queryFrom
        queryForm[0] = PostsQueryForm(page: 1, tag_id: TAB_ID_ARR);
        queryForm[1] = PostsQueryForm(page: 1, tag_id: TAB_ID_ORIGINAL);
        queryForm[2] = PostsQueryForm(page: 1, tag_id: TAB_ID_NETWORK);

        // 初始化列表数据
        postsListModelArrData = null;
        postsListModelOriginalData = null;
        postsListModelNetworkData = null;

        await _initData();
      },
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                goodsSortCondition.name,
                style: TextStyle(
                  color: goodsSortCondition.isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
            ),
            goodsSortCondition.isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  )
                : SizedBox(),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// 轮播图
  Widget getBannerWidget() {
    return SizedBox(
      height: 200,
      child: Swiper(
        autoplay: true,
        duration: 2000,
        autoplayDelay: 5000,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.transparent,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    urls[index].url,
                  ),
                )),
          );
        },
        onTap: (value) {
          // ToastUtils.toast("点击--->" +
          //     value.toString() +
          //     '--->' +
          //     urls[value].postID.toString());
          XRouter.push('${Routes.imageDetailed}?postId=${urls[value].postID}');
        },
        itemCount: urls.length,
        pagination: SwiperPagination(),
      ),
    );
  }
}

class TabHomeTabBar extends StatelessWidget {
  final Function onTap;
  const TabHomeTabBar(
      {Key key,
      @required TabController tabController,
      @required List<TagId> tagIds,
      Function this.onTap})
      : _tabController = tabController,
        _tagIds = tagIds,
        super(key: key);

  final TabController _tabController;
  final List<TagId> _tagIds;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) {
        // print(index);
        onTap(index);
      },
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 16),
      isScrollable: true,
      controller: _tabController,
      labelColor: Colors.blue,
      indicatorWeight: 3,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
      unselectedLabelColor: Colors.black,
      indicatorColor: Colors.blue,
      tabs: _tagIds
          .map((e) => Container(
              width: MediaQuery.of(context).size.width / 4.1,
              alignment: Alignment.center,
              child: Tab(
                text: e.name,
              )))
          .toList(),
    );
  }
}

class TabHomeTopRightSearch extends StatelessWidget {
  const TabHomeTopRightSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          XRouter.push(Routes.searchPage);
        },
        child: Container(
            // color: Colors.deepPurpleAccent,
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                width: double.infinity,
                height: MediaQuery.of(context).padding.top +
                    (MediaQuery.of(context).padding.top * 0.1),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.white)),
                child: Text("请输入帖子名字......",
                    style: TextStyle(color: Colors.white)))));
  }
}

class TabHomeTopLeftSelect extends StatelessWidget {
  const TabHomeTopLeftSelect({
    Key key,
    @required List<String> dropDownHeaderItemStrings,
    @required GlobalKey<State<StatefulWidget>> stackKey,
    @required GZXDropdownMenuController dropdownMenuController,
  })  : _dropDownHeaderItemStrings = dropDownHeaderItemStrings,
        _stackKey = stackKey,
        _dropdownMenuController = dropdownMenuController,
        super(key: key);

  final List<String> _dropDownHeaderItemStrings;
  final GlobalKey<State<StatefulWidget>> _stackKey;
  final GZXDropdownMenuController _dropdownMenuController;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(250),
        child: GZXDropDownHeader(
          // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
          items: [
            GZXDropDownHeaderItem(
              _dropDownHeaderItemStrings[0],
              iconData: Icons.keyboard_arrow_down,
              iconDropDownData: Icons.keyboard_arrow_up,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.bold),
            ),
          ],
          // GZXDropDownHeader对应第一父级Stack的key
          stackKey: _stackKey,
          // controller用于控制menu的显示或隐藏
          controller: _dropdownMenuController,
          // 头部的高度
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          // 头部背景颜色
          color: Theme.of(context).primaryColor,
          // 头部边框宽度
          borderWidth: 0.000001,
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.bold),
          // 下拉时文字样式
          dropDownStyle: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // 图标大小
          iconSize: ScreenUtil().setSp(35),
          // 图标颜色
          iconColor: Colors.white,
          // 下拉时图标颜色
          iconDropDownColor: Colors.white,
        ));
  }
}
