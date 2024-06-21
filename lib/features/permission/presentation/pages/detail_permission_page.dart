import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/permission.dart';

class DetailPermissionPage extends StatefulWidget {
  final Permission permission;

  const DetailPermissionPage({super.key, required this.permission});

  @override
  State<DetailPermissionPage> createState() => _DetailPermissionPageState();
}

class _DetailPermissionPageState extends State<DetailPermissionPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDateController.text = widget.permission.startDate;
    _endDateController.text = widget.permission.startDate;
    _reasonController.text = widget.permission.reason;
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
        title: const Text('Detail Izin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          MyTextField(
            controller: _reasonController,
            label: 'Keperluan',
            maxLines: 5,
          ),
          const SpaceHeight(16.0),
          MyTextField(
            controller: _startDateController,
            label: 'Tanggal Mulai',
          ),
          const SpaceHeight(16.0),
          MyTextField(
            controller: _endDateController,
            label: 'Tanggal Selesai',
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
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                child: Container(
                  color: MyColors.white,
                  child: Image.network(
                    '$urlPermissionImage${widget.permission.image}',
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SpaceHeight(16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(),
              Container(
                height: 50.0,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _getStatusSoftColor(widget.permission.isApproved),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    _getApprovalStatus(widget.permission.isApproved),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(widget.permission.isApproved),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusSoftColor(int isApproved) {
    if (isApproved == 0) {
      return MyColors.red.withOpacity(0.2);
    } else if (isApproved == 1) {
      return MyColors.green.withOpacity(0.2);
    } else if (isApproved == 2) {
      return MyColors.yellow.withOpacity(0.2);
    } else {
      return MyColors.white;
    }
  }

  Color _getStatusColor(int isApproved) {
    if (isApproved == 0) {
      return MyColors.red;
    } else if (isApproved == 1) {
      return MyColors.green;
    } else if (isApproved == 2) {
      return MyColors.yellow;
    } else {
      return MyColors.white;
    }
  }

  String _getApprovalStatus(int isApproved) {
    if (isApproved == 0) {
      return 'Ditolak';
    } else if (isApproved == 1) {
      return 'Disetujui';
    } else if (isApproved == 2) {
      return 'Diproses';
    } else {
      return 'Status Tidak Diketahui';
    }
  }
}
