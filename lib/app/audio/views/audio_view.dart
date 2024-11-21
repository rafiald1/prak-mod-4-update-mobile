import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_controller.dart';

class AudioView extends GetView<AudioController> {
  const AudioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioUrlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input URL audio
            TextField(
              controller: audioUrlController,
              decoration: InputDecoration(
                hintText: 'Enter audio URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                prefixIcon: const Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20.0),

            // Play/Pause Button with dynamic state
            Obx(() {
              return ElevatedButton.icon(
                onPressed: () {
                  if (controller.isPlaying.value) {
                    controller.pauseAudio();
                  } else {
                    controller.playAudio(audioUrlController.text);
                  }
                },
                icon: Icon(controller.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow),
                label: Text(controller.isPlaying.value ? 'Pause' : 'Play'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20.0),

            // Status Message
            Center(
              child: Obx(
                () => Text(
                  controller.currentAudio.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // Audio Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _controlButton(
                  icon: Icons.play_arrow,
                  label: 'Play',
                  onPressed: () {
                    controller.playAudio(audioUrlController.text);
                  },
                ),
                const SizedBox(width: 10),
                _controlButton(
                  icon: Icons.pause,
                  label: 'Pause',
                  onPressed: controller.pauseAudio,
                ),
                const SizedBox(width: 10),
                _controlButton(
                  icon: Icons.stop,
                  label: 'Stop',
                  onPressed: controller.stopAudio,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable function for control buttons
  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
