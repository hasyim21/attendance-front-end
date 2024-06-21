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
      title: const Text("Face Registration", textAlign: TextAlign.center),
      alignment: Alignment.center,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.memory(
              Uint8List.fromList(img.encodeBmp(croppedFace)),
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<UpdateFaceEmbeddingBloc,
                  UpdateFaceEmbeddingState>(
                listener: (context, state) {
                  if (state is UpdateFaceEmbeddingSuccess) {
                    context.pushAndRemoveUntil(
                      const MainPage(),
                      (route) => false,
                    );
                  }

                  if (state is UpdateFaceEmbeddingError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.failure.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UpdateFaceEmbeddingLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return MyButton.filled(
                    onPressed: () {
                      context.read<UpdateFaceEmbeddingBloc>().add(
                            UpdateFaceEmbeddingEvent(
                              faceEmbedding: recognition.embedding.join(','),
                            ),
                          );
                    },
                    label: 'Register',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
    ),
  );
}
