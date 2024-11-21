import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Menambahkan variable untuk menyimpan nama dan email
  var userName = ''.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserInfo(); // Menambahkan inisialisasi user info
  }

  // Fungsi untuk mengambil nama dan email pengguna
  Future<void> _initializeUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ??
          'No Name'; // Ambil display name atau "No Name" jika kosong
      userEmail.value = user.email ?? 'No Email'; // Ambil email pengguna
    }
  }

  Future<void> register(String email, String password) async {
    if (!email.contains('@')) {
      Get.snackbar('Error', 'Email tidak valid');
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Error', 'Password harus minimal 8 karakter');
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Success', 'Akun berhasil dibuat');
      // Setelah register berhasil, update info pengguna
      await _initializeUserInfo();
      Get.toNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Akun sudah terdaftar');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Login berhasil');
      // Setelah login berhasil, update info pengguna
      await _initializeUserInfo();
      Get.toNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Email atau Password salah!');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.snackbar('Success', 'Logout berhasil');
    // Kosongkan nama dan email setelah logout
    userName.value = '';
    userEmail.value = '';
  }
}
