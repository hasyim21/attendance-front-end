import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../home/presentation/pages/main_page.dart';
import '../bloc/add_permission/add_permission_bloc.dart';
import '../widgets/custom_date_picker.dart';

class AddPermissionPage extends StatefulWidget {
  const AddPermissionPage({super.key});

  @override
  State<AddPermissionPage> createState() => _AddPermissionPageState();
}

class _AddPermissionPageState extends State<AddPermissionPage> {
  String? imagePath;
  late final TextEditingController dateController;
  late final TextEditingController reasonController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    reasonController = TextEditingController();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      } else {
        debugPrint('No file selected.');
      }
    });
  }

  String formatDate(DateTime date) {
    // Gunakan DateFormat untuk mengatur format tanggal
    final dateFormatter = DateFormat('yyyy-MM-dd');
    // Kembalikan tanggal dalam format yang dinginkan
    return dateFormatter.format(date);
  }

  @override
  void dispose() {
    dateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Izin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          CustomDatePicker(
            label: 'Tanggal',
            onDateSelected: (selectedDate) =>
                dateController.text = formatDate(selectedDate).toString(),
          ),
          const SpaceHeight(16.0),
          CustomTextField(
            controller: reasonController,
            label: 'Keperluan',
            maxLines: 5,
          ),
          const SpaceHeight(26.0),
          Padding(
            padding: EdgeInsets.only(right: context.deviceWidth / 2),
            child: GestureDetector(
              onTap: _pickImage,
              child: imagePath == null
                  ? DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      radius: const Radius.circular(18.0),
                      dashPattern: const [8, 4],
                      child: const Center(
                        child: SizedBox(
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              SpaceHeight(18.0),
                              Text('Lampiran'),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                      child: Image.file(
                        File(imagePath!),
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SpaceHeight(65.0),
          BlocConsumer<AddPermissionBloc, AddPermissionState>(
            listener: (context, state) {
              if (state is AddPermissionError) {
                MySnackbar.show(
                  context,
                  message: state.failure.message,
                  backgroundColor: MyColors.red,
                );
              }
              if (state is AddPermissionSuccess) {
                dateController.clear();
                reasonController.clear();
                setState(() {
                  imagePath = null;
                });

                MySnackbar.show(
                  context,
                  message: 'Submit Izin success',
                );
                context.pushReplacement(const MainPage());
              }
            },
            builder: (context, state) {
              if (state is AddPermissionLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Button.filled(
                onPressed: () {
                  final image = imagePath != null ? XFile(imagePath!) : null;
                  context.read<AddPermissionBloc>().add(
                        AddPermissionEvent(
                            date: dateController.text,
                            reason: reasonController.text,
                            image: image!.path),
                      );
                },
                label: 'Kirim Permintaan',
              );
            },
          ),
        ],
      ),
    );
  }
}
