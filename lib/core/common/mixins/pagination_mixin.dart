mixin PaginationMixin {
  int _currentPage = 1;
  bool _isLastPage = false;
  bool _isLoadingNextPage = false;

  int get currentPage => _currentPage;
  bool get isLastPage => _isLastPage;
  bool get isLoadingNextPage => _isLoadingNextPage;

  void resetPagination() {
    _currentPage = 1;
    _isLastPage = false;
    _isLoadingNextPage = false;
  }

  void incrementPage() {
    _currentPage++;
  }

  void setLastPage(bool value) {
    _isLastPage = value;
  }

  void setLoadingNextPage(bool value) {
    _isLoadingNextPage = value;
  }

  bool canLoadMore() {
    return !_isLastPage && !_isLoadingNextPage;
  }
}
