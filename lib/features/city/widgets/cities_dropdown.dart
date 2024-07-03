import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/city.dart';
import '../services/city.dart';

class CitiesDropdown extends StatelessWidget {
  const CitiesDropdown({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        label: Text('City'),
        hintText: 'Select city',
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      onTap: () async {
        final selected = await showModalBottomSheet<City?>(
          context: context,
          showDragHandle: true,
          builder: (context) {
            return const _CitiesDropdownBottomSheet();
          },
        );
        if (selected != null) {
          controller.text = selected.text;
        }
      },
      autofocus: false,
      readOnly: true,
    );
  }
}

class _CitiesDropdownBottomSheet extends HookConsumerWidget {
  const _CitiesDropdownBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = useState<List<City>>([]);

    final filter = useState('');
    final q = useDebounced(filter.value, const Duration(milliseconds: 350));

    useEffect(() {
      if (q != null && q.isNotEmpty) {
        ref.read(cityServiceProvider).getCities(q).then((list) {
          cities.value = list;
        });
      }
      return null;
    }, [q]);

    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            TextFormField(
              initialValue: filter.value,
              decoration: InputDecoration(
                helperText: 'Search cities by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    filter.value = '';
                  },
                ),
              ),
              onChanged: (val) async {
                filter.value = val;
              },
            ),
            cities.value.isEmpty
                ? const Text('No cities found.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: cities.value.length,
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(cities.value[index].text),
                        onTap: () {
                          Navigator.pop(context, cities.value[index]);
                        },
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
