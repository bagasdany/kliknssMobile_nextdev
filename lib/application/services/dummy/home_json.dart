import 'package:kliknss77/application/style/constants.dart';

class ResponseHomeType {
  dynamic response = [
    {
      "homeType": "DS",
      "homeTypeDescription": "Rumah Dinas",
      "homeOwnership": [
        {"code": "PR", "description": "Perusahaan"},
        {"code": "PM", "description": "Instansi Pemerintah"}
      ]
    },
    {
      "homeType": "KB",
      "homeTypeDescription": "Kontrak Bulanan",
      "homeOwnership": [
        {"code": "OL", "description": "Orang Lain"},
        {"code": "SD", "description": "Saudara"}
      ]
    },
    {
      "homeType": "KN",
      "homeTypeDescription": "Kontrak Tahunan",
      "homeOwnership": [
        {"code": "OL", "description": "Orang Lain"},
        {"code": "SD", "description": "Saudara"}
      ]
    },
    {
      "homeType": "KS",
      "homeTypeDescription": "Kost",
      "homeOwnership": [
        {"code": "OL", "description": "Orang Lain"},
        {"code": "SD", "description": "Saudara"}
      ]
    },
    {
      "homeType": "MK",
      "homeTypeDescription": "Milik Keluarga",
      "homeOwnership": [
        {"code": "OT", "description": "Orang Tua"},
        {"code": "SD", "description": "Saudara"}
      ]
    },
    {
      "homeType": "MS",
      "homeTypeDescription": "Milik Sendiri",
      "homeOwnership": [
        {"code": "SR", "description": "Pemohon"},
        {"code": "SM", "description": "Suami"},
        {"code": "IS", "description": "Istri"}
      ]
    },
    {
      "homeType": "MO",
      "homeTypeDescription": "Milik Orang Lain",
      "homeOwnership": [
        {"code": "OL", "description": "Orang Lain"}
      ]
    }
  ];

  dynamic livingDuration = [
    {"homeLivingDurationUnit": "m", "homeLivingDescription": "Bulan"},
    {
      "homeLivingDurationUnit": "y",
      "homeLivingDescription": "Tahun",
    },
  ];

