# UKM-servere
Ideelt skal dette være likt prod-miljøet, men det er fortsatt (siden vi starta i 2014) en tilnærmet utgave. Vi kommer stadig nærmere, og siden restarten i 2020, er håpet at ny struktur etter hvert kan bistå hvis vi også går i retning microservices. Fun times!

### Bidrag
Som all vår kode er også dette repoet under kontinuerlig utvikling, og vi tar gjerne i mot forslag til hvordan vi kan gjøre det bedre!

Installasjon
===
1. Installer [virtualbox](https://www.virtualbox.org/) 
2. Installer [vagrant](http://www.vagrantup.com/)
3. Etterspør [datafiler for utviklermiljø](mailto:support@ukm.no?subject=UKMdev_datafiler)
4. Klon dette repoet til din maskin
5. Pakk ut datafilene *(fra pkt 3)* `./datapackage/` i repoet.
6. Legg til SSL-sertifikatet `./datapackage/UKMNorgeCA.pem` i din keychain / nettleser
7. Når du starter en VM, vil vagrant sjekke at du har riktige vagrant-plugins installert, og eventuelt fortelle deg hvordan du installerer disse.

### Starte opp en VM
Vi anbefaler å starte opp en spesifikk VM, hvor `<role>` er være en av de [ulike VM'ene](#de-ulike-vmene) (`lite`, `main`, ~~`playback`~~, ~~`videoconverter`~~, ~~`videostorage`~~ eller ~~`videocache`~~). Dette gjør du med:

`$ vagrant up <role> `

For å starte alle VMer (ikke anbefalt):

`$ vagrant up`

### Visual Studio Code
Vi benytter [VScode](https://code.visualstudio.com/download) til vår utvikling (du står selvfølgelig fritt til å velge dette selv), og i repoet finner du derfor en workspace-fil (`/UKM.code-workspace`).

### Hosts
Din lokale hosts-fil blir automatisk oppdatert av [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager), og vagrant vil derfor be om administrator-passord på din maskin under `vagrant up`.

### SSL
Siden vi kjører utvikling på en virtuell server, kreves det nå kryptert forbindelse mellom den lokale maskinen og den virtuelle serveren. Ingen av sertifikatene eller private keyene du får tilgang til skal brukes andre steder enn i utviklingsmiljøene.

### Database-tilgang
Etter du har kjørt `vagrant up lite` eller `vagrant up `, har du tilgang på dev-databasen, f.eks med [Sequel pro](https://sequelpro.com/download). OBS: to VM'ene kjører hver sin utgave av databasen.

Bruk SSH for å koble til (bytt ut `<repo>` med den faktiske filbanen til repoet på din maskin).

**Lite-maskinen**
```yaml
SSH:
    Host: lite.ukm.dev
    User: vagrant
    Key: <repo>/.vagrant/machines/lite/virtualbox/private_key
```
**Main-maskinen**
```yaml
SSH:
    Host: ukm.dev
    User: vagrant
    Key: <repo>/.vagrant/machines/main/virtualbox/private_key
```
**Felles MySQL-settings for begge maskinene**
```yaml
MySQL:
    Host: 127.0.0.1
    Username: root
    Password: dev
    Database: ukmdev_dev_ss3 | ukmdelta_db | ukmdev_dev_wp
    Port: 3306
```

# Tips på veien

## Shared Folders (Mac Os)
Hvis du hele tiden må skrive inn host-passordet i OS X for å sette opp networking ifbm. NFS og shared folders kan du gjøre det følgende for å fikse på det:

- `sudo visudo` - Bla deg til enden av filen, trykk `i` for å gå i Insert Mode.
- Lim inn følgende (OBS: erstatt `~` med faktisk path): 
```
    Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
    Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
    Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
    Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp ~/.vagrant.d/tmp/hosts.local /etc/hosts
    %admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE, VAGRANT_HOSTMANAGER_UPDATE
```
- Trykk `ESC` for å gå ut av Insert Mode
- Trykk `:w` for å lagre.
- Trykk `:q:` for å avslutte redigering (`:q!` for å avslutte uten å lagre).

## Windows: "The guest additions on this VM do not match the installed version of"
Prøv 
`$ vagrant plugin install vagrant-vbguest` [takk til Shamli Singh](https://medium.com/@botdotcom/installing-virtualbox-and-vagrant-on-windows-10-2e5cbc6bd6ad)


De ulike VM'ene
===

## Lite
Lite-maskinen kan du bruke for å kjøre opp enkle kode-prosjekter. Denne svarer på https://lite.ukm.dev, og alt du putter i `/server_data/lite/` havner i `/var/www/` på VM'en. 

Databasen kjøres lokalt på VM'en med testdata, og du har tilgang til [UKMlib](https://github.com/UKMNorge/UKMAPI/) under `server_data/ukmlib/`.


For å aksessere [UKMlib](https://github.com/UKMNorge/UKMAPI) i koden din, trenger du bare:
```php
require_once('UKM/Autoloader.php');
```

## Main
"Hoved-serveren vår". Her kjører vi wordpress (https://ukm.dev), og de fleste subdomenene på *.ukm.dev. Gir deg full tilgang til arrangørsystem, påmeldingssystem, nettsider osv. (og fungerer ikke atm 😬)