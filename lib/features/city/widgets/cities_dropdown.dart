import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/city.dart';
import '../services/city.dart';

class CitiesDropdown extends HookConsumerWidget {
  const CitiesDropdown({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final void Function(City?)? onChanged;
  final City? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = useState('');
    final q = useDebounced(filter.value, const Duration(milliseconds: 350));

    return DropdownSearch<City>(
      asyncItems: (_) => ref.read(cityServiceProvider).getCities(q ?? ''),
      itemAsString: (city) => '${city.district} - ${city.name}',
      selectedItem: initialValue,
      onChanged: onChanged,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          label: Text('City'),
          hintText: 'Select city',
        ),
      ),
    );
  }
}
