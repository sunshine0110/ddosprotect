<?php
session_start();

// Set session untuk menyimpan kode CAPTCHA
$_SESSION['captcha_code'] = generate_captcha_code();

// Buat gambar CAPTCHA
$width = 120;
$height = 40;
$image = imagecreate($width, $height);
$background_color = imagecolorallocate($image, 255, 255, 255);
$text_color = imagecolorallocate($image, 0, 0, 0);

imagestring($image, 5, 10, 10, $_SESSION['captcha_code'], $text_color);

header('Content-type: image/png');
imagepng($image);
imagedestroy($image);

function generate_captcha_code() {
    return rand(100000, 999999);  // Angka acak enam digit sebagai contoh
}
?>
captcha_image.php
