abstract class ArticleOperationRequset {
  int userId;

  ArticleOperationRequset({this.userId});
}

abstract class ArticleStatus {
  // 确定
  static int determine = 1;

  // 取消
  static int cancel = 0;
}

class ArticleOraiseRequset implements ArticleOperationRequset {
  @override
  int userId;

  final String postId;

  int status = ArticleStatus.determine;

  ArticleOraiseRequset({this.userId, this.postId, this.status});
}

class IsArticleOraiseRequset implements ArticleOperationRequset {
  @override
  int userId;

  String postId;

  IsArticleOraiseRequset({this.userId, this.postId});
}

class ArticleComment implements ArticleOperationRequset {
  @override
  int userId;

  String postId;

  String text;

  ArticleComment({this.userId, this.postId, this.text});
}
