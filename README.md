## sahte pdf siteleri engelleyici (hosts listesi)

Bir pdfyi internette arattığımız zaman genellikle "kitapismi pdf" diye aratırız. 

Bunu fırsat bilen reklam oburları herhangi bir aradığımız kitabın/derginin sahte pdf sitesini oluşturarak reklamlar ve virüsler ile karşımıza çıkıyor.

Bunlarla karşılaşmamamız için sahte pdf sitesi engelleyiciyi yaptık.

Bu engelleyici bir **domain listesi** dir. 

## engeleyiciyi kurmak için:

### linux bilgisayarda
terminali açıp şu kodları yaz:

    git clone https://gitlab.com/anarcho-copy/block-fake-pdf-sites.git
    cd block-fake-pdf-sites
    sudo cat hosts >> /etc/hosts

### windows bilgisayarda 

#### powershell:
powershell terminalini administrator yetkisinde açıp şu kodları yaz:

     git clone https://gitlab.com/anarcho-copy/block-fake-pdf-sites.git
     cd block-fake-pdf-sites
     cat hosts >> C:\Windows\System32\drivers\etc\hosts
     

#### el ile yapmak istersen:

- https://gitlab.com/anarcho-copy/block-fake-pdf-sites/raw/master/hosts bağlantısına gidip buradaki listenin tümünü kopyala.
-  C:\Windows\System32\drivers\etc dizini git
 - administrator  yetkisinde hosts dosayasını metin düzenleyicisi ile aç
 - ve ardından kopyaladığın listeyi yapıştır.  Kaydedip çık, çalışmış
  olacaktır.


## listeye yeni bir domain eklemek için:

anarchocopy[et]protonmail[nokta]com adresine ****hosts**** konusuyla domaini mail olarak atabilirsin yada aşağıdaki gibi anarcho-copy | etherpad sunucusunu kullanarak eklemeyi dene.

### etherpad

https://pad.anarcho-copy.org/p/hosts adresine git, listenin en altına inip alan adını şu şekilde yaz:

    0.0.0.0 engellenecek-domain.example