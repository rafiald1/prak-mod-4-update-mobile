import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Controller untuk mengelola pengenalan suara
class MicrophoneController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  var recognizedText = ''.obs;
  var isListening = false.obs;

  // Inisialisasi pengenalan suara
  Future<void> initializeSpeech() async {
    try {
      await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
    } catch (e) {
      print('Error initializing speech recognition: $e');
    }
  }

  // Mulai mendengarkan suara
  Future<void> startListening() async {
    if (!_speech.isAvailable) {
      await initializeSpeech();
    }
    if (_speech.isAvailable) {
      isListening.value = true;
      _speech.listen(onResult: (result) {
        recognizedText.value = result.recognizedWords;
      });
    }
  }

  // Berhenti mendengarkan suara
  void stopListening() {
    isListening.value = false;
    _speech.stop();
  }

  @override
  void onClose() {
    _speech.stop();
    super.onClose();
  }
}

// View untuk pengenalan suara
class MicrophoneView extends StatelessWidget {
  final MicrophoneController controller = Get.put(MicrophoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Microphone Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Teks yang dikenali
            Obx(() => Text(
                  controller.recognizedText.value.isEmpty
                      ? "Tekan tombol untuk berbicara"
                      : controller.recognizedText.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                )),
            const SizedBox(height: 20),
            // Tombol Start/Stop Listening
            Obx(() => ElevatedButton(
                  onPressed: () {
                    controller.isListening.value
                        ? controller.stopListening()
                        : controller.startListening();
                  },
                  child: Text(controller.isListening.value
                      ? 'Stop Listening'
                      : 'Start Listening'),
                )),
            const SizedBox(height: 20),
            // Ikon Mikrofon
            Obx(() => IconButton(
                  icon: Icon(
                    controller.isListening.value ? Icons.mic : Icons.mic_off,
                    size: 40,
                    color: controller.isListening.value ? Colors.red : null,
                  ),
                  onPressed: () {
                    controller.isListening.value
                        ? controller.stopListening()
                        : controller.startListening();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
