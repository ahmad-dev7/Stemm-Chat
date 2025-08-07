import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:stemm_chat/controllers/auth_controller.dart';

class GenderPicker extends StatelessWidget {
  const GenderPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      value: authController.selectedGender.value,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(color: Colors.blue[50]),
      ),
      menuItemStyleData: MenuItemStyleData(
        overlayColor: WidgetStatePropertyAll(Colors.white),
      ),
      decoration: InputDecoration(
        hintText: 'Select Gender',
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.transgender),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      isExpanded: true,
      items: List.generate(
        authController.genders.length,
        (index) => DropdownMenuItem(
          value: authController.genders[index],
          child: Text(authController.genders[index]),
        ),
      ),
      onChanged: (gender) => authController.selectedGender.value = gender,
    );
  }
}
