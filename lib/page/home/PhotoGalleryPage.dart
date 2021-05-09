import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotpGalleryPage extends StatefulWidget {
  final List photoList;
  final int index;
  PhotpGalleryPage({this.photoList, this.index});
  @override
  _PhotpGalleryPageState createState() => _PhotpGalleryPageState();
}

class _PhotpGalleryPageState extends State<PhotpGalleryPage> {
  @override
  int currentIndex = 0;
  int initialIndex; //初始index
  int length;
  int title;
  @override
  void initState() {
    currentIndex = widget.index;
    initialIndex = widget.index;
    length = widget.photoList.length;
    title = initialIndex + 1;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      title = index + 1;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('${title} / ${length}'),
      //   centerTitle: true,
      // ),
      appBar: PreferredSize(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black, Colors.black])),
            child: SafeArea(
                child: Container(
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setHeight(100),
              padding: EdgeInsets.only(left: 20, right: 14),
              // decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.chevron_left,
                          color: Colors.white, size: ScreenUtil().setSp(40)),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    width: ScreenUtil().setWidth(750),
                    alignment: Alignment.center,
                    child: Text(
                      '${title} / ${length}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )),
          ),
          preferredSize: Size(double.infinity, 60)),
      body: InkWell(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollDirection: Axis.horizontal,
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          NetworkImage(widget.photoList[index]['url']),
                      initialScale: PhotoViewComputedScale.contained * 1,
                      heroAttributes: PhotoViewHeroAttributes(
                          tag: widget.photoList[index]['imgId']),
                    );
                  },
                  itemCount: widget.photoList.length,
                  // loadingChild: widget.loadingChild,
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  pageController:
                      PageController(initialPage: initialIndex), //点进去哪页默认就显示哪一页
                  onPageChanged: onPageChanged,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  // child: Text(
                  //   "Image ${currentIndex + 1}",
                  //   style: const TextStyle(
                  //       color: Colors.white, fontSize: 17.0, decoration: null),
                  // ),
                )
              ],
            )),
        onTap: () {
          // Navigator.pop(context);
        },
      ),
    );
  }
}
