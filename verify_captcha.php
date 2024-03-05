<?php
session_start();

// Ambil nilai input dari formulir
$user_input = $_POST['captcha_input'];

// Ambil nilai CAPTCHA yang disimpan di sesi
$captcha_code = $_SESSION['captcha_code'];

// Verifikasi CAPTCHA
if ($user_input == $captcha_code) {
    echo "CAPTCHA verified successfully. Access granted!";
} else {
    echo "CAPTCHA verification failed. Access denied!";
}

// Hapus nilai CAPTCHA dari sesi setelah verifikasi
unset($_SESSION['captcha_code']);
?>
