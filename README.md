## sahte pdf siteleri engelleyici

### neden?

Bir pdfyi internette arattığımız zaman genellikle "kitapismi pdf" diye aratırız. 

Bunu fırsat bilen sahtekarlar herhangi bir aradığımız kitabın/derginin sahte pdf sayfalarını oluşturarak reklam ve virüsler ile karşımıza çıkıyor.

Bu durumla karşılaşmamak için sahte pdf sitesileri engelleme listesi oluşturma ihtiyacı duyduk.

### uBlacklist

Abone ol: https://gitlab.com/anarcho-copy/block-fake-pdf-sites/-/raw/master/output/uBlacklist.txt

### ekleme yap

[paper.komun.org/p/block-fake-pdf-sites](https://paper.komun.org/p/block-fake-pdf-sites) adresindeki etherpad çalışmasına tavsiye ettiğin domaini ekleyebilirsin, otomatik bir şekilde şuraya eşleştirilecektir: [data/hosts.d/etherpad](https://gitlab.com/anarcho-copy/block-fake-pdf-sites/-/blob/master/data/hosts.d/etherpad)


### diğer kaynaklar: [data/hosts.d](https://gitlab.com/anarcho-copy/block-fake-pdf-sites/-/tree/master/data/hosts.d)

Aktif etmek için `config.conf` dosyasındaki `include_other_sources` değerini `true` olarak değiştir. 

Tekrarlamaları önlemek -başka listelerin de kullanabilmesi- için bu depoda aktif edilmedi.
