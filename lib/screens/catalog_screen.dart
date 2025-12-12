import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _priceRangeStart = 0;
  double _priceRangeEnd = 10000;
  String _sortBy = 'default';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог масел'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по названию или бренду...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    productsProvider.search('');
                  },
                ),
              ),
              onChanged: (value) {
                productsProvider.search(value);
              },
            ),
          ),
          Expanded(
            child: productsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productsProvider.products.isEmpty
                    ? const Center(
                        child: Text(
                          'Товары не найдены',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: productsProvider.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: productsProvider.products[index],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    String selectedType = productsProvider.types.first;
    String selectedViscosity = productsProvider.viscosities.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Фильтры'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Тип масла:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: productsProvider.types
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Вязкость:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      value: selectedViscosity,
                      items: productsProvider.viscosities
                          .map((visc) => DropdownMenuItem(
                                value: visc,
                                child: Text(visc),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedViscosity = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Сортировка:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      value: _sortBy,
                      items: const [
                        DropdownMenuItem(
                          value: 'default',
                          child: Text('По умолчанию'),
                        ),
                        DropdownMenuItem(
                          value: 'price_asc',
                          child: Text('По возрастанию цены'),
                        ),
                        DropdownMenuItem(
                          value: 'price_desc',
                          child: Text('По убыванию цены'),
                        ),
                        DropdownMenuItem(
                          value: 'name_asc',
                          child: Text('По названию (А-Я)'),
                        ),
                        DropdownMenuItem(
                          value: 'name_desc',
                          child: Text('По названию (Я-А)'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Цена:', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: RangeValues(_priceRangeStart, _priceRangeEnd),
                      min: 0,
                      max: 10000,
                      divisions: 20,
                      labels: RangeLabels(
                        '${_priceRangeStart.toInt()} руб.',
                        '${_priceRangeEnd.toInt()} руб.',
                      ),
                      onChanged: (values) {
                        setState(() {
                          _priceRangeStart = values.start;
                          _priceRangeEnd = values.end;
                        });
                      },
                    ),
                    Text('От ${_priceRangeStart.toInt()} до ${_priceRangeEnd.toInt()} руб.'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    productsProvider.filterByType(selectedType);
                    productsProvider.filterByViscosity(selectedViscosity);
                    productsProvider.filterByPrice(_priceRangeStart, _priceRangeEnd);
                    productsProvider.sortByOption(_sortBy);
                    Navigator.pop(context);
                  },
                  child: const Text('Применить'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}