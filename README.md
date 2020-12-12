## sahte pdf siteleri engelleyici (hosts listesi)

Bir pdfyi internette arattığımız zaman genellikle "kitapismi pdf" diye aratırız. 

Bunu fırsat bilen reklam oburları herhangi bir aradığımız kitabın/derginin sahte pdf sayfalarını oluşturarak reklam ve virüsler ile karşımıza çıkıyor.

Bu durumla karşılaşmamak için sahte pdf sitesileri engelleme listesi oluşturma ihtiyacı duyduk.

## blok listesini aktif etmek için:

### gnu/linux bilgisayarda
terminali açıp şu kodu yaz:
    
    curl -s https://gitlab.com/anarcho-copy/block-fake-pdf-sites/-/raw/master/hosts >> /etc/hosts

### windows bilgisayarda 

- https://gitlab.com/anarcho-copy/block-fake-pdf-sites/raw/master/hosts bağlantısına gidip buradaki listenin tümünü kopyala.
- C:\Windows\System32\drivers\etc dizini git
- administrator  yetkisinde hosts dosyasını metin düzenleyicisi ile aç
- ve ardından kopyaladığın listeyi yapıştır.  Kaydedip çık, çalışmış
  olacaktır.

#### powershell ile yapmak istersen:
powershell terminalini administrator yetkisinde açıp şu kodu yaz:

     curl.exe https://gitlab.com/anarcho-copy/block-fake-pdf-sites/-/raw/master/hosts >> C:\Windows\System32\drivers\etc\hosts
     
## listeye yeni bir domain eklemek için:

anarchocopy[et]protonmail[nokta]com adresine ****hosts**** konusuyla domainleri mail olarak atabilirsin ya da bu gitlab reposuna PR isteği yollayabilirsin.

### daha kapsamlı reklam engelleme listeleri için:


[filterlists.com](https://filterlists.com/)
