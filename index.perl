#!/usr/bin/perl

use strict;
use warnings;

# Path ke file log untuk mencatat informasi DDoS
my $log_file = '/path/to/ddos.log';

if ($ENV{'REMOTE_ADDR'}) {
    my $ip_address = $ENV{'REMOTE_ADDR'};
    my $request_count = 50;  # Jumlah permintaan yang memicu blokir
    my $block_duration = 3600;  # Durasi blokir dalam detik (1 jam)

    # Logika deteksi serangan DDoS
    if (detect_ddos($ip_address, $request_count)) {
        log_ddos_event($ip_address);
        block_ip($ip_address, $block_duration);
        display_captcha();
        exit;
    }
}

sub detect_ddos {
    my ($ip, $request_count) = @_;

    # Contoh logika deteksi DDoS: memeriksa jumlah permintaan dari alamat IP
    my $requests = count_requests_from_ip($ip);
    return $requests > $request_count;
}

sub count_requests_from_ip {
    my ($ip) = @_;

    # Implementasikan logika untuk menghitung jumlah permintaan dari alamat IP
    # Contoh sederhana: menggunakan file log untuk mencatat setiap permintaan
    my $log_content = `grep $ip $log_file | wc -l`;
    chomp($log_content);
    return $log_content;
}

sub log_ddos_event {
    my ($ip) = @_;

    # Logika pencatatan informasi tentang serangan DDoS ke dalam file log
    open my $log_fh, '>>', $log_file or die "Tidak dapat membuka file log: $!";
    print $log_fh "Serangan DDoS terdeteksi dari IP $ip pada " . localtime() . "\n";
    close $log_fh;
}

sub block_ip {
    my ($ip, $duration) = @_;

    # Logika blokir alamat IP selama durasi tertentu
    # Contoh sederhana: menambahkan IP ke file konfigurasi blokir
    my $block_file = '/path/to/blocked_ips.conf';
    open my $config_fh, '>>', $block_file or die "Tidak dapat membuka file konfigurasi: $!";
    print $config_fh "$ip $duration\n";
    close $config_fh;
}

sub display_captcha {
    # Logika menyiapkan dan menampilkan halaman CAPTCHA
    my $captcha_code = generate_captcha_code();
    my $captcha_img = "captcha_image.php?code=$captcha_code";

    my $captcha_html = <<"HTML";
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CAPTCHA Page</title>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f4f4;
                text-align: center;
                margin: 50px;
            }
            h1 {
                color: #333;
            }
            p {
                color: #555;
                margin-bottom: 20px;
            }
            img {
                margin-top: 20px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
            }
            form {
                margin-top: 20px;
            }
            label {
                display: block;
                margin-bottom: 10px;
                color: #333;
            }
            input {
                padding: 8px;
                font-size: 16px;
            }
            input[type="submit"] {
                background-color: #4caf50;
                color: white;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <h1>Your IP has been blocked</h1>
        <p>Please complete the CAPTCHA to access the site.</p>
        <img src="$captcha_img" alt="CAPTCHA Image">
        <form action="verify_captcha.php" method="post">
            <label for="captcha_input">Enter CAPTCHA:</label>
            <input type="text" id="captcha_input" name="captcha_input" required>
            <br>
            <input type="submit" value="Submit">
        </form>
    </body>
    </html>
HTML

    print "Content-type: text/html\n\n";
    print $captcha_html;
}

sub generate_captcha_code {
    my $captcha_code = int(rand(1000000));  # Angka acak enam digit sebagai contoh
    return $captcha_code;
}
