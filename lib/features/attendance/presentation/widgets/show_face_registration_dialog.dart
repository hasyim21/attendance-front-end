import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

import '../../../../core/core.dart';
import '../../../home/presentation/pages/main_page.dart';
import '../bloc/update_face_embedding/update_face_embedding_bloc.dart';

void showFaceRegistrationDialogue(
  BuildContext context,
  img.Image croppedFace,
  RecognitionEmbedding recognition,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(
        'Daftar Wajah',
        textAlign: TextAlign.center,
      ),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.memory(
            Uint8List.fromList(img.encodeBmp(croppedFace)),
            width: 200,
            height: 200,
          ),
          const SpaceHeight(24.0),
          Row(
            children: [
              Expanded(
                child: MyButton.outlined(
                  onPressed: () => context.pop(),
                  label: 'Batal',
                ),
              ),
              const SpaceWidth(12.0),
              BlocConsumer<UpdateFaceEmbeddingBloc, UpdateFaceEmbeddingState>(
                listener: (context, state) {
                  if (state is UpdateFaceEmbeddingSuccess) {
                    context.pushAndRemoveUntil(
                      const MainPage(),
                      (route) => false,
                    );
                    MySnackbar.show(
                      context,
                      message: 'Daftar wajah berhasil',
                    );
                  }

                  if (state is UpdateFaceEmbeddingError) {
                    MySnackbar.show(
                      context,
                      message: state.failure.message,
                      backgroundColor: MyColors.red,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UpdateFaceEmbeddingLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Expanded(
                    child: MyButton.filled(
                      onPressed: () {
                        context.read<UpdateFaceEmbeddingBloc>().add(
                              UpdateFaceEmbeddingEvent(
                                faceEmbedding: recognition.embedding.join(','),
                              ),
                            );
                      },
                      label: 'Daftar',
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
