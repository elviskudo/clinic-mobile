import 'package:clinic/constants/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
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
      decoration: InputDecoration(
        label: Text(context.tr('nik_field.label')),
        hintText: context.tr('nik_field.placeholder'),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: () async {
        final selected = await showModalBottomSheet<City?>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const _CitiesDropdownBottomSheet(),
            );
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: TextFormField(
                autofocus: false,
                initialValue: filter.value,
                decoration: const InputDecoration(
                  hintText: 'Search cities by name...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (val) async {
                  filter.value = val;
                },
              ),
            ),
            gapH16,
            cities.value.isEmpty
                ? const ListTile(
                    title: Center(child: Text('No cities found.')),
                    contentPadding: EdgeInsets.symmetric(horizontal: Sizes.p24),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: cities.value.length,
                      controller: scrollController,
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
