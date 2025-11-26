# odev_6

A new Flutter project.

## Getting Started

Flutter Video Oynatıcı Projesi
Bu proje, Flutter kullanılarak geliştirilmiş, modern arayüze sahip temel bir video oynatıcı uygulamasıdır. Kullanıcıların ağ üzerinden video yüklemesine ve oynatma kontrollerini yönetmesine olanak tanır. 
Özellikler
Uygulama aşağıdaki temel işlevleri içerir:
1-Video Oynatma:
* video_player paketi kullanılarak uzaktan (network) video yükleme.
* Yükleme sırasında kullanıcıya CircularProgressIndicator gösterimi.
* Hata durumunda bilgilendirme mesajı.
2-Kullanıcı Arayüzü (UI):
* Video Alanı: 16:9 en-boy oranına sabitlenmiş görüntüleme alanı.
* Zaman Çubuğu: Videonun mevcut süresini ve toplam süresini gösteren dinamik Slider.
* Kontroller: Modern ikon setleri ve Material 3 tasarım dili.
3-Kontrol Fonksiyonları:
* Oynat/Duraklat: Videoyu başlatma ve durdurma.
* İleri/Geri Sarma: Butonlar ile videoyu 10 saniye ileri veya geri sarma.
* Scrubbing: Slider çubuğunu kaydırarak videonun istenilen yerine gitme.
* Ses Kontrolü: Tek tuşla sesi kapatma (Mute) ve açma.
* Loop (Döngü): Video bittiğinde otomatik olarak başa sarma özelliği.
Kullanılan Teknolojiler
* Flutter SDK
* Paket: video_player: ^2.9.1
* Dil: Dart
