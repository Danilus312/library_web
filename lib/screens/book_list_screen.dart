import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/seed_data.dart';
import '../models/book.dart';
import '../models/book_query.dart';
import '../state/book_list_notifier.dart';
import '../state/load_status.dart';
import '../widgets/entity_table.dart';
import '../widgets/pagination_bar.dart';
import '../widgets/search_input.dart';

class BookListScreen extends StatefulWidget {
  final Map<String, String> queryParams;
  const BookListScreen({super.key, required this.queryParams});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncUrlToState(widget.queryParams);
    });
  }

  @override
  void didUpdateWidget(covariant BookListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queryParams != widget.queryParams) {
      _syncUrlToState(widget.queryParams);
    }
  }

  void _syncUrlToState(Map<String, String> params) {
    final query = BookQuery.fromQueryParams(params);
    context.read<BookListNotifier>().applyQuery(query);
  }

  void _pushQuery(BookQuery next) {
    final queryParams = next.toQueryParams();
    final uri = Uri(path: '/books', queryParameters: queryParams.isEmpty ? null : queryParams);
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<BookListNotifier>();
    final q = notifier.query;
    final res = notifier.result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.people),
            label: const Text('Авторы'),
            onPressed: () => context.go('/authors'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
            onPressed: () => notifier.load(),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchInput(
                          initialValue: q.search,
                          hintText: 'Поиск по названию или ISBN...',
                          onChanged: (val) => _pushQuery(q.copyWith(search: val)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilterChip(
                        label: const Text('Удалённые'),
                        selected: q.includeDeleted,
                        onSelected: (val) => _pushQuery(q.copyWith(includeDeleted: val)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DropdownButton<int?>(
                        value: q.genreId,
                        hint: const Text('Все жанры'),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Все жанры')),
                          ...genreMap.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))),
                        ],
                        onChanged: (val) => _pushQuery(q.copyWith(genreId: val)),
                      ),
                      DropdownButton<int?>(
                        value: q.publisherId,
                        hint: const Text('Все издательства'),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Все издательства')),
                          ...publisherMap.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))),
                        ],
                        onChanged: (val) => _pushQuery(q.copyWith(publisherId: val)),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Год от', isDense: true, border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: q.yearFrom?.toString() ?? ''),
                          onSubmitted: (val) => _pushQuery(q.copyWith(yearFrom: int.tryParse(val))),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Год до', isDense: true, border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: q.yearTo?.toString() ?? ''),
                          onSubmitted: (val) => _pushQuery(q.copyWith(yearTo: int.tryParse(val))),
                        ),
                      ),
                      if (q.genreId != null || q.publisherId != null || q.yearFrom != null || q.yearTo != null || q.search.isNotEmpty)
                        TextButton.icon(
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Сбросить'),
                          onPressed: () => _pushQuery(const BookQuery()),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (notifier.hasSelection)
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Выбрано книг: ${notifier.selected.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Удалить выбранные'),
                    onPressed: () => _confirmMassDelete(context, notifier),
                  ),
                ],
              ),
            ),
          Expanded(
            child: switch (notifier.status) {
              LoadStatus.loading => const Center(child: CircularProgressIndicator()),
              LoadStatus.error => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(notifier.error ?? 'Ошибка', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: () => notifier.load(), child: const Text('Повторить')),
                    ],
                  ),
                ),
              LoadStatus.idle || LoadStatus.success => res.items.isEmpty
                  ? const Center(
                      child: Text('По заданным критериям книг не найдено', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return _buildCardList(context, notifier);
                        } else {
                          return _buildTableView(context, notifier);
                        }
                      },
                    ),
            },
          ),
          PaginationBar(
            page: res.page,
            totalPages: res.totalPages,
            totalItems: res.total,
            size: res.size,
            onPageChange: (p) => _pushQuery(q.copyWith(page: p)),
            onSizeChange: (s) => _pushQuery(q.copyWith(size: s, page: 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView(BuildContext context, BookListNotifier notifier) {
    return EntityTable<Book>(
      items: notifier.result.items,
      idOf: (b) => b.id,
      selected: notifier.selected,
      onToggleSelect: (id) => notifier.toggleSelection(id),
      sortField: notifier.query.sortField,
      sortAscending: notifier.query.sortAscending,
      onSort: (field) => _pushQuery(
        notifier.query.copyWith(
          sortField: field,
          sortAscending: field == notifier.query.sortField ? !notifier.query.sortAscending : true,
        ),
      ),
      columns: [
        TableColumnSpec(
          label: 'Название',
          sortField: 'title',
          build: (b) => Text(b.title, style: TextStyle(decoration: b.isDeleted ? TextDecoration.lineThrough : null)),
        ),
        TableColumnSpec(label: 'ISBN', build: (b) => Text(b.isbn)),
        TableColumnSpec(label: 'Год', sortField: 'year', numeric: true, build: (b) => Text('${b.year}')),
        TableColumnSpec(label: 'Страниц', sortField: 'pages', numeric: true, build: (b) => Text('${b.pages}')),
        TableColumnSpec(
          label: 'Жанры',
          build: (b) => Text(b.genreIds.map((id) => genreMap[id] ?? '$id').join(', ')),
        ),
      ],
      actions: (b) => [
        if (b.isDeleted)
          IconButton(
            icon: const Icon(Icons.restore, color: Colors.green),
            tooltip: 'Восстановить',
            onPressed: () => notifier.restore(b.id),
          )
        else ...[
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.orange),
            tooltip: 'В корзину',
            onPressed: () => notifier.softDelete(b.id),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Удалить навсегда',
            onPressed: () => notifier.hardDelete(b.id),
          ),
        ],
      ],
    );
  }

  Widget _buildCardList(BuildContext context, BookListNotifier notifier) {
    final items = notifier.result.items;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final b = items[index];
        final isSelected = notifier.selected.contains(b.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
          child: ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (_) => notifier.toggleSelection(b.id),
            ),
            title: Text(b.title, style: TextStyle(decoration: b.isDeleted ? TextDecoration.lineThrough : null)),
            subtitle: Text('ISBN: ${b.isbn}\nГод: ${b.year}, Стр: ${b.pages}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                if (b.isDeleted)
                  PopupMenuItem(child: const Text('Восстановить'), onTap: () => notifier.restore(b.id))
                else ...[
                  PopupMenuItem(child: const Text('В корзину'), onTap: () => notifier.softDelete(b.id)),
                  PopupMenuItem(child: const Text('Удалить'), onTap: () => notifier.hardDelete(b.id)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmMassDelete(BuildContext context, BookListNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text('Поместить в удалённые ${notifier.selected.length} выбранных книг?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.deleteSelected();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}