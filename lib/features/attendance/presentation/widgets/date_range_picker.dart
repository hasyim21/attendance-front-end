import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class DateRangePicker extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final VoidCallback onSearch;

  const DateRangePicker({
    super.key,
    required this.startDateController,
    required this.endDateController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    startDateController.addListener(() => onSearch());
    endDateController.addListener(() => onSearch());

    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      color: MyColors.primary,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Dari :',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SpaceWidth(21.0),
                Expanded(
                  child: Text(
                    'Ke :',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SpaceHeight(4.0),
            Row(
              children: [
                Expanded(
                  child: _CustomDatePicker(
                    hintText: startDateController.text.toShortFormattedDate(),
                    onDateSelected: (selectedDate) {
                      startDateController.text =
                          selectedDate.toIsoFormattedDate();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 1.0,
                  width: 5.0,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: _CustomDatePicker(
                    hintText: endDateController.text.toShortFormattedDate(),
                    onDateSelected: (selectedDate) {
                      endDateController.text =
                          selectedDate.toIsoFormattedDate();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomDatePicker extends StatefulWidget {
  final String hintText;
  final void Function(DateTime selectedDate)? onDateSelected;

  const _CustomDatePicker({
    required this.hintText,
    this.onDateSelected,
  });

  @override
  State<_CustomDatePicker> createState() => __CustomDatePickerState();
}

class __CustomDatePickerState extends State<_CustomDatePicker> {
  final TextEditingController controller = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = selectedDate.toShortFormattedDate();
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        border: Border.all(
          width: 1.0,
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month,
          ),
          const SpaceWidth(),
          Expanded(
            child: TextFormField(
              controller: controller,
              onTap: () => _selectDate(),
              readOnly: true,
              style: const TextStyle(
                fontSize: 14.0,
              ),
              decoration: InputDecoration.collapsed(
                hintText: widget.hintText,
                filled: true,
                fillColor: MyColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
