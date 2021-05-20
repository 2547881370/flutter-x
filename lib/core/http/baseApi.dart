class NWApi {
  static final baseApi = "http://192.168.10.111:3000";
  static final loginPath = "/auth/login";
  static final addUser = '/auth/addUser';
  static final postslist = '/posts/list';
  static final getArticleCarouselMap = '/posts/getArticleCarouselMap';
  static final postsDetails = '/posts/details';
  static final praise = '/posts/praise'; // 用户点赞
  static final queryUserPraiseList = '/posts/queryUserPraiseList'; // 获取用户点赞列表
  static final queryUserPraiseOne = '/posts/queryUserPraiseOne'; // 文章是否被用户点赞
  static final collection = '/posts/collection'; // 用户收藏
  static final queryUserCollectionList =
      '/posts/queryUserCollectionList'; // 获取用户收藏列表
  static final queryUserCollectionOne =
      '/posts/queryUserCollectionOne'; // 文章是否被用户收藏
  static final createPostsComment = '/posts/createPostsComment'; //新增评论
}
