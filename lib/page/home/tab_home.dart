import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_template/core/http/baseApi.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/list/one_image_item.dart';
import 'package:flutter_template/core/widget/list/three_image_item.dart';
import 'package:flutter_template/models/posts_list_model.dart';
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

  SortCondition({
    this.name,
    this.isSelected,
  });
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

  @override
  void initState() {
    super.initState();

    _distanceSortConditions.add(SortCondition(name: '回复时间', isSelected: true));
    _distanceSortConditions.add(SortCondition(name: '发布时间', isSelected: false));

    _selectDistanceSortCondition = _distanceSortConditions[0];

    _tabController = TabController(vsync: this, length: _tagIds.length);

    _getArticleCarouselMap();
    _getPostsList(TAB_ID_ARR, pageArr);
    _getPostsList(TAB_ID_ORIGINAL, originalArr);
    _getPostsList(TAB_ID_NETWORK, networkArr);
  }

  @override
  void dispose() {
    _tabController.dispose();
    sc.dispose();
    super.dispose();
  }

  Future _getPostsList(int tagId, int page) async {
    final response = await XHttp.postJson(NWApi.postslist,
        {"limit": 10, "page": page, "tag_id": tagId, "sort_by": ""});
    PostsListModel res = PostsListModel.fromJson(response);
    if (res.code == 200) {
      switch (tagId) {
        case TAB_ID_ARR:
          if (postsListModelArrData != null && page != 1) {
            var _data = postsListModelArrData;
            _data.data.addAll(res.data);
            res = _data;
          }
          setState(() {
            postsListModelArrData = res;
          });
          break;
        case TAB_ID_ORIGINAL:
          if (postsListModelOriginalData != null && page != 1) {
            var _data = postsListModelOriginalData;
            _data.data.addAll(res.data);
            res = _data;
          }
          setState(() {
            postsListModelOriginalData = res;
          });
          break;
        case TAB_ID_NETWORK:
          if (postsListModelNetworkData != null && page != 1) {
            var _data = postsListModelNetworkData;
            _data.data.addAll(res.data);
            res = _data;
          }
          setState(() {
            postsListModelNetworkData = res;
          });
          break;
      }
    }
    return res.data;
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
                  child: Row(children: <Widget>[
                    //=====下拉选择=====//
                    TabHomeTopLeftSelect(
                        dropDownHeaderItemStrings: _dropDownHeaderItemStrings,
                        stackKey: _stackKey,
                        dropdownMenuController: _dropdownMenuController),

                    //=====搜索=====//
                    TabHomeTopRightSearch()
                  ]),
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
                                    header: MaterialHeader(),
                                    footer: MaterialFooter(),
                                    onRefresh: () async {
                                      pageArr = 1;
                                      await _getPostsList(TAB_ID_ARR, 1);
                                    },
                                    onLoad: () async {
                                      pageArr = pageArr + 1;
                                      await _getPostsList(TAB_ID_ARR, pageArr);
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
                                          return Container();
                                        }
                                      },
                                    )),
                              ),
                              extended
                                  .NestedScrollViewInnerScrollPositionKeyWidget(
                                const Key('Tab1'),
                                EasyRefresh(
                                    header: MaterialHeader(),
                                    footer: MaterialFooter(),
                                    onRefresh: () async {
                                      originalArr = 1;
                                      await _getPostsList(TAB_ID_ORIGINAL, 1);
                                    },
                                    onLoad: () async {
                                      originalArr = originalArr + 1;
                                      await _getPostsList(
                                          TAB_ID_ORIGINAL, originalArr);
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
                                              postId: index,
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
                                              postId: index,
                                              images: info.images
                                                  .map((b) => b.url)
                                                  .toList(),
                                              title: info.title,
                                              userName: info.user.username,
                                              detail: info.detail,
                                              commentCount: info.commentCount,
                                              hit: info.hit);
                                        } else {
                                          return Container();
                                        }
                                      },
                                    )),
                              ),
                              extended
                                  .NestedScrollViewInnerScrollPositionKeyWidget(
                                const Key('Tab2'),
                                EasyRefresh(
                                    header: MaterialHeader(),
                                    footer: MaterialFooter(),
                                    onRefresh: () async {
                                      networkArr = 1;
                                      await _getPostsList(TAB_ID_NETWORK, 1);
                                    },
                                    onLoad: () async {
                                      networkArr = networkArr + 1;
                                      await _getPostsList(
                                          TAB_ID_NETWORK, networkArr);
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
                                              postId: index,
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
                                              postId: index,
                                              images: info.images
                                                  .map((b) => b.url)
                                                  .toList(),
                                              title: info.title,
                                              userName: info.user.username,
                                              detail: info.detail,
                                              commentCount: info.commentCount,
                                              hit: info.hit);
                                        } else {
                                          return Container();
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
      onTap: () {
        for (var value in items) {
          value.isSelected = false;
        }
        goodsSortCondition.isSelected = true;

        itemOnTap(goodsSortCondition);
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
          ToastUtils.toast("点击--->" +
              value.toString() +
              '--->' +
              urls[value].postID.toString());
        },
        itemCount: urls.length,
        pagination: SwiperPagination(),
      ),
    );
  }
}

class TabHomeTabBar extends StatelessWidget {
  const TabHomeTabBar({
    Key key,
    @required TabController tabController,
    @required List<TagId> tagIds,
  })  : _tabController = tabController,
        _tagIds = tagIds,
        super(key: key);

  final TabController _tabController;
  final List<TagId> _tagIds;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) {
        print(index);
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
    return Expanded(
        child: Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                width: double.infinity,
                height: ScreenUtil().setHeight(80),
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
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(120),
        // color: Colors.cyanAccent,
        child: GZXDropDownHeader(
          // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
          items: [
            GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0],
                iconData: Icons.keyboard_arrow_down,
                iconDropDownData: Icons.keyboard_arrow_up,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(35),
                    fontWeight: FontWeight.bold)),
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
