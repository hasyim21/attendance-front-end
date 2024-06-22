import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/core.dart';
import '../../../home/presentation/pages/main_page.dart';
import '../bloc/add_permission/add_permission_bloc.dart';

class AddPermissionPage extends StatefulWidget {
  const AddPermissionPage({super.key});

  @override
  State<AddPermissionPage> createState() => _AddPermissionPageState();
}

class _AddPermissionPageState extends State<AddPermissionPage> {
  String? imagePath;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _reasonController = TextEditingController();
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

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Izin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          MyTextField(
            controller: _reasonController,
            label: 'Keperluan',
            maxLines: 5,
          ),
          const SpaceHeight(16.0),
          MyDatePicker(
            label: 'Tanggal Mulai',
            onDateSelected: (selectedDate) =>
                _startDateController.text = selectedDate.toIsoFormattedDate(),
          ),
          const SpaceHeight(16.0),
          MyDatePicker(
            label: 'Tanggal Selesai',
            onDateSelected: (selectedDate) =>
                _endDateController.text = selectedDate.toIsoFormattedDate(),
          ),
          const SpaceHeight(16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lampiran',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(),
              GestureDetector(
                onTap: _pickImage,
                child: imagePath == null
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        color: MyColors.grey,
                        radius: const Radius.circular(8.0),
                        dashPattern: const [8, 4],
                        child: Container(
                          color: MyColors.white,
                          height: 150.0,
                          width: 150.0,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 60.0,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        child: Image.file(
                          File(imagePath!),
                          height: 150.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ],
          ),
          const SpaceHeight(32.0),
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
                _startDateController.clear();
                _reasonController.clear();
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

              return MyButton.filled(
                onPressed: () {
                  final image = imagePath != null ? XFile(imagePath!) : null;
                  context.read<AddPermissionBloc>().add(
                        AddPermissionEvent(
                            startDate: _startDateController.text,
                            endDate: _endDateController.text,
                            reason: _reasonController.text,
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
