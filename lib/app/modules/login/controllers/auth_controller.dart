import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  final Connectivity _connectivity = Connectivity();

  // Menambahkan variable untuk menyimpan nama dan email
  var userName = ''.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserInfo();
    _checkStoredData(); // Memastikan data tersimpan offline dikirim saat online
  }

  // Mengecek koneksi internet
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print('DEBUG: Connectivity Result = $connectivityResult');

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      print('DEBUG: Koneksi Internet Terdeteksi.');
      return true;
    }

    print('DEBUG: Tidak Ada Koneksi.');
    return false;
  }

  // Inisialisasi user info
  Future<void> _initializeUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'No Name';
      userEmail.value = user.email ?? 'No Email';
    }
  }

  // Fungsi untuk mengecek dan mengirim data offline ke Firestore saat koneksi kembali
  Future<void> _checkStoredData() async {
    if (await isConnected()) {
      final localData = _storage.read('offlineData');
      if (localData != null) {
        await _firestore.collection('users').add(localData);
        _storage.remove(
            'offlineData'); // Hapus data lokal setelah berhasil disimpan
      }
    }
  }

  Future<void> register(String email, String password) async {
    try {
      if (!(await isConnected())) {
        // Simpan data lokal jika offline
        _storage.write('offlineData', {"email": email, "password": password});
        Get.snackbar(
            'Offline', 'Data Anda disimpan, akan dikirim saat online.');
        return;
      }

      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').add({"email": email});

      Get.snackbar('Success', 'Akun berhasil dibuat');
      await _initializeUserInfo();
      Get.toNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Error: ${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (!(await isConnected())) {
        Get.snackbar('No Internet', 'Maaf, koneksi anda hilang.');
        return;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Login berhasil');
      await _initializeUserInfo();
      Get.toNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Email atau Password salah!');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    userName.value = '';
    userEmail.value = '';
    Get.snackbar('Success', 'Logout berhasil');
  }
}
