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

  final void Function(City?) onChanged;
  final City? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = useState('malang');
    final cities = useState<List<City>>([]);
    final q = useDebounced(filter.value, const Duration(milliseconds: 350));

    return GestureDetector(
      onTap: () async {
        await ref
            .read(cityServiceProvider)
            .getCities(q ?? 'malang')
            .then((list) {
          cities.value = list;
        });
      },
      child: DropdownButtonFormField<City>(
        decoration: const InputDecoration(
          label: Text('City'),
          hintText: 'Select city',
        ),
        value: cities.value.isNotEmpty ? cities.value[0] : initialValue,
        items: cities.value
            .map(
              (city) => DropdownMenuItem(
                value: city,
                child: Text('${city.district} - ${city.name}'),
              ),
            )
            .toList(),
        // onTap: () async {
        //   await ref
        //       .read(cityServiceProvider)
        //       .getCities(q ?? 'malang')
        //       .then((list) {
        //     cities.value = list;
        //   });
        // },
        onChanged: onChanged,
      ),
    );
  }
}