  dynamic paymentMethodsJson = [
    {
      "id": 1,
      "isActive": true,
      "name": "BCA",
      "description": "BCA virtual account",
      "type": "Transfer Virtual Account",
      "imageUrl": "assets/images/paymentlist/bca.png",
      "group": "VIRTUAL_ACCOUNT",
      "provider": "xendit",
      "bankCode": "00400",
      "noPaymentText": "Nomor Virtual Account",
      "imageClass": "bca_va",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2021-01-12 08:40:36",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "bankAccountNumber": "123 456 7899",
      "amount": 9999999,
      "steps": [
        {
          "text": "ATM BCA",
          "items": [
            {
              "title": "Masukkan PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bca_1.jpg",
            },
            {
              "title": "Pilih Transaksi Lainnya",
              "description": "Pilih menu Transaksi Lainnya pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bca_2.jpg",
            },
            {
              "title": "Pilih Transfer",
              "description": "Pilih menu Transfer lainnya pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bca_3.jpg",
            },
            {
              "title": "Klik BCA Virtual Account",
              "description": "Pilih Menu “BCA Virtual Account” pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bca_4.jpg",
            },
            {
              "title": "Masukkan Kode bank & Nomor Kontrak",
              "description":
                  "Masukan kode bank 00400 + Nomor Kontrak, Contoh No. kontrak : 3122120XXXX jadi 004003122120XXXX",
              "imageUrl": "assets/images/paymentlist/atm_bca_5.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,klik Bayar, dan Simpan struk pembayaran.",
              "imageUrl": "assets/images/paymentlist/atm_bca_6.jpg",
            }
          ]
        },
        {
          "text": "M-Banking",
          "items": [
            {
              "title": "Masuk aplikasi BCA Mobile, pilih m-BCA",
              "description":
                  "Masuk aplikasi BCA Mobile, pilih m-BCA pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/mbank_bca_1.jpg",
            },
            {
              "title": "Pilih m-Transfer",
              "description":
                  "Pilih menu m-Transfer Lainnya pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/mbank_bca_2.jpg",
            },
            {
              "title": "Klik BCA Virtual Account",
              "description":
                  "Pilih Menu “BCA Virtual Account” layar handphone anda",
              "imageUrl": "assets/images/paymentlist/mbank_bca_3.jpg",
            },
            {
              "title": "Masukkan Kode Pembayaran",
              "description":
                  "Masukan kode bank 00400 + Nomor Kontrak, Contoh No. kontrak : 3122120XXXX jadi 004003122120XXXX,lalu Klik Bayar",
              "imageUrl": "assets/images/paymentlist/mbank_bca_4.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran layar handphone anda,lalu masukkan PIN Transaksi dan bayar",
              "imageUrl": "assets/images/paymentlist/mbank_bca_5.jpg",
            },
            {
              "title": "Bayar",
              "description": "masukkan PIN ATM anda dan bayar",
              "imageUrl": "assets/images/paymentlist/mbank_bca_6.jpg",
            }
          ]
        },
      ]
    },
    {
      "id": 2,
      ""
          "isActive": true,
      "name": "BRI",
      "type": "Transfer Virtual Account",
      "description": "BRI virtual account",
      "imageUrl": "assets/images/paymentlist/bri.png",
      "group": "VIRTUAL_ACCOUNT",
      "provider": "xendit",
      "imageClass": "bri_epay",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "bankAccountNumber": "123 456 7899",
      "bankCode": "78999",
      "noPaymentText": "Nomor Virtual Account",
      "amount": 9999999,
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "ATM BRI",
          "items": [
            {
              "title": "Masukkan kartu debit BRI dan PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_1.jpg",
            },
            {
              "title": "Pilih Transaksi Lainnya",
              "description": "Pilih menu Transaksi Lainnya pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_2.jpg",
            },
            {
              "title": "Pilih Pembayaran",
              "description": "Pilih menu Pembayaran pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_3.jpg",
            },
            {
              "title": "Pilih Lainnya",
              "description": "Pilih Menu “Lainnya” pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_4.jpg",
            },
            {
              "title": "Pilih menu BRIVA",
              "description": "Pilih Menu BRIVA pada layar mesin ATM Anda",
              "imageUrl": "assets/images/paymentlist/atm_bri_5.jpg",
            },
            {
              "title": "Masukkan Kode Pembayaran",
              "description":
                  "Masukan kode bank 78999 + Nomor Kontrak, Contoh nomor kontrak : 3122120XXXX => 789993122120XXXX,lalu Klik Bayar",
              "imageUrl": "assets/images/paymentlist/atm_bri_6.jpg",
            },
            {
              "title": "Konfirmasi Data & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,jika benar klik Bayar dan Simpan struk pembayaran",
              "imageUrl": "assets/images/paymentlist/atm_bri_7.jpg",
            }
          ]
        },
        {
          "text": "M-Banking BRImo",
          "items": [
            {
              "title": "Buka aplikasi BRI Mobile",
              "description": "Masuk ke aplikasi BRI Mobile anda",
              "imageUrl": "assets/images/paymentlist/mbank_brimo_1.jpg",
            },
            {
              "title": "Pilih BRIVA",
              "description": "Dari layar utama, pilih BRIVA",
              "imageUrl": "assets/images/paymentlist/mbank_brimo_2.jpg",
            },
            {
              "title": "Masukkan Kode bank & Nomor Kontrak",
              "description":
                  "Masukkan kode : 78999 + Nomor Kontrak. Contoh nomor kontrak : 3122120XXXX => 789993122120XXXX,lalu Klik Bayar",
              "imageUrl": "assets/images/paymentlist/mbank_brimo_3.jpg",
            },
            {
              "title": "Konfirmasi Data & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,jika benar klik Bayar dan Simpan struk pembayaran",
              "imageUrl": "assets/images/paymentlist/mbank_brimo_4.jpg",
            }
          ]
        },
      ]
    },
    {
      "id": 4,
      "isActive": true,
      "name": "BCA",
      "type": "Transfer Bank (Verifikasi Manual)",
      "description": "Transfer Bank BCA",
      "imageUrl": "assets/images/paymentlist/bca.png",
      "group": "TRANSFER_BANK",
      "provider": "xendit",
      "noPaymentText": "Nomor Kontrak",
      "noRekening": "0093045430",
      "imageClass": "bank_bca",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan Transfer Ke Rekening NSC, Konsumen wajib memberikan bukti transfer pembayarannya ke PIC/BM cabang terdekat"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "bankAccountNumber": "123 456 7899",
      "amount": 9999999,
      "steps": [
        {
          "text": "ATM BCA",
          "items": [
            {
              "title": "Masukkan PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_1.jpg",
            },
            {
              "title": "Pilih Transaksi Lainnya",
              "description": "Pilih menu Transaksi Lainnya pada layar ATM",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_2.jpg",
            },
            {
              "title": "Pilih Transfer",
              "description": "Pilih menu Transfer pada layar ATM",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_3.jpg",
            },
            {
              "title": "Pilih ke Rekening BCA",
              "description":
                  "Pilih menu Transaksi ke rekening BCA pada layar ATM",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_4.jpg",
            },
            {
              "title": "Masukan No Rek yang dituju",
              "description":
                  "Masukan No Rekening NSC Finance 009-304-5430 pada layar ATM",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_5.jpg",
            },
            {
              "title": "Masukan Nominal Transfer",
              "description":
                  "Masukan Nominal yang akan ditransfer dengan menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_6.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,klik Bayar, dan Simpan struk pembayaran.",
              "imageUrl": "assets/images/paymentlist/bca_atmmanual_7.jpg",
            }
          ]
        },
        {
          "text": "M-Banking",
          "items": [
            {
              "title": "Masuk aplikasi BCA Mobile, pilih m-BCA",
              "description":
                  "Masuk aplikasi BCA Mobile, pilih m-BCA pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_1.jpg",
            },
            {
              "title": "Pilih m-Transfer",
              "description":
                  "Pilih menu m-Transfer Lainnya pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_2.jpg",
            },
            {
              "title": "Pilih Menu Daftar Transfer dan Klik Antar Rekening",
              "description":
                  "Daftarkan dulu No. Rek tujuan dengan Pilih Menu Daftar Transfer dan Klik Antar Rekening pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_3.jpg",
            },
            {
              "title": "Masukan No. Rekening Tujuan",
              "description":
                  "Masukan No Rekening NSC Finance yaitu 009 304 5430,lalu klik Send",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_4.jpg",
            },
            {
              "title": "Ke Menu Transfer-> Antar Rekening,Klik Ke Rekening",
              "description":
                  "Pilih Menu Transfer,klik Antar Rekening lalu ke Rekening pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_5.jpg",
            },
            {
              "title": "Pilih Rekening NSC Finance",
              "description":
                  "Klik Rekening 'NUSA SURYA CIPTADANA PT' pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_6.jpg",
            },
            {
              "title": "Masukan Jumlah Tagihan",
              "description":
                  "Masukan jumlah tagihan sesuai pada angka tagihan,setelah itu kemudian klik 'SEND'",
              "imageUrl": "assets/images/paymentlist/bca_mbank_manual_7.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 44,
      "isActive": true,
      "name": "MANDIRI",
      "type": "Transfer Bank (Verifikasi Manual)",
      "description": "Transfer Bank MANDIRI",
      "imageUrl": "assets/images/paymentlist/bca.png",
      "group": "TRANSFER_BANK",
      "provider": "xendit",
      "imageClass": "bank_bca",
      "noPaymentText": "Nomor Kontrak",
      "noRekening": "1350015739055",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan Transfer Ke Rekening NSC, Konsumen wajib memberikan bukti transfer pembayarannya ke PIC/BM cabang terdekat"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "bankAccountNumber": "123 456 7899",
      "amount": 9999999,
      "steps": [
        {
          "text": "ATM MANDIRI",
          "items": [
            {
              "title": "Masukkan PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_1.jpg",
            },
            {
              "title": "Pilih Transaksi Lainnya",
              "description": "Pilih menu Transaksi Lainnya pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_2.jpg",
            },
            {
              "title": "Pilih Transfer",
              "description": "Pilih menu Transfer pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_3.jpg",
            },
            {
              "title": "Pilih ke Rekening MANDIRI",
              "description":
                  "Pilih menu Transaksi ke rekening BCA pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_4.jpg",
            },
            {
              "title": "Masukan No Rek yang dituju",
              "description":
                  "Masukan No Rekening NSC Finance 135 001 573 9055 pada menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_5.jpg",
            },
            {
              "title": "Masukan Nominal Transfer",
              "description":
                  "Masukan Nominal yang akan ditransfer dengan menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_6.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,klik Bayar, dan Simpan struk pembayaran.",
              "imageUrl": "assets/images/paymentlist/atm_mandiri_manuals_7.jpg",
            }
          ]
        },
        {
          "text": "Livin Mandiri",
          "items": [
            {
              "title": "Masuk aplikasi Livin, pilih Transfer Rupiah",
              "description":
                  "Masuk aplikasi Livin Mandiri, pilih Transfer Rupiah pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/livin_manual_1.jpg",
            },
            {
              "title": "Pilih Transfer ke Tujuan Baru",
              "description":
                  "Masukan Nama Tujuan Bank Mandiri dan No Rekening kemudian tap Lanjutkan pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/livin_manual_2.jpg",
            },
            {
              "title": "Konfirmasi Nama dan Rekening penerima",
              "description":
                  "Pastikan Nama dan Rekening Penerima adalah PT Nusa Surya Cipta (135.000.573.9055) sudah Sesuai kemudian tap Lanjut pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/livin_manual_3.jpg",
            },
            {
              "title": "Masukan Nominal",
              "description": "Masukkan Nominal Transfer kemudain tap Lanjut",
              "imageUrl": "assets/images/paymentlist/livin_manual_4.jpg",
            },
            {
              "title": "Masukan EPIN",
              "description": "PMasukan EPIN pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/livin_manual_5.jpg",
            },
            {
              "title": "Transfer berhasil",
              "description":
                  "Transfer berhasil swipe up lihat resi untuk melihat resi",
              "imageUrl": "assets/images/paymentlist/livin_manual_6.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 5,
      "isActive": true,
      "name": "BNI",
      "description": "Transfer Bank BNI",
      "type": "Transfer Bank (Verifikasi Manual)",
      "imageUrl": "assets/images/paymentlist/bni.png",
      "group": "TRANSFER_BANK",
      "provider": "xendit",
      "imageClass": "bank_bni",
      "noPaymentText": "Nomor Kontrak",
      "noRekening": "0029046089",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan Transfer Ke Rekening NSC, Konsumen wajib memberikan bukti transfer pembayarannya ke PIC/BM cabang terdekat"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "bankAccountNumber": "123 456 7899",
      "amount": 9999999,
      "steps": [
        {
          "text": "ATM BNI",
          "items": [
            {
              "title": "Masukkan Kartu ATM & PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_1.jpg",
            },
            {
              "title": "Pilih Menu Lain",
              "description": "Pilih menu lain pada layar ATM anda",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_2.jpg",
            },
            {
              "title": "Pilih Menu Transfer",
              "description": "Pilih menu Transfer pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_3.jpg",
            },
            {
              "title": "Pilih Rekening Tabungan",
              "description":
                  "Akan muncul pilihan Rekening mana,dan pilih Rekening Tabungan",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_4.jpg",
            },
            {
              "title": "Pilih Rekening BNI",
              "description": "Pilih rekening BNI pada layar mesin ATM anda",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_5.jpg",
            },
            {
              "title": "Masukan No Rek NSC Finance",
              "description":
                  "Masukkan No. Rek '002 904 6089' menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_6.jpg",
            },
            {
              "title": "Masukan Nominal Transfer",
              "description":
                  "Masukan Nominal yang akan ditransfer dengan menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_7.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,klik Bayar, dan Simpan struk pembayaran.",
              "imageUrl": "assets/images/paymentlist/atm_bni_manual_8.jpg",
            }
          ]
        },
        {
          "text": "BNI Mobile",
          "items": [
            {
              "title": "Masuk ke aplikasi BNI Mobile & Pilih 'TRANSFER'",
              "description":
                  "Masuk aplikasi BNI Mobile & Pilih 'TRANSFER' pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bnimo_manual_1.jpg",
            },
            {
              "title": "Klik Menu BNI",
              "description": "Klik Menu BNI pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bnimo_manual_2.jpg",
            },
            {
              "title": "Tekan Input Baru & isi No Rek Tujuan",
              "description":
                  "Tekan Input Baru dan isi rekening Tujuan '002 904 6089' pada layar Handphone anda",
              "imageUrl": "assets/images/paymentlist/bnimo_manual_3.jpg",
            },
            {
              "title": "Masukan Jumlah Tagihan",
              "description":
                  "Masukan Jumlah tagihan dan klik selanjutnya pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bnimo_manual_4.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran layar handphone anda,lalu masukkan PIN Transaksi dan bayar",
              "imageUrl": "assets/images/paymentlist/bnimo_manual_5.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 6,
      "isActive": true,
      "name": "BRI",
      "description": "Transfer Bank BRI",
      "type": "Transfer Bank (Verifikasi Manual)",
      "imageUrl": "assets/images/paymentlist/bri.png",
      "group": "TRANSFER_BANK",
      "provider": "xendit",
      "imageClass": "bank_bri",
      "fee": 2500,
      "noPaymentText": "Nomor Kontrak",
      "noRekening": "002008301001054305",
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah Transfer Ke Rekening NSC, Konsumen wajib memberikan bukti transfer bayar ke PIC/BM cabang terdekat"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "bankAccountNumber": "123 456 7899",
      "amount": 9999999,
      "steps": [
        {
          "text": "ATM BRI",
          "items": [
            {
              "title": "Masukkan Kartu ATM & PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_manual_1.jpg",
            },
            {
              "title": "Pilih Menu Transaksi Lainnya",
              "description": "Pilih menu Transaksi Lainnya pada layar ATM anda",
              "imageUrl": "assets/images/paymentlist/atm_bri_manual_2.jpg",
            },
            {
              "title": "Pilih Menu Transfer",
              "description": "Pilih menu Transfer pada layar ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_manual_3.jpg",
            },
            {
              "title": "Masukan Kode + No Rek NSC Finance",
              "description":
                  "Masukkan No. Rek '002 0083 0100 1054 305' menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_manual_4.jpg",
            },
            {
              "title": "Masukan Nominal Transfer",
              "description":
                  "Masukan Nominal yang akan ditransfer dengan menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/atm_bri_manual_5.jpg",
            },
            {
              "title": "Konfirmasi Data Transfer & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,klik Bayar, dan Simpan struk pembayaran.",
              "imageUrl": "assets/images/paymentlist/atm_bri_manual_6.jpg",
            }
          ]
        },
        {
          "text": "BRImo",
          "items": [
            {
              "title": "Masuk ke aplikasi BRImo & Pilih Transfer",
              "description": "Masuk aplikasi BRImo pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/brimo_manual_1.jpg",
            },
            {
              "title": "Klik Tambah Penerima",
              "description": "Klik Tambah Penerima pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/brimo_manual_2.jpg",
            },
            {
              "title": "Pilih Bank BRI",
              "description": "Klik Bank BRI pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/brimo_manual_3.jpg",
            },
            {
              "title": "Masukkan No Rek NSC Finance",
              "description":
                  "Masukkan No. Rek. NSC Finance '0083 0100 1054 305' pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/brimo_manual_4.jpg",
            },
            {
              "title": "Masukan Nominal & Klik Transfer",
              "description":
                  "Masukan Nominal Jumlah Angsuran pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/brimo_manual_5.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 7,
      "isActive": true,
      "name": "MANDIRI",
      "description": "Mandiri Virtual Account",
      "type": "Transfer Virtual Account",
      "imageUrl": "assets/images/paymentlist/mandiri.png",
      "group": "VIRTUAL_ACCOUNT",
      "provider": "xendit",
      "imageClass": "bank_mandiri",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "bankCode": "21008",
      "noPaymentText": "Nomor Virtual Account",
      "updatedAt": "2020-12-29 23:27:13",
      "bankAccountNumber": "123 456 7899",
      "amount": 9999999,
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Livin Mandiri",
          "items": [
            {
              "title": "Buka aplikasi Livin Mandiri",
              "description": "Masuk ke aplikasi Livin Mandiri anda",
              "imageUrl": "assets/images/paymentlist/tm_atm_livin_1.jpg",
            },
            {
              "title": "Pilih menu 'ANGSURAN' / 'PENCARIAN'",
              "description": "Pilih ke menu 'ANGSURAN' atau 'PENCARIAN'",
              "imageUrl": "assets/images/paymentlist/tm_atm_livin_2.jpg",
            },
            {
              "title": "Ketik NSC Finance di kolom pencarian",
              "description":
                  "Dalam kolom pencarian ketik perusahaan yang dituju 'NSC FINANCE' dan Pilih",
              "imageUrl": "assets/images/paymentlist/tm_atm_livin_3.jpg",
            },
            {
              "title": "Masukkan No Faktur",
              "description": "Masukkan No Faktur anda ",
              "imageUrl": "assets/images/paymentlist/tm_atm_livin_4.jpg",
            },
            {
              "title": "Konfirmasi Data",
              "description":
                  "Silahkan cek detail tagihan dan jumlah angsuran pada layar handphone",
              "imageUrl": "assets/images/paymentlist/tm_atm_livin_5.jpg",
            },
            {
              "title": "Klik Lanjutkan",
              "description":
                  "Klik 'Lanjutkan' untuk menyelesaikan pembayaran dan simpan bukti pembayaran",
              "imageUrl": "assets/images/paymentlist/tm_atm_livin_6.jpg",
            }
          ]
        },
        {
          "text": "ATM Mandiri",
          "items": [
            {
              "title": "Masukkan kartu debit Mandiri dan PIN",
              "description":
                  "Masukan kartu ATM anda dan masukan PIN menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_1.jpg",
            },
            {
              "title": "Pilih Bayar/Beli",
              "description": "Pilih menu Bayar/Beli pada layar ATM",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_2.jpg",
            },
            {
              "title": "Pilih Lainnya",
              "description": "Tekan pilihan “Lainnya” pada layar ATM",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_3.jpg",
            },
            {
              "title": "Pilih Lainnya Kembali",
              "description": "Tekan pilihan “Lainnya” pada layar ATM",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_4.jpg",
            },
            {
              "title": "Pilih  MultiPayment",
              "description": "Kemudian pilih MultiPayment pada layar ATM",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_5.jpg",
            },
            {
              "title": "Masukkan kode perusahaan yaitu 21008",
              "description":
                  "Masukkan kode 21008 (kode perusahaan NSC Finance)",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_6.jpg",
            },
            {
              "title": "Masukkan Nomor Kontrak",
              "description":
                  "Masukan Nomor Kontrak Anda menggunakan tombol di mesin ATM",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_7.jpg",
            },
            {
              "title": "Konfirmasi Data & Bayar",
              "description":
                  "Silahkan cek data transfer dan jumlah biaya angsuran pada layar ATM,jika benar klik Bayar dan Simpan struk pembayaran",
              "imageUrl": "assets/images/paymentlist/tm_atm_mandiri_8.jpg",
            }
          ]
        },
      ]
    },
    {
      "id": 8,
      "isActive": true,
      "name": "Alfamart",
      "description": "Alfamart",
      "type": "Tunai di Gerai Retail",
      "imageUrl": "assets/images/paymentlist/alfamart.png",
      "group": "GERAI",
      "provider": "xendit",
      "imageClass": "alfamart",
      "noPaymentText": "Nomor Kontrak",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Alfamart",
          "items": [
            {
              "title": "Datang ke Alfamart",
              "description": "Datang ke toko Alfamart terdekat",
              "imageUrl": "assets/images/paymentlist/alfamart_1.jpg",
            },
            {
              "title": "Infokan ke kasir bayar Angsuran NSC Finance",
              "description":
                  "Infokan ingin membayar angsuran NSC Finance dan sebutkan Nomor Faktur ke Kasir",
              "imageUrl": "assets/images/paymentlist/alfamart_2.jpg",
            },
            {
              "title": "Bayar dan Simpan bukti pembayaran",
              "description":
                  "Bayar sesuai dengan jumlah tagihan dan simpan bukti pembayaran",
              "imageUrl": "assets/images/paymentlist/alfamart_3.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 9,
      "isActive": true,
      "name": "Indomaret",
      "description": "Indomaret",
      "noPaymentText": "Nomor Kontrak",
      "type": "Tunai di Gerai Retail",
      "imageUrl": "assets/images/paymentlist/indomaret.png",
      "group": "GERAI",
      "provider": "xendit",
      "imageClass": "Indomaret",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Indomaret",
          "items": [
            {
              "title": "Datang ke Indomaret",
              "description": "Datang ke toko Indomaret terdekat",
              "imageUrl": "assets/images/paymentlist/indomaret_1.jpg",
            },
            {
              "title": "Infokan ke kasir bayar Angsuran NSC Finance",
              "description":
                  "Infokan ingin membayar angsuran NSC Finance dan sebutkan Nomor Faktur ke Kasir",
              "imageUrl": "assets/images/paymentlist/indomaret_2.jpg",
            },
            {
              "title": "Bayar dan Simpan bukti pembayaran",
              "description":
                  "Bayar sesuai dengan jumlah tagihan dan simpan bukti pembayaran",
              "imageUrl": "assets/images/paymentlist/indomaret_3.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 9,
      "isActive": true,
      "name": "Alfamidi",
      "description": "Alfamidi",
      "type": "Tunai di Gerai Retail",
      "imageUrl": "assets/images/paymentlist/alfamidi.png",
      "group": "GERAI",
      "provider": "xendit",
      "imageClass": "alfamidi",
      "noPaymentText": "Nomor Kontrak",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Indomaret",
          "items": [
            {
              "title": "Datang ke Alfamidi",
              "description": "Datang ke toko Alfamidi terdekat",
              "imageUrl": "assets/images/paymentlist/alfamidi_1.jpg",
            },
            {
              "title": "Infokan ke kasir bayar Angsuran NSC Finance",
              "description":
                  "Infokan ingin membayar angsuran NSC Finance dan sebutkan Nomor Faktur ke Kasir",
              "imageUrl": "assets/images/paymentlist/alfamidi_2.jpg",
            },
            {
              "title": "Bayar dan Simpan bukti pembayaran",
              "description":
                  "Bayar sesuai dengan jumlah tagihan dan simpan bukti pembayaran",
              "imageUrl": "assets/images/paymentlist/alfamidi_3.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 10,
      "isActive": true,
      "name": "Kantor Pos",
      "description": "Kantor Pos",
      "type": "Tunai di Gerai Retail",
      "imageUrl": "assets/images/paymentlist/posindonesia.png",
      "group": "GERAI",
      "provider": "xendit",
      "imageClass": "kantor pos",
      "noPaymentText": "Nomor Kontrak",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Pos Indonesia",
          "items": [
            {
              "title": "Datang ke Kantor Pos",
              "description": "Kunjungi kantor Pos Indonesia terdekat",
              "imageUrl": "assets/images/paymentlist/pos_1.jpg",
            },
            {
              "title": "Infokan ke petugas bayar Angsuran NSC Finance",
              "description":
                  "Infokan ingin membayar angsuran NSC Finance dan sebutkan Nomor Faktur ke petugas",
              "imageUrl": "assets/images/paymentlist/pos_2.jpg",
            },
            {
              "title": "Bayar dan Simpan bukti pembayaran",
              "description":
                  "Bayar sesuai dengan jumlah tagihan dan simpan bukti pembayaran",
              "imageUrl": "assets/images/paymentlist/pos_3.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 12,
      "isActive": true,
      "name": "DANA",
      "description": "DANA",
      "type": "Dompet Digital",
      "imageUrl": "assets/images/paymentlist/dana.png",
      "group": "E-WALLET",
      "provider": "xendit",
      "imageClass": "alfamidi",
      "noPaymentText": "Nomor Kontrak",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "DANA",
          "items": [
            {
              "title": "Buka Aplikasi DANA & Pilih Lihat Semua",
              "description":
                  "Buka Aplikasi DANA dan Pilih menu Lihat Semua pada handphone anda",
              "imageUrl": "assets/images/paymentlist/dana_1.jpg",
            },
            {
              "title": "Pilih Menu Cicilan",
              "description": "Pilih menu Cicilan pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/dana_2.jpg",
            },
            {
              "title": "Ketik NSC",
              "description":
                  "Ketik & Pilih NSC didalam kolom pencarian di handphone anda",
              "imageUrl": "assets/images/paymentlist/dana_3.jpg",
            },
            {
              "title": "Masukkan ID Pelanggan",
              "description":
                  "Masukkan ID Pelanggan/Nomor Kontrak anda dan Klik 'CEK TAGIHAN'",
              "imageUrl": "assets/images/paymentlist/dana_4.jpg",
            },
            {
              "title": "Konfirmasi data detail Pembayaran",
              "description":
                  "Akan muncul detail pembayaran angsuran NSC Finance,Lalu Klik Konfirmasi",
              "imageUrl": "assets/images/paymentlist/dana_5.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 13,
      "isActive": true,
      "name": "GO BILLS",
      "description": "GO BILLS",
      "noPaymentText": "Nomor Kontrak",
      "type": "Dompet Digital",
      "imageUrl": "assets/images/paymentlist/gobills.png",
      "group": "E-WALLET",
      "provider": "xendit",
      "imageClass": "gojek",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "GO BILLS",
          "items": [
            {
              "title": "Buka Aplikasi Gojek & Pilih Go Tagihan",
              "description":
                  "Buka Aplikas Gojek & Pilih menu Go Tagihan pada handphone anda",
              "imageUrl": "assets/images/paymentlist/gobills_1.jpg",
            },
            {
              "title": "Klik menu pencarian",
              "description":
                  "Pilih menu kolom pencarian pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/gobills_2.jpg",
            },
            {
              "title": "Ketik NSC Finance",
              "description":
                  "Ketik & Pilih NSC Finance didalam kolom pencarian di handphone anda",
              "imageUrl": "assets/images/paymentlist/gobills_3.jpg",
            },
            {
              "title": "Masukkan ID Pelanggan",
              "description":
                  "Masukkan ID Pelanggan/Nomor Kontrak anda dan Klik Lanjut",
              "imageUrl": "assets/images/paymentlist/gobills_4.jpg",
            },
            {
              "title": "Konfirmasi data detail Pembayaran",
              "description":
                  "Akan muncul detail pembayaran angsuran NSC Finance,Lalu Klik Bayar Sekarang",
              "imageUrl": "assets/images/paymentlist/gobills_5.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 15,
      "isActive": true,
      "name": "Tokopedia",
      "description": "Tokopedia",
      "type": "E-Commerce",
      "imageUrl": "assets/images/paymentlist/tokopedia.png",
      "group": "E-COMMERCE",
      "noPaymentText": "Nomor Kontrak",
      "provider": "Tokopedia",
      "imageClass": "tokopedia",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Tokopedia",
          "items": [
            {
              "title":
                  "Buka Aplikasi Tokopedia & Pilih Menu Top-Up dan Tagihan",
              "description":
                  "Buka Aplikas Tokopedia & Pilih Menu Top-Up dan Tagihan pada handphone anda",
              "imageUrl": "assets/images/paymentlist/tokped_1.jpg",
            },
            {
              "title": "Klik menu pencarian",
              "description":
                  "Pilih menu kolom pencarian di bagian atas pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/tokped_2.jpg",
            },
            {
              "title": "Ketik NSC Finance",
              "description":
                  "Ketik & Pilih NSC Finance didalam kolom pencarian di handphone anda",
              "imageUrl": "assets/images/paymentlist/tokped_3.jpg",
            },
            {
              "title": "Masukkan No Kontrak",
              "description": "Masukkan Nomor Kontrak anda dan Klik Cek Tagihan",
              "imageUrl": "assets/images/paymentlist/tokped_4.jpg",
            },
            {
              "title": "Konfirmasi data detail Pembayaran",
              "description":
                  "Akan muncul detail pembayaran angsuran NSC Finance, lanjutkan dengan Pilih Pembayaran",
              "imageUrl": "assets/images/paymentlist/tokped_5.jpg",
            },
            {
              "title": "Konfirmasi Info Pembayaran lalu pilih Bayar",
              "description":
                  "Akan keluar Info Pembayaran sesuai dengan pilihan jenis pembayaran yang dipilih sebelumnya. Isi data Info Pembayaran, dan pilih Bayar",
              "imageUrl": "assets/images/paymentlist/tokped_6.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 14,
      "isActive": true,
      "name": "Shopee",
      "description": "Shopee",
      "type": "E-Commerce",
      "imageUrl": "assets/images/paymentlist/shopee.png",
      "group": "E-COMMERCE",
      "noPaymentText": "Nomor Kontrak",
      "provider": "xendit",
      "imageClass": "Shopee",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Shopee",
          "items": [
            {
              "title":
                  "Buka Aplikasi Shopee & Pilih menu Pulsa,Tagihan, dan Tiket",
              "description":
                  "Buka Aplikas Shopee dan Pilih Menu Pulsa,Tagihan, dan Tiket pada handphone anda",
              "imageUrl": "assets/images/paymentlist/shopee_1.jpg",
            },
            {
              "title": "Pilih Angsuran Kredit",
              "description":
                  "Klik menu Angsuran Kredit pada panel Tagihan di layar handphone anda",
              "imageUrl": "assets/images/paymentlist/shopee_2.jpg",
            },
            {
              "title": "Pilih NSC Finance",
              "description":
                  "Ketik & Pilih NSC Finance di layar handphone anda",
              "imageUrl": "assets/images/paymentlist/shopee_3.jpg",
            },
            {
              "title": "Masukkan No Pelanggan/Faktur/ Kontrak",
              "description":
                  "Masukkan No Pelanggan/ Faktur / Kontrak pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/shopee_4.jpg",
            },
            {
              "title": "Konfirmasi data detail Pembayaran",
              "description":
                  "Akan muncul detail pembayaran angsuran NSC Finance, lalu klik lanjutkan",
              "imageUrl": "assets/images/paymentlist/shopee_5.jpg",
            },
          ]
        },
      ]
    },
    {
      "id": 15,
      "isActive": true,
      "name": "Bukalapak",
      "description": "Bukalapak",
      "type": "E-Commerce",
      "imageUrl": "assets/images/paymentlist/bukalapak.png",
      "group": "E-COMMERCE",
      "provider": "Bukalapak",
      "imageClass": "bukalapak",
      "noPaymentText": "Nomor Kontrak",
      "fee": 2500,
      "createdAt": "2020-12-29 23:27:13",
      "updatedAt": "2020-12-29 23:27:13",
      "info": {
        "title": "Penting !",
        "description":
            "Setelah melakukan pembayaran,Pada umumnya pembayaran akan diterima dalam waktu 1x24 jam"
      },
      "infoTransfer": {
        "title": "Penting !",
        "description":
            "1. Pastikan Nama & No. Rekening sesuai buku Tabungan\n2. Pastikan bukti pembayaran menampilkan\n - Tanggal/Waktu Transfer\n - Status Berhasil\n - Detail Penerima\n - Jumlah Transfer"
      },
      "steps": [
        {
          "text": "Bukalapak",
          "items": [
            {
              "title": "Buka Aplikasi Bukalapak dan Pilih Menu Tagihan",
              "description":
                  "Buka Aplikasi Bukalapak dan Pilih Menu Tagihan pada handphone anda",
              "imageUrl": "assets/images/paymentlist/bukalapak_1.jpg",
            },
            {
              "title": "Klik menu Angsuran Kredit",
              "description":
                  "Klik menu Angsuran Kredit pada layar handphone anda",
              "imageUrl": "assets/images/paymentlist/bukalapak_2.jpg",
            },
            {
              "title":
                  "Ketik Nusa Surya Ciptadana Finance pada kolom penyedia jasa",
              "description":
                  "Pada kolom penyedia jasa, silahkan ketik “Nusa Surya Ciptadana Finance”.",
              "imageUrl": "assets/images/paymentlist/bukalapak_3.jpg",
            },
            {
              "title": "Masukkan No Pelanggan & Konfirmasi Pembayaran",
              "description":
                  "Isi nomor pelanggan pada kolom yang ada di dibawahnya. Pastikan bamaa noomor pelanggan yang Anda isi sudah sesuai.Lalu klik Bayar",
              "imageUrl": "assets/images/paymentlist/bukalapak_4.jpg",
            },
          ]
        },
      ]
    },
  ];

  dynamic onBoardingAgen = [
    {
      "id": 1,
      "isActive": true,
      "name": "Biaya daftar gratis, Syarat Mudah,dan Tanpa Ribet",
      "description":
          "Pendaftaran tanpa biaya sepeserpun dan syarat cuma punya aplikasi online saja",
    },
    {
      "id": 2,
      "isActive": true,
      "name": "Kerja dari mana saja dan Tidak terbebani target",
      "description":
          "Mengijinkan sobat untuk kerja darimana saja dan tidak memberikan target apapun"
    },
    {
      "id": 3,
      "isActive": true,
      "name": "Memberikan Reward & Benefit yang gak habis - habis",
      "description":
          "Dapatkan Reward dan Benefit yang melimpah dengan syarat yang mudah dan cepat cair"
    },
  ];

  dynamic onBoardings = [
    {
      "id": 1,
      "isActive": true,
      "title": "Halo",
      "description":
          "Selamat datang di aplikasi mobile KlikNSS, temukan layanan seputar motor Honda disini...",
      "images_bg": "assets/images/onboarding/onboardings_1.png",
      "images_obj": "assets/images/onboarding/onboardings_1_obj.png"
    },
    {
      "id": 2,
      "isActive": true,
      "title": "Pengajuan Sepeda Motor",
      "description":
          "Dapatkan motor honda impianmu, lakukan pengajuan di KlikNSS.",
      "images_bg": "assets/images/onboarding/onboardings_2.png",
      "images_obj": "assets/images/onboarding/onboardings_2_obj.png"
    },
    {
      "id": 3,
      "isActive": true,
      "title": "Pembiayaan Dana",
      "description":
          "Butuh dana untuk mengembangkan usaha, renovasi rumah, biaya kesahatan, biaya pendidikan atau rekreasi bareng keluarga? KlikNSS menawarkan fasilitas.",
      "images_bg": "assets/images/onboarding/onboardings_3.png",
      "images_obj": "assets/images/onboarding/onboardings_3_obj.png"
    },
    {
      "id": 4,
      "isActive": true,
      "title": "Sparepart",
      "description":
          "Kamu dapat melakukan pembelian sepeda motor honda disini.",
      "images_bg": "assets/images/onboarding/onboardings_4.png",
      "images_obj": "assets/images/onboarding/onboardings_4_obj.png"
    },
    {
      "id": 5,
      "isActive": true,
      "title": "Booking Servis",
      "description":
          "Kamu dapat mengambil antrian secara online dengan Booking Service.",
      "images_bg": "assets/images/onboarding/onboardings_5.png",
      "images_obj": "assets/images/onboarding/onboardings_5_obj.png"
    },
    {
      "id": 6,
      "isActive": true,
      "title": "Cek Status & Historis",
      "description":
          "Kamu dapat cek status pengajuan,pesanan, dan juga history Booking Service.",
      "images_bg": "assets/images/onboarding/onboardings_6.png",
      "images_obj": "assets/images/onboarding/onboardings_6_obj.png"
    },
  ];

  dynamic voucherBusiness = [
    {
      "id": 1,
      "businessId": 1,
      "isActive": true,
      "colorActive": Constants.primaryColor,
      "colorInActive": Constants.primaryColor.withOpacity(0.5),
      "title": "Motor",
      "description":
          "Selamat datang di aplikasi mobile KlikNSS, temukan layanan seputar motor Honda disini...",
      "images_bg": "assets/images/onboarding/onboardings_1.png",
      "images_obj": "assets/images/onboarding/onboardings_1_obj.png"
    },
    {
      "id": 2,
      "businessId": 3,
      "isActive": true,
      "colorActive": Constants.sky,
      "colorInActive": Constants.sky.withOpacity(0.5),
      "title": "Pembiayaan Motor",
      "description":
          "Dapatkan motor honda impianmu, lakukan pengajuan di KlikNSS.",
      "images_bg": "assets/images/onboarding/onboardings_2.png",
      "images_obj": "assets/images/onboarding/onboardings_2_obj.png"
    },
    {
      "id": 3,
      "businessId": 4,
      "isActive": true,
      "colorActive": Constants.yellow,
      "colorInActive": Constants.yellow.withOpacity(0.5),
      "title": "Pembiayaan Mobil",
      "description":
          "Butuh dana untuk mengembangkan usaha, renovasi rumah, biaya kesahatan, biaya pendidikan atau rekreasi bareng keluarga? KlikNSS menawarkan fasilitas.",
      "images_bg": "assets/images/onboarding/onboardings_3.png",
      "images_obj": "assets/images/onboarding/onboardings_3_obj.png"
    },
    {
      "id": 4,
      "businessId": 2,
      "isActive": true,
      "colorActive": Constants.orange,
      "colorInActive": Constants.orange.withOpacity(0.5),
      "title": "Sparepart",
      "description":
          "Kamu dapat melakukan pembelian sepeda motor honda disini.",
      "images_bg": "assets/images/onboarding/onboardings_4.png",
      "images_obj": "assets/images/onboarding/onboardings_4_obj.png"
    },
    {
      "id": 5,
      "businessId": 8,
      "isActive": true,
      "colorActive": Constants.lime,
      "colorInActive": Constants.lime.withOpacity(0.5),
      "title": "Booking Servis",
      "description":
          "Kamu dapat mengambil antrian secara online dengan Booking Service.",
      "images_bg": "assets/images/onboarding/onboardings_5.png",
      "images_obj": "assets/images/onboarding/onboardings_5_obj.png"
    },
  ];

  dynamic pageWarning = [
    {
      "id": 1,
      "type": "warning",
      "isActive": true,
      "name": "Memberikan Reward & Benefit yang gak habis - habis",
      "description":
          "Hati - hati terhadap penipuan yang mengatasnamakan klikNSC dengan mengirim link download aplikasi lewat chat / email."
    },
    {
      "id": 2,
      "type": "info",
      "isActive": true,
      "name": "Biaya daftar gratis, Syarat Mudah,dan Tanpa Ribet",
      "description":
          "Pendaftaran tanpa biaya sepeserpun dan syarat cuma punya aplikasi online saja dengan mudah dan tanpa ribet sana sini",
    },
    {
      "id": 3,
      "type": "info",
      "isActive": true,
      "name": "Kerja dari mana saja dan Tidak terbebani target",
      "description":
          "Mengijinkan sobat untuk kerja darimana saja dan tidak memberikan target apapun didalam bekerja. bekerja dengan hati yang senang "
    },
    {
      "id": 4,
      "type": "info",
      "isActive": true,
      "name": "Memberikan Reward & Benefit yang gak habis - habis",
      "description":
          "Dapatkan Reward dan Benefit yang melimpah dengan syarat yang mudah dan cepat cair, komisi yang ga habis habis"
    },
  ];
  List<String>? bubbleChat = [
    "Halo mau kredit dong",
    "Stock ready ?",
    "Bisa dikirim hari ini ?",
    "Terima kasih",
  ];

  // KlikNSC
  dynamic daftarBank = [
    {
      "id": 1,
      "name": "ANZ_INDONESIA",
      "alias": "PT BANK ANZ INDONESIA",
      "code": "0306"
    },
    {
      "id": 2,
      "name": "BAG_INTERNASIONAL",
      "alias": "PT BANK ARTHA GRAHA INTERNASIONAL",
      "code": "0028"
    },
    {
      "id": 3,
      "name": "BANGKOK_BANK",
      "alias": "BANGKOK BANK PUBLIC CO.LTD",
      "code": "0309"
    },
    {
      "id": 4,
      "name": "BANK_ACEH",
      "alias": "PT BANK ACEH SYARIAH",
      "code": "9900"
    },
    {
      "id": 5,
      "name": "BANK_ALADIN_SYARIAH",
      "alias": "BANK_ALADIN_SYARIAH",
      "code": "0302"
    },
    {
      "id": 6,
      "name": "BANK_ALLO",
      "alias": "PT. ALLO BANK INDONESIA",
      "code": "0011"
    },
    {
      "id": 7,
      "name": "BANK_AMAR",
      "alias": "PT BANK AMAR INDONESIA",
      "code": "0012"
    },
    {
      "id": 8,
      "name": "BANK_BCA_SYARIAH",
      "alias": "PT BANK BCA SYARIAH",
      "code": "0017"
    },
    {
      "id": 9,
      "name": "BANK_BENGKULU",
      "alias": "PT BPD BENGKULU",
      "code": "0012"
    },
    {
      "id": 10,
      "name": "BANK_BISNIS",
      "alias": "PT BANK BISNIS INTERNASIONAL",
      "code": "0011"
    },
    {
      "id": 11,
      "name": "BANK_BNI",
      "alias": "PT BANK NEGARA INDONESIA",
      "code": "0010"
    },
    {
      "id": 12,
      "name": "BANK_BPD_DIY",
      "alias": "PT BANK PEMBANGUNAN DAERAH YOGYAKARTA",
      "code": "0015"
    },
    {
      "id": 13,
      "name": "BANK_BPD_DIY_UUS",
      "alias": "PT BANK PEMBANGUNAN DAERAH YOGYAKARTA",
      "code": "9922"
    },
    {
      "id": 14,
      "name": "BANK_BSI",
      "alias": "PT BANK SYARIAH INDONESIA",
      "code": "0051"
    },
    {
      "id": 15,
      "name": "BANK_BTPN",
      "alias": "PT BANK BTPN SYARIAH",
      "code": "0046"
    },
    {
      "id": 16,
      "name": "BANK_CAPITAL",
      "alias": "PT BANK CAPITAL INDONESIA",
      "code": "0308"
    },
    {
      "id": 17,
      "name": "BANK_CIMB",
      "alias": "PT BANK CIMB NIAGA TBK",
      "code": "0026"
    },
  ];
  dynamic pekerjaan = [
    {
      "id": 1,
      "name": "AGEN",
      "subPekerjaan": [
        {"id": 101, "name": "AGEN OTOMOTIF", "code": "AG1"},
        {"id": 101, "name": "AGEN FINANCE", "code": "AG2"},
        {"id": 101, "name": "AGEN OTOMOTIF DAN FINANCE", "code": "AG3"},
        {"id": 101, "name": "AGEN MAKANAN", "code": "AG4"},
        {"id": 101, "name": "AGEN NON MAKANAN", "code": "AG5"},
      ]
    },
    {
      "id": 1,
      "name": "PEDAGANG",
      "subPekerjaan": [
        {"id": 101, "name": "PEDAGANG MAKANAN PUNYA TEMPAT", "code": "DG1"},
        {"id": 101, "name": "PEDAGANG MAKANAN KELILING", "code": "DG2"},
        {"id": 101, "name": "PEDAGANG NON MAKANAN", "code": "DG3"},
      ]
    },
  ];

  dynamic jenisKelamin = [
    {"id": 1, "name": "Laki - Laki", "code": "M"},
    {"id": 2, "name": "Perempuan", "code": "F"},
  ];
  dynamic npwp = [
    {"id": 1, "name": "Ya", "code": "1"},
    {"id": 2, "name": "Tidak", "code": "2"},
  ];

  dynamic pengalaman = [
    {"id": 1, "name": "Ya", "code": "1"},
    {"id": 2, "name": "Tidak", "code": "2"},
  ];

  dynamic subPengalaman = [
    {"id": 1, "name": "1-2 Unit", "code": "1-2"},
    {"id": 2, "name": "3-10 Unit", "code": "3-10"},
    {"id": 2, "name": "Lebih Dari 10 Unit", "code": ">10"},
  ];

  dynamic wargaNegara = [
    {"id": 1, "name": "Warga Negara Indonesia", "code": "WNI"},
    {"id": 2, "name": "Warga Negara Asing", "code": "WNA"},
  ];

  dynamic marriageStatus = [
    {"id": 1, "name": "BELUM KAWIN", "code": "BELUM KAWIN"},
    {"id": 2, "name": "KAWIN", "code": "KAWIN"},
    {"id": 3, "name": "DUDA", "code": "DUDA"},
    {"id": 4, "name": "JANDA", "code": "JANDA"},
  ];

  dynamic golDarah = [
    {"id": 1, "name": "A", "code": "A"},
    {"id": 2, "name": "B", "code": "B"},
    {"id": 3, "name": "AB", "code": "AB"},
    {"id": 4, "name": "O", "code": "O"},
    {"id": 5, "name": "TIDAK TAHU", "code": "TIDAK TAHU"},
  ];

  dynamic agama = [
    {"id": 1, "name": "ISLAM", "code": "ISLAM"},
    {"id": 4, "name": "HINDU", "code": "HINDU"},
    {"id": 5, "name": "BUDHA", "code": "BUDHA"},
    {"id": 3, "name": "KATOLIK", "code": "KATOLIK"},
    {"id": 6, "name": "KONGHUCHU", "code": "KONGHUCHU"},
    {"id": 2, "name": "KRISTEN", "code": "KRISTEN"},
    {"id": 7, "name": "LAIN-LAIN", "code": "LAIN-LAIN"},
  ];
  dynamic sourceMedium = [
    {
      "id": 1,
      "name": "Facebook",
    },
    {
      "id": 2,
      "name": "Instagram",
    },
    {
      "id": 3,
      "name": "TikTok",
    },
    {
      "id": 4,
      "name": "Youtube",
    },
    {
      "id": 5,
      "name": "Whatsapp",
    },
    {
      "id": 6,
      "name": "Teman/Kerabat",
    },
    {
      "id": 7,
      "name": "Karyawan_NS_Group",
    },
  ];
  dynamic post = {
    "noHp": "082135388068",
    // 1 perorangan, 2 corporate
    "typeAgen": 1,
    "referral": "",
    "noKtp": "3374000011112222",
    "name": "BAGAS DANY",
    // 1 ya , 2 tidak
    "hasNPWP": 1,

    "noNPWP": "111122223333444",
    "cityBorn": "Kota Semarang",
    //dateofBorn
    "dob": "10051997",
    "gender": "L",
    "bloodType": "B",
    "bankCode": "0010",
    "noRekening": "1229290393",
    "namaRekening": "BAGAS DANY",
    "email": "Bagasdany7777@gmail.com",
    "address": "jl anggrek",
    "rt": "001",
    "rw": "002",
    "provinceId": 20,
    "cityId": 158,
    "kecamatanId": 1000,
    "kelurahanId": 2101,
    "postalCode": "23930",
    "religion": "ISLAM",
    "pekerjaan": "AGEN",
    "status": "Kawin",
    "citizen": "WNI",
    // 1 ya, 2 tidak
    "hasExperience": 1,
    "saleAmount": "1-2 = 1-2 Unit",
    "sourceMedium": "Instagram"
  };
  dynamic detailComissionwithPagination = {
    "commission": [
      {
        "status": "Cair",
        "description": "Detail Komisi Cair",
        "totalCommission": 2000000,
        "items": [
          {
            "id": 10000,
            "type": "Personal",
            "bisnis": "Motor",
            "totalCommission": 200000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10001,
            "type": "Personal",
            "bisnis": "Pembiayaan Motor",
            "totalCommission": 200000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10002,
            "type": "Personal",
            "bisnis": "Pembiayaan Mobil",
            "totalCommission": 300000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10003,
            "type": "Personal",
            "bisnis": "Sparepart",
            "totalCommission": 0,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10004,
            "type": "Team",
            "bisnis": "Motor",
            "totalCommission": 300000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10005,
            "type": "Team",
            "bisnis": "Pembiayaan Motor",
            "totalCommission": 200000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10006,
            "type": "Team",
            "bisnis": "Pembiayaan Mobil",
            "totalCommission": 400000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10007,
            "type": "Team",
            "bisnis": "Sparepart",
            "totalCommission": 0,
            "imageUrl": "123.jpg"
          },
        ],
        "id": 41259,
        "dateRange": "31022023-20042023",
        "comissionLastMonth": 300000,
      },
      {
        "status": "Belum Cair",
        "description": "Detail Komisi Belum Cair",
        "totalCommission": 2000000,
        "items": [
          {
            "id": 10010,
            "type": "Personal",
            "bisnis": "Motor",
            "totalCommission": 200000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10011,
            "type": "Personal",
            "bisnis": "Pembiayaan Motor",
            "totalCommission": 200000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10012,
            "type": "Personal",
            "bisnis": "Pembiayaan Mobil",
            "totalCommission": 300000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10013,
            "type": "Personal",
            "bisnis": "Sparepart",
            "totalCommission": 0,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10014,
            "type": "Team",
            "bisnis": "Motor",
            "totalCommission": 300000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10015,
            "type": "Team",
            "bisnis": "Pembiayaan Motor",
            "totalCommission": 200000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10016,
            "type": "Team",
            "bisnis": "Pembiayaan Mobil",
            "totalCommission": 400000,
            "imageUrl": "123.jpg"
          },
          {
            "id": 10017,
            "type": "Team",
            "bisnis": "Sparepart",
            "totalCommission": 0,
            "imageUrl": "123.jpg"
          },
        ],
        "id": 41260,
        "dateRange": "31022023-20042023",
        "comissionLastMonth": 300000,
      },
    ],
    "page": 1,
    "maxPage": 1,
    "count": 1,
    "itemsPerPage": 12
  };

  dynamic listComissionwithPagination = {
    "commission": {
      "title": "Detail Komisi Sudah Cair",
      "description": "Semua Komisi Sudah Cair",
      "totalCommission": 2000000,
      "totalTransaction": 18,
      "items": [
        {
          "id": 10102,
          "name": "Ade Holid",
          "type": "Team",
          "bisnis": "Motor",
          "noKontrak": "100878909290",
          "totalCommission": 200000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10103,
          "name": "Isticharoh",
          "type": "Personal",
          "bisnis": "Motor",
          "noKontrak": "100878909293",
          "totalCommission": 100000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10104,
          "name": "Bagas Dany Aradhana",
          "type": "Team",
          "bisnis": "Motor",
          "noKontrak": "100878909290",
          "totalCommission": 300000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10105,
          "name": "Bagas Dany Aradhana",
          "type": "Personal",
          "bisnis": "Pembiayaan Motor",
          "noKontrak": "100878909290",
          "totalCommission": 300000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10105,
          "name": "Bagas Dany Aradhana",
          "type": "Team",
          "bisnis": "Pembiayaan Motor",
          "noKontrak": "100878909290",
          "totalCommission": 200000,
          "imageUrl": "123.jpg"
        },
      ],
      "id": 41259,
      "dateRange": "31022023-20042023",
      "comissionLastMonth": 300000,
    },
    "page": 1,
    "maxPage": 1,
    "count": 1,
    "itemsPerPage": 12
  };
  dynamic trackingHistory = {
    "id": 102889,
    "code": "11230402247",
    "status": 18,
    "statusText": "Motor sudah Terkirim",
    "tracking": [
      {"completed": 1, "text": "Pengajuan Terkirim", "date": "3 Apr 23 00:00"},
      {"completed": 1, "text": "Dalam Proses", "date": "4 Apr 23 00:00"},
      {"completed": 1, "text": "Pengajuan Disetujui", "date": "4 Apr 23 04:00"},
      {
        "completed": 1,
        "text": "Motor Sedang Disiapkan",
        "date": "4 Apr 23 08:00"
      },
      {
        "completed": 0,
        "text": "Motor Dalam Pengiriman",
        "date": "4 Apr 23 12:00"
      },
      {"completed": 0, "text": "Motor sudah Terkirim", "date": "5 Apr 23 00:00"}
    ],
    "fields": [
      {"text": "Tanggal", "value": "3 Apr 23 00:00"}
    ],
    "logs": []
  };
  dynamic teamList = {
    "team": {
      "title": "Team Saya",
      "totalTransaction": 30,
      "totalMember": 7,
      "totalCommission": 1500000,
      "id": 41259,
      "dateRange": "31022023-20042023",
      "memberTeam": [
        {
          "id": 10102,
          "name": "Megaa chan",
          "totalTransaction": 5,
          "totalCommission": 200000
        },
        {
          "id": 10103,
          "name": "Mahfud D. Luffy",
          "totalTransaction": 5,
          "totalCommission": 300000
        },
        {
          "id": 10104,
          "name": "Puan Matahari",
          "totalTransaction": 5,
          "totalCommission": 400000
        },
        {
          "id": 10105,
          "name": "Ganjar Pribadi",
          "totalTransaction": 5,
          "totalCommission": 100000
        },
        {
          "id": 10106,
          "name": "Pra bowo",
          "totalTransaction": 5,
          "totalCommission": 300000
        },
      ],
    },
    "page": 1,
    "maxPage": 1,
    "count": 5,
    "itemsPerPage": 12
  };
  dynamic getDetailTeamMemberTransaction = {
    "team": {
      "id": 41259,
      "memberName": "Megaaa chann",
      "totalCommission": 40000,
      "totalTransaction": 5,
      "dateRange": "31022023-20042023",
      "items": [
        {
          "id": 10102,
          "name": "Ade Holid",
          "type": "Team",
          "bisnis": "Motor",
          "noKontrak": "100878909290",
          "totalCommission": 100000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10103,
          "name": "Isticharoh",
          "type": "Personal",
          "bisnis": "Motor",
          "noKontrak": "100878909293",
          "totalCommission": 50000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10104,
          "name": "Bagas Dany Aradhana",
          "type": "Team",
          "bisnis": "Motor",
          "noKontrak": "100878909290",
          "totalCommission": 100000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10105,
          "name": "Bagas Dany Aradhana",
          "type": "Personal",
          "bisnis": "Pembiayaan Motor",
          "noKontrak": "100878909290",
          "totalCommission": 50000,
          "imageUrl": "123.jpg"
        },
        {
          "id": 10105,
          "name": "Bagas Dany Aradhana",
          "type": "Team",
          "bisnis": "Pembiayaan Motor",
          "noKontrak": "100878909290",
          "totalCommission": 100000,
          "imageUrl": "123.jpg"
        },
      ],
    },
    "page": 1,
    "maxPage": 1,
    "count": 1,
    "itemsPerPage": 12
  };
  dynamic postAgenUpdate = {
    "noHp": "082135388068",
    // 1 perorangan, 2 corporate
    "typeAgen": 1,
    "referral": "",
    "noKtp": "3374000011112222",
    "name": "BAGAS DANY",
    // 1 ya , 2 tidak
    "hasNPWP": 1,

    "noNPWP": "111122223333444",
    "cityBorn": "Kota Semarang",
    //dateofBorn
    "dob": "10051997",
    "gender": "L",
    "bloodType": "B",
    "bankCode": "0010",
    "noRekening": "1229290393",
    "namaRekening": "BAGAS DANY",
    "email": "Bagasdany7777@gmail.com",
    "address": "jl anggrek",
    "rt": "001",
    "rw": "002",
    "provinceId": 20,
    "cityId": 158,
    "kecamatanId": 1000,
    "kelurahanId": 2101,
    "postalCode": "23930",
    "religion": "ISLAM",
    "pekerjaan": "AGEN",
    "status": "Kawin",
    "citizen": "WNI",
    // 1 ya, 2 tidak
    "hasExperience": 1,
    "saleAmount": "1-2 = 1-2 Unit",
    "sourceMedium": "Instagram"
  };
  dynamic infoAgen = {
    "status": "AKTIF",
    "noHp": "082135388068",
    "typeAgen": "perorangan",
    "referralLink": "https://kliknsc.co.id/?qr=5.2181.ftmno4=082135388068",
    "noKtp": "3374000011112222",
    "name": "BAGAS DANY",
    "level": "Gold",
    "UplineName": "Andi Wijaya",
    "referralUpline": "1931501",
    "noHpUpline": "0866666666677",
    "cabangCode": "KGW31",
    "cabangName": "Kaligawe",
    "statusValidasi Rek": null,
    "noNPWP": "1111xxxxxxx444",
    "cityBorn": "Kota Semarang",
    "dob": "10051997",
    "gender": "L",
    "bloodType": "B",
    "bankCode": "0010",
    "bank": "PT. BANK CENTRAL ASIA",
    "noRekening": "1229290393",
    "namaRekening": "BAGAS DANY",
    "email": "Bagasdany7777@gmail.com",
    "address": "jl anggrek",
    "rt": "001",
    "rw": "002",
    "provinceId": 20,
    "provinceName": "DKI Jakarta",
    "cityId": 158,
    "cityName": "Jakarta Barat",
    "kecamatanId": 1000,
    "kecamatanName": "Mangga Besar",
    "kelurahanId": 2101,
    "kelurahanName": "Tamansari",
    "postalCode": "23930",
    "religion": "ISLAM",
    "pekerjaan": "AGEN",
    "statusMarriage": "Kawin",
    "citizen": "WNI",
    "hasExperience": 1,
    "saleAmount": "1-2 = 1-2 Unit",
    "sourceMedium": "Instagram"
  };
  dynamic postDataHMC = {
    "id": 10012,
    "customerName": "bagas dany aradhana",
    "customerKtpNumber": "3374071005970007",
    "customerPhone": "082135388068",
    "deliveryAddress": "Jl Buni No 4",
    'deliveryProvinceId': 22,
    'deliveryCityId': 220,
    'deliveryKecamatanId': 1003,
    'deliveryKelurahanId': 1300,
    'deliveryPostalCode': "14411",
    'deliveryRt': 003,
    'deliveryRw': 002,
    "files": "customerKtpImage,refCustomerKtpImage,kkImage"
  };
  dynamic postDataM2W = {
    "id": 10012,
    "customerName": "bagas dany aradhana",
    "customerKtpNumber": "3374071005970007",
    "customerPhone": "082135388068",
    "deliveryAddress": "Jl Buni No 4",
    'deliveryProvinceId': 22,
    'deliveryCityId': 220,
    'deliveryKecamatanId': 1003,
    'deliveryKelurahanId': 1300,
    'deliveryPostalCode': "14411",
    'deliveryRt': 003,
    'deliveryRw': 002,
    "files": "customerKtpImage,refCustomerKtpImage,kkImage,stnkImage"
  };
}
