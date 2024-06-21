import 'package:flutter/material.dart';

import '../core.dart';

class MyDatePicker extends StatefulWidget {
  final void Function(DateTime selectedDate)? onDateSelected;
  final DateTime? initialDate;
  final Widget? prefix;
  final String label;
  final bool showLabel;
  final bool showSuffix;

  const MyDatePicker({
    super.key,
    required this.label,
    this.showLabel = true,
    this.showSuffix = true,
    this.initialDate,
    this.onDateSelected,
    this.prefix,
  });

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late TextEditingController controller;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.initialDate?.toFormattedDate(),
    );
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = selectedDate.toFormattedDate();
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SpaceHeight(),
        ],
        SizedBox(
          height: 50.0,
          child: TextFormField(
            controller: controller,
            onTap: () => _selectDate(context),
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyColors.white,
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.calendar_month),
              ),
              suffixIcon: (widget.showSuffix)
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    )
                  : const SizedBox(),
              hintText: widget.initialDate != null
                  ? selectedDate.toFormattedDate()
                  : widget.label,
              hintStyle: const TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}
