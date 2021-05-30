class NWApi {
  static final baseApi = "http://117.50.17.60:3000"; // 尾部不能有/
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
  static final authUpdateUsername = '/auth/updateUsername'; //修改昵称
  static final queryHistoryList = '/posts/queryHistoryList'; //获取历史记录列表
  static final postsHistory = '/posts/history'; //历史记录
  static final postsDeletePraise = '/posts/deletePraise'; //删除用户点赞
  static final postsDeleteCollection = '/posts/deleteCollection'; //用户删除收藏
  static final postsQueryUserPraiseList =
      '/posts/queryUserPraiseList'; //获取用户点赞列表
  static final postsQueryUserCollectionList =
      '/posts/queryUserCollectionList'; //获取用户收藏列表
  static final fileUploadFile = '/file/uploadFile'; //文件上传
  static final fileImages = '/file/images/'; // 头像预览
  static final authGetUserInfo = '/auth/getUserInfo'; // 获取用户信息

}
