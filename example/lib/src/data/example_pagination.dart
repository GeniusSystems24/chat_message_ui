import 'package:smart_pagination/pagination.dart';

class ExamplePaginationHelper<T> {
  ExamplePaginationHelper({
    required List<T> items,
    this.pageSize = 12,
  }) : _items = List<T>.from(items) {
    cubit = SmartPaginationCubit<T>(
      request: PaginationRequest(page: 1, pageSize: pageSize),
      provider: PaginationProvider.future(_fetch),
    );
  }

  final int pageSize;
  List<T> _items;
  late final SmartPaginationCubit<T> cubit;

  Future<List<T>> _fetch(PaginationRequest request) async {
    final size = request.pageSize ?? pageSize;
    final startIndex = (request.page - 1) * size;

    if (startIndex >= _items.length) {
      return [];
    }

    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _items.skip(startIndex).take(size).toList();
  }

  void setItems(List<T> items) {
    _items = List<T>.from(items);
    cubit.setItems(_items);
  }

  void dispose() {
    cubit.dispose();
  }
}
