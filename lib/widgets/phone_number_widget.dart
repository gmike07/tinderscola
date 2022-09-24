import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'widgets.dart';

class PhoneNumberWidget extends StatelessWidget {
  final String defaultCountry;
  final List<String>? priorityList;
  final void Function(String) onPhoneNumberChange;
  final void Function(Country) onPhoneCodeChange;
  final bool showError;
  const PhoneNumberWidget(
      {Key? key,
      required this.defaultCountry,
      required this.onPhoneNumberChange,
      required this.onPhoneCodeChange,
      required this.showError,
      this.priorityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Country defaultSelectedCountry =
        CountryPickerUtils.getCountryByIsoCode(defaultCountry);
    List<Country> priorityCountries = [];
    for (String s in priorityList ?? []) {
      priorityCountries.add(CountryPickerUtils.getCountryByIsoCode(s));
    }
    return Card(
            child: ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select your phone code'),
            onValuePicked: (Country country) {
              onPhoneCodeChange(country);
            },
            itemBuilder: (country) => _buildDialogItem(country, false),
            priorityList: priorityCountries,
          ),
        );
      },
      title: _buildDialogItem(defaultSelectedCountry, true),
    ));
  }

  Widget _buildDialogItem(Country country, bool? inDialog) => inDialog == false
      ? Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(width: 8.0),
            Text("+${country.phoneCode}"),
            const SizedBox(width: 8.0),
            Flexible(child: Text(country.name))
          ],
        )
      : Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(width: 8.0),
            Text("+${country.phoneCode}"),
            const SizedBox(width: 8.0),
            Expanded(
                child: CustomTextField(
              hint: '056797541',
              icon: Icons.phone,
              errorText: showError ? 'The phone number is invalid.' : null,
              onChanged: onPhoneNumberChange,
            ))
          ],
        );
}
