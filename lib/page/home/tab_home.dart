import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/grid/grid_item.dart';
import 'package:flutter_template/core/widget/list/article_item.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

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
  List<TagId> _tagIds = [
    TagId(name: '全部', id: 0),
    TagId(name: '原创', id: 5601),
    TagId(name: '网络', id: 5602),
  ];

  @override
  void initState() {
    super.initState();

    _distanceSortConditions.add(SortCondition(name: '回复时间', isSelected: true));
    _distanceSortConditions.add(SortCondition(name: '发布时间', isSelected: false));

    _selectDistanceSortCondition = _distanceSortConditions[0];

    _tabController = TabController(vsync: this, length: _tagIds.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    print(kToolbarHeight);
    return Scaffold(
        body: Stack(
      key: _stackKey,
      children: <Widget>[
        Column(
          children: <Widget>[
            MediaQuery.removePadding(
                context: context,
                //=====自定义tabBar====//
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Row(children: <Widget>[
                    //=====select=====//
                    Container(
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
                          height: kToolbarHeight +
                              MediaQuery.of(context).padding.top,
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
                        )),

                    //=====搜索=====//
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(25)),
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(30)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(20)),
                                width: double.infinity,
                                height: ScreenUtil().setHeight(80),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                                child: Text("请输入帖子名字......",
                                    style: TextStyle(color: Colors.white)))))
                  ]),
                )),

            //=====内容区域=====//
            Expanded(
                child: Container(
                    child: EasyRefresh.custom(
                        header: MaterialHeader(),
                        footer: MaterialFooter(),
                        onRefresh: () async {
                          await Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _count = 5;
                            });
                          });
                        },
                        onLoad: () async {
                          await Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _count += 5;
                            });
                          });
                        },
                        slivers: <Widget>[
                  //=====轮播图=====//
                  SliverToBoxAdapter(child: getBannerWidget()),

                  //=====tab菜单=====//
                  initSliverPersistentHeader(
                      tabController: _tabController, tagIds: _tagIds),

                  //=====ListView=====//
                  // SliverList(
                  //   delegate: SliverChildBuilderDelegate(
                  //     (context, index) {
                  //       print(index);
                  //       ArticleInfo info = articles[index % 5];
                  //       return ArticleListItem(
                  //           articleUrl: info.articleUrl,
                  //           imageUrl: info.imageUrl,
                  //           title: info.title,
                  //           author: info.author,
                  //           description: info.description,
                  //           summary: info.summary);
                  //     },
                  //     childCount: _count,
                  //   ),
                  // ),

                  // SliverFillRemaining(
                  //     child: TabBarView(
                  //         controller: _tabController,
                  //         children: _tagIds
                  //             .map((e) => ListView.builder(
                  //                   itemCount: articles.length,
                  //                   itemBuilder: (context, index) {
                  //                     var info = articles[index];
                  //                     return ArticleListItem(
                  //                         articleUrl: info.articleUrl,
                  //                         imageUrl: info.imageUrl,
                  //                         title: info.title,
                  //                         author: info.author,
                  //                         description: info.description,
                  //                         summary: info.summary);
                  //                   },
                  //                 ))
                  //             .toList()))

                  // SliverToBoxAdapter(
                  //     child: Container(
                  //         color: Colors.purple,
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 200,
                  //         child: TabBarView(
                  //             controller: _tabController,
                  //             children: _tagIds
                  //                 .map((e) => Center(
                  //                         child: Text(
                  //                       e.name,
                  //                       style: TextStyle(
                  //                           color: Colors.white, fontSize: 20),
                  //                     )))
                  //                 .toList())))

                  // TabBarView(
                  //     controller: _tabController,
                  //     children: _tagIds
                  //         .map((e) => Center(
                  //                 child: Text(
                  //               e.name,
                  //               style: TextStyle(
                  //                   color: Colors.white, fontSize: 20),
                  //             )))
                  //         .toList())

                  // NestedScrollViewInnerScrollPositionKeyWidget(
                  //     widget.tabKey,
                  //     ListView.builder(
                  //         itemBuilder: (c, i) {
                  //           return Container(
                  //             alignment: Alignment.center,
                  //             height: 60.0,
                  //             child: Text(": List$i"),
                  //           );
                  //         },
                  //         itemCount: 100)
                  // );
                ]))),
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

  //这里是演示，所以写死
  final List<String> urls = [
    "http://photocdn.sohu.com/tvmobilemvms/20150907/144160323071011277.jpg", //伪装者:胡歌演绎"痞子特工"
    "http://photocdn.sohu.com/tvmobilemvms/20150907/144158380433341332.jpg", //无心法师:生死离别!月牙遭虐杀
    "http://photocdn.sohu.com/tvmobilemvms/20150907/144160286644953923.jpg", //花千骨:尊上沦为花千骨
    "http://photocdn.sohu.com/tvmobilemvms/20150902/144115156939164801.jpg", //综艺饭:胖轩偷看夏天洗澡掀波澜
    "http://photocdn.sohu.com/tvmobilemvms/20150907/144159406950245847.jpg", //碟中谍4:阿汤哥高塔命悬一线,超越不可能
  ];

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
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    urls[index],
                  ),
                )),
          );
        },
        onTap: (value) {
          ToastUtils.toast("点击--->" + value.toString());
        },
        itemCount: urls.length,
        pagination: SwiperPagination(),
      ),
    );
  }

  //这里是演示，所以写死
  final List<ArticleInfo> articles = [
    ArticleInfo(
        'https://juejin.im/post/5c3ed1dae51d4543805ea48d',
        'https://user-gold-cdn.xitu.io/2019/1/16/1685563ae5456408?imageView2/0/w/1280/h/960/format/webp/ignore-error/1',
        'XUI 一个简洁而优雅的Android原生UI框架，解放你的双手',
        '涵盖绝大部分的UI组件：TextView、Button、EditText、ImageView、Spinner、Picker、Dialog、PopupWindow、ProgressBar、LoadingView、StateLayout、FlowLayout、Switch、Actionbar、TabBar、Banner、GuideView、BadgeView、MarqueeView、WebView、SearchView等一系列的组件和丰富多彩的样式主题。'),
    ArticleInfo(
        'https://juejin.im/post/5b480b79e51d45190905ef44',
        'https://user-gold-cdn.xitu.io/2018/7/13/16492d9b7877dc21?imageView2/0/w/1280/h/960/format/webp/ignore-error/11',
        'XUpdate 一个轻量级、高可用性的Android版本更新框架',
        'XUpdate 一个轻量级、高可用性的Android版本更新框架。本框架借鉴了AppUpdate中的部分思想和UI界面，将版本更新中的各部分环节抽离出来，形成了如下几个部分：'),
    ArticleInfo(
        'https://juejin.im/post/5b480b79e51d45190905ef44',
        'https://user-gold-cdn.xitu.io/2018/8/9/1651c568a7e30e02?imageView2/0/w/1280/h/960/format/webp/ignore-error/1',
        'XHttp2 一个功能强悍的网络请求库，使用RxJava2 + Retrofit2 + OKHttp进行组装',
        '一个功能强悍的网络请求库，使用RxJava2 + Retrofit2 + OKHttp组合进行封装。还不赶紧点击使用说明文档，体验一下吧！'),
    ArticleInfo(
        'https://juejin.im/post/5d431825e51d45620611599a',
        'https://user-gold-cdn.xitu.io/2019/8/2/16c4e164ec90978f?imageslim',
        '你真的会使用github吗？',
        'github作为全球最大的开源软件托管平台，自2008年上线以来，一直吸引了无数的程序开发者在上面开源分享自己的项目代码。尤其是在微软收购github之后，更是吸引了很多非程序开发者将自己的知识和经验通过平台分享出来，可以说github是一个蕴藏了无数价值和宝藏的大宝库。然而，对于这样一个极具价值的平台，你真的会使用吗？'),
    ArticleInfo(
        'https://juejin.im/post/5e39a1b8518825497467e4ec',
        'https://pic4.zhimg.com/v2-1236d741cbb3aabf5a9910a5e4b73e4c_1200x500.jpg',
        'Flutter学习指南App,一起来玩Flutter吧~',
        'Flutter是谷歌的移动UI框架，可以快速在iOS、Android、Web和PC上构建高质量的原生用户界面。 Flutter可以与现有的代码一起工作。在全世界，Flutter正在被越来越多的开发者和组织使用，并且Flutter是完全免费、开源的。同时它也是构建未来的Google Fuchsia应用的主要方式。'),
  ];
}

initSliverPersistentHeader({TabController tabController, List<TagId> tagIds}) {
  return SliverPersistentHeader(
      //是否固定头布局 默认false
      pinned: true,
      //是否浮动 默认false
      floating: false,
      //必传参数,头布局内容
      delegate: MySliverDelegate(
        //缩小后的布局高度
        minHeight: 60.0,
        //展开后的高度
        maxHeight: 60.0,
        child: Container(
            color: Colors.white,
            child: TabBar(
              onTap: (tab) {
                print(tab);
              },
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              isScrollable: true,
              controller: tabController,
              labelColor: Colors.blue,
              indicatorWeight: 3,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: tagIds
                  .map((e) => Container(
                      width: ScreenUtil().setWidth(190),
                      alignment: Alignment.center,
                      child: Tab(
                        text: e.name,
                      )))
                  .toList(),
            )),
      ));
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override //是否需要重建
  bool shouldRebuild(MySliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
