#!/bin/bash

#  PASSENTRY=`zenity --password --username`

#  case $? in
#           0)
#  	 	UserAuth=`echo $PASSENTRY | cut -d'|' -f1`
#  	 	PassAuth=`echo $PASSENTRY | cut -d'|' -f2`
#          CorrUser=`echo "123"`
#          CorrPass=`echo "123"`
#          if [ $UserAuth = $CorrUser ]; then
#              true
#          else
#              echo "Вы ввели неправильный логин или пароль"
#              exit
#          fi
#          if [ $PassAuth = $CorrPass ]; then

#             zenity --info --height=150 --width=600 \
#             --text="

# Этот скрипт содержит информацию, являющуюся собственностью МКУ ГЦИТ \"Цитадель\"
# Telegram разработчика: @heavyname"

#          else
#              echo "Вы ввели неправильный логин или пароль"
#              exit
#          fi
#          ;;
#          *)
#          echo "Вы ввели неправильный логин или пароль"
#          exit
#          ;;
#  esac

# ZENITY-UPDATE

function RepoOneNonrebootSh(){
    clear
    rm /etc/yum.repos.d/*
    cp repo/local.repo /etc/yum.repos.d/
    dnf update -y
    rm /etc/yum.repos.d/*
    cp repo/RedOS-Base.repo /etc/yum.repos.d/ 
    cp repo/RedOS-Updates.repo /etc/yum.repos.d/ 
    clear
    echo -n "
    Перезагрузить ПК?(да/нет): "
    read askReboot
    if [ $askReboot = "да" ]
    then
        reboot
    else 
        exit
    fi
}

function RepoOneSh(){
    clear
    rm /etc/yum.repos.d/*
    cp repo/local.repo /etc/yum.repos.d/
    dnf update -y
    rm /etc/yum.repos.d/*
    cp repo/RedOS-Base.repo /etc/yum.repos.d/ 
    cp repo/RedOS-Updates.repo /etc/yum.repos.d/ 
    reboot
}

function RepoOneDefupdateSh(){
    clear
    dnf update -y
    reboot
}

function RepoOneDefupdateNonrebootSh(){
    clear
    dnf update -y
    echo -n "
    Перезагрузить ПК?(Y/N): "
    read askReboot
    if [ $askReboot = "Y" ] || [ $askReboot = "y" ]
    then
        reboot
    else 
        exit
    fi
}

# MENU-1 ZENITY-UPDATER

function ZenityUpdater(){

    OPTION=`zenity --list --title="" --text="" --cancel-label="Вернуться на главную" --height=220 --width=600 \
        --column="№" --column="категория" --column="описание" \
        "1)" "Локальное обновление" " скачивания с репозитория Цитадели" \
        "2)" "Локальное обновление" " скачивания с репозитория Цитадели (перезагрузка)" \
        "3)" "Обычное обновление" "скачивание с репозитория RedOS" \
        "4)" "Обычное обновление" "скачивание с репозитория RedOS (перезагрузка)"`
    case $OPTION in
        "1)") RepoOneNonrebootSh;;
        "2)") RepoOneSh;;
        "3)") RepoOneDefupdateSh;;
        "4)") RepoOneDefupdateNonrebootSh;;
    esac

}

# DEF-SET

function ZenityDnfSh(){
    
    OPTION=`zenity --list --title="" --text="" --cancel-label="Вернуться на главную" --height=200 --width=350 \
        --column="№" --column="категория" \
        "1)" "[Проверить dnf.conf]" \
        "2)" "[Редактировать dnf.conf]" \
        "3)" "[Вернуть dnf.conf в исходное состояние]"`
    case $OPTION in
        "1)") clear
echo
echo
echo
echo "        -- dnf.conf --"
echo "_______________________________"
tail -n 3 /etc/dnf/dnf.conf | grep proxy
echo "_______________________________"
echo
echo "Если прокси не настроен значений последний 3 строк не будет выведено!"
echo "________________________________________________"
echo
echo -n "Введите любое значение чтобы попасть назад: "
read sabre
    if [ $sabre = "y" ] || [ $sabre = "Y" ]
    then
        true
    fi;;
        "2)") RepoOneSh;;
        "3)") RepoOneDefupdateSh;;
    esac    
}

function ZenitySmbSh(){
    clear
    echo -n -e "
_____________________________________________________________________

            Сейчас вы перейдете в папку  smb.conf!
            \e[31m\e[1mДанные протоколов успешно скопированы!\e[0m

_____________________________________________________________________

Вставьте в поле скопированные данные как в примере нажав \e[31m\e[1mctrl+shift+v\e[0m

Пример того куда нужно вставлять данные из буфера обмена: 

        [global]
        workgroup = WORKGROUP
\e[31m\e[1mСюда ->\e[0m    
        security = user
        passdb backend = tdbsam
        printing = cups
        printcap name = cups
        load printers = yes

_____________________________________________________________________

\e[31m\e[1mВы уверены что все прочитали и хотите продолжить? (Y/N):\e[0m "
    echo 'client min protocol = NT1 
    client max protocol = SMB3'| xsel -b -i

    read questUser
    if [ $questUser = "Y" ] || [ $questUser = "y" ]; then
        nano /etc/samba/smb.conf
        systemctl start smb
        clear
        echo "Скрипт завершен успешно, изменения вступили в силу. 

Самба запущена по новой!"
    else
        clear
        echo
        echo -e "\e[31m\e[1mСкрипт завершен БЕЗ ИЗМЕНЕНИЙ!\e[0m"
        echo
    fi
}

function ZenityKasperSh(){
    OPTION=$(whiptail --title "Настройка Касперского" --menu "Выберите один из пунктов для обновления системы:
    " 10 60 1 \
    "Запустить скрипт по изменению настроек Касперского" ""  3>&1 1>&2 2>&3)
    case $OPTION in
        "[Запустить скрипт по изменению настроек Касперского]") /opt/kaspersky/kesl/bin/kesl-setup.pl;;
    esac
}

function ZenityAgentSh(){
    OPTION=$(whiptail --title "Настройка Агента" \
    --menu "Выберите один из пунктов для обновления системы:
    " 10 60 2 \
    "[Проверить свзяь с сервером]" "" \
    "[Запустить скрипт по смене сервера Агента]" "" \
    "На главную страницу" "" 3>&1 1>&2 2>&3)
    case $OPTION in
        "[Проверить свзяь с сервером]") /opt/kaspersky/klnagent64/bin/klnagchk;;
        "[Запустить скрипт по смене сервера Агента]") /opt/kaspersky/klnagent64/lib/bin/setup/klnagent_setup.pl;;
        "На главную страницу") ./install.sh;;
    esac
}

function ZenityRepoSh(){
    OPTION=`zenity --list --title="" --text="" --cancel-label="Вернуться на главную" --height=180 --width=350 \
        --column="№" --column="категория" --column="описание" \
        "1)" "Сменить репозиторий" " Цитадель" \
        "2)" "Сменить репозиторий" " РедОС"`
    case $OPTION in
        "1)") rm /etc/yum.repos.d/*
            cp repo/local.repo /etc/yum.repos.d/
            clear
            echo "
Смена репозитория на Цитадель прошла успешна, создан файл local.repo.
Текущее состояние файлов в папке выведено ниже:

Путь: /etc/yum.repos.d/"
    ls -l /etc/yum.repos.d
    echo
        ;;
        "2)") rm /etc/yum.repos.d/*
            cp repo/RedOS-Base.repo /etc/yum.repos.d/ 
            cp repo/RedOS-Updates.repo /etc/yum.repos.d/
            clear
            echo "
Смена репозитория на RedOS прошла успешна, созданы файлы RedOS-base.repo и RedOS-Updates.repo 
Текущее состояние файлов в папке выведено ниже:

Путь: /etc/yum.repos.d/"
    ls -l /etc/yum.repos.d
    echo
            ;;
        *)
    esac
}
# MENU-2 ZENITY-DEF-SET

function ZenityDefSetSh(){
    OPTION=`zenity --list --title="" --text="" --cancel-label="Вернуться на главную" --height=250 --width=400\
        --column="№" --column="категория" --column="описание" \
        "1)" "Настроить" " dnf.conf" \
        "2)" "Настроить" " smb.conf" \
        "3)" "Настроить" " Касперский" \
        "4)" "Настроить" " Агент" \
        "5)" "Настроить" " Репозиторий"`

    case $OPTION in
        "1)") ZenityDnfSh </dev/tty;;
        "2)") ZenitySmbSh </dev/tty;;
        "3)") ZenityKasperSh </dev/tty;;
        "4)") ZenityAgentSh </dev/tty;;
        "5)") ZenityRepoSh </dev/tty;;
    esac
}

# INSTALLER-PROG
function TamplatesSh(){
    echo
    echo -n -e "\e[1m\e[31mУстановка шаблонов..."
    echo
    echo
    echo "__________________________________________"
    TAMPLATES=`grep -E '1000' /etc/passwd | awk -F: '{print $1}'`
    sudo -u $TAMPLATES cp dist/шаблоны/* /home/$TAMPLATES/Шаблоны
    echo
    echo
    echo "
        -- Шаблоны успешно установлены --
    "
    echo "__________________________________________"
    echo
    echo
}

function FontsSh(){
    cp dist/шрифты/* /usr/share/fonts/
    echo "Установка шрифтов..."
    echo
    echo "__________________________________________"
    echo
    echo
    echo "     -- Шрифты успешно установлены! --"
    echo
    echo "__________________________________________"
    echo    
}

function KasperskySh(){
    dnf remove -y kesl-*
    dnf remove -y kesl-*
    clear
    whereMySite=`pwd`
    dnf install -y dist/kesl-*.rpm
    dnf install -y perl-Getopt-Long perl-File-Copy
    /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall="dist/autoinstall.ini"
}

function KasperJustInstallSh(){
    clear
    dnf install -y dist/kesl-*.rpm
    dnf install -y perl-Getopt-Long perl-File-Copy
    dnf install -y dist/kesl-gui-*.rpm
}

function AgentSh(){
    dnf remove -y klnagent64-*
    dnf install -y dist/klnagent64-*.rpm
    whoMySite=`pwd`
    KLAUTOANSWERS=$whoMySite/dist/autoanswers.conf /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
    clear
    sleep 2s
    /opt/kaspersky/klnagent64/bin/klnagchk
    systemctl status klnagent
}

function AgentJustInstallSh(){
    dnf install -y dist/klnagent64-*.rpm
}

function VipnetSh(){
clear
dnf install -y dist/vipnetclient-gui_*.rpm
chmod +x dist/vipnet_dns.sh
echo "[global]
; Path where to install keys
;config_dir=
; Path where to store log files. By default <config_dir>/var/log
;log_dir=

[dns]
; User defined trusted DNS servers, separated by comma
trusted=10.14.100.222,10.17.101.222
; Using iptables rules for DNS requests redirection to ViPNet
; If iptables not enabled (=off) then IP 11.254.254.254 will be used as ViPNet DNS server
;     and this IP must be added manually to required configs
;iptables=off" > /etc/vipnet.conf

echo "# Generated by authselect on Wed Jul 27 15:07:28 2022
# Do not modify this file manually.

# If you want to make changes to nsswitch.conf please modify
# /etc/authselect/user-nsswitch.conf and run 'authselect apply-changes'.
#
# Note that your changes may not be applied as they may be
# overwritten by selected profile. Maps set in the authselect
# profile takes always precedence and overwrites the same maps
# set in the user file. Only maps that are not set by the profile
# are applied from the user file.
#
# For example, if the profile sets:
#     passwd: sss files
# and /etc/authselect/user-nsswitch.conf contains:
#     passwd: files
#     hosts: files dns
# the resulting generated nsswitch.conf will be:
#     passwd: sss files # from profile
#     hosts: files dns  # from user file

passwd:     sss files systemd
group:      sss files systemd
netgroup:   sss files
automount:  sss files
services:   sss files

# Included from /etc/authselect/user-nsswitch.conf

#
# /etc/nsswitch.conf
#
# An example Name Service Switch config file. This file should be
# sorted with the most-used services at the beginning.
#
# The entry '[NOTFOUND=return]' means that the search for an
# entry should stop if the search in the previous entry turned
# up nothing. Note that if the search failed due to some other reason
# (like no NIS server responding) then the search continues with the
# next entry.
#
# Valid entries include:
#
#	nisplus			Use NIS+ (NIS version 3)
#	nis			Use NIS (NIS version 2), also called YP
#	dns			Use DNS (Domain Name Service)
#	files			Use the local files in /etc
#	db			Use the pre-processed /var/db files
#	compat			Use /etc files plus *_compat pseudo-databases
#	hesiod			Use Hesiod (DNS) for user lookups
#	sss			Use sssd (System Security Services Daemon)
#	[NOTFOUND=return]	Stop searching if not found so far
#
# 'sssd' performs its own 'files'-based caching, so it should
# generally come before 'files'.

# To use 'db', install the nss_db package, and put the 'db' in front
# of 'files' for entries you want to be looked up first in the
# databases, like this:
#
# passwd:    db files
# shadow:    db files
# group:     db files

shadow:     files sss

hosts:      files resolve [!UNAVAIL=return] myhostname dns

# mdns4_minimal [NOTFOUND=return] dns

bootparams: files

ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files


publickey:  files

aliases:    files" > /etc/authselect/nsswitch.conf

authselect apply-changes

echo "Скрипт выполнен"

touch /home/logvipnet.txt
cat /etc/vipnet.conf >> logvipnet.txt
echo "_________________nsswitch.conf_________________" >> logvipnet.txt
cat /etc/authselect/nsswitch.conf >> logvipnet.txt
echo "Создан лог файл logvipnet.txt в /home/"
cat /etc/vipnet.conf
cat /etc/authselect/nsswitch.conf
}

function VipnetJustInstallSh(){
    clear
    dnf install -y dist/vipnetclient-gui_*.rpm
}

function CryptoProSh(){
    ./dist/CryptoPRO5.0/amd64/install_gui.sh
    dnf install -y ifd-rutokens
    dnf install dist/CryptoPRO5.0/amd64/cprocsp-rdr-jacarta-* -y
    dnf install dist/CryptoPRO5.0/amd64/cprocsp-pki*rpm -y
    dnf install ifcplugin-chromium.x86_64 -y
    dnf install tmux -y
    YandexCit=`grep -E '1000' /etc/passwd | awk -F: '{print $1}'`
    sudo -u $YandexCit cp dist/yandex-cit.sh /home/$YandexCit/.local
    sudo -u $YandexCit echo "[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Icon=yandex-browser
Icon[ru_RU]=yandex-browser
Name[ru_RU]=Яндекс-для-госучереждения
Exec=bash '/home/$YandexCit/.local/yandex-cit.sh'
Name=ed4r5tuy6utg6y78ilou
Comment[ru_RU.UTF-8]=" > /home/$YandexCit/Рабочий\ стол/Яндекс-для-госучереждения.desktop
    chmod ugo+rwx /home/$YandexCit/Рабочий\ стол/Яндекс-для-госучереждения.desktop
    LinksCryptoSh
}

function LinksCryptoSh(){
    zenity --text-info --height=500 --width=400 \
        --title="Информация" \
        --filename=dist/CryptoPRO5.0/link.txt
}

function OfficeSh(){
    clear
    dnf install -y dist/r7-office7.2.1.rpm
}

function AssistantSh(){
    clear
    echo -n -e "
___________________________________________________

            Установка Ассистента
___________________________________________________

\e[31m\e[1m                  !ВНИМАНИЕ!
В установку ассистента уже добавляются адреса 
в конец файла hosts. При повторной установке
убедитесь что в файле hosts удалены строки
прошлого ассистента. 
Они отмечены четко от начала до конца.\e[0m

___________________________________________________

1) Установить Ассистент (Простая установка без
дополнительных настроек)
2) Установить Ассистент (с добавлением ссылок
Администрации города в конец файла hosts)
___________________________________________________

\e[31m\e[1mЕсли вы просто установили Ассистент и вам необходимо
прописать адреса Администрации, то для работы 
Ассистента необходимо прописать ссылки в файле hosts\e[0m

3) Заменить файл hosts с стандартными ссылками
\e[31m\e[1mПримечание: данный файл удалит файл hosts и все
ссылки которые были введены до этого!\e[0m

4) Записать в конец файла hosts адреса Админки
\e[31m\e[1mПримечание: добавит в конец файла ссылки без
редактирования основого файла hosts.\e[0m
___________________________________________________

5) Вывести информацию о файле hosts
6) Редактировать файл hosts
___________________________________________________

0) Выход из скрипта

Введите одно допустимое значение: "
    read infoUser </dev/tty
    case $infoUser in
        1)  ./dist/assistant-fstek-4.8.run </dev/tty;;
        2)  ./dist/assistant-fstek-4.8.run </dev/tty
            cat dist/hosts >> /etc/hosts </dev/tty;;
        3)  cat dist/hosts > /etc/hosts </dev/tty;;
        4)  cat dist/proxy/hosts >> /etc/hosts </dev/tty;;
        5)  cat /etc/hosts </dev/tty
            echo
            echo -n "Вернуться назад? (нажмите любую кнопку): "
            read answerUser </dev/tty
            if [ $answerUser = "Y" ] || [ $answerUser = "y" ]; then
                AssistantSh </dev/tty
            else
                AssistantSh </dev/tty
            fi;;
        6) nano /etc/hosts
        AssistantSh </dev/tty;;
        0) echo "Вы вышли из скрипта."
        exit;;
        *) AssistantSh </dev/tty
    esac
}

function YandexBrowserSh(){
    clear
    dnf install -y dist/yandex-browser.rpm
}

function GoogleChromeSh(){
    clear
    dnf install -y dist/google-chrome-*
}

function GnomDiskSh(){
    dnf install -y dist/gnome-disk-utility-*.rpm
}

# MENU-3 ZENITY-INSTALLER-PO
function zenityInstallerPoSh(){
    DATA=`zenity --list --width=450 --height=480 --cancel-label="Вернуться на главную"\
        --checklist\
        --column ""\
        --column "ПО"\
        --column "Информация о ПО"\
        FALSE "Шрифты" "установка PT Astra Serif"\
        FALSE "Шаблоны" "Добавление в ПКМ .doc,xls,ppt"\
        FALSE "Р7 Офис" "установка офиса"\
        FALSE "Ассистент" "удаленный доступ"\
        FALSE "Яндекс браузер" "браузер Яндекса"\
        FALSE "Google Chrome" "браузер Хрома"\
        FALSE "Гном Диск" "для работы с HDD"\
        FALSE "Випнет" "обычная инсталяция без настройки"\
        FALSE "Випнет 2" "инсталяция с настройкой под прокси"\
        FALSE "Касперский" "обычная инсталяция без настройки"\
        FALSE "Касперский 2" "инсталяция с настройкой под прокси"\
        FALSE "Агент" "обычная инсталяция без настройки"\
        FALSE "Агент 2" "инсталяция с настройкой под прокси"\
        FALSE "CryptoPro 5.0" "работает только с Яндекс Браузером!" > 3`
    case $? in
    0) 
        DATAFIRST=`cat 3 | cut -d'|' -f1`
        DATALAST=`cat 3 | cut -d'|' -f14`
        DATASEARCH=`
        if [[ $DATAFIRST == $DATALAST ]]; then
            cat 3 | cut -d'|' -f1
        else
            cat 3 | cut -d'|' -f1
            cat 3 | cut -d'|' -f2
            cat 3 | cut -d'|' -f3
            cat 3 | cut -d'|' -f4
            cat 3 | cut -d'|' -f5
            cat 3 | cut -d'|' -f6
            cat 3 | cut -d'|' -f7
            cat 3 | cut -d'|' -f8
            cat 3 | cut -d'|' -f9
            cat 3 | cut -d'|' -f10
            cat 3 | cut -d'|' -f11
            cat 3 | cut -d'|' -f12
            cat 3 | cut -d'|' -f13
            cat 3 | cut -d'|' -f14
        fi `
        echo "$DATASEARCH" > 3
        function tampltaesInstall(){
            TamplatesSh
        }
        function fontsInstall(){
            FontsSh
        }
        function whiptailChooseKapsersky(){
            KasperskySh
        }
        function whiptailChooseKasperskyJustInstall(){
            KasperJustInstallSh
        }
        function whiptailChooseAgent(){
            AgentSh
        }
        function whiptailChooseAgentJustInstall(){
            AgentJustInstallSh
        }
        function whiptailChooseVipnet(){
            VipnetSh
        }
        function whiptailChooseVipnetJustInstall(){
            VipnetJustInstallSh
        }
        function whiptailChooseCryptopro(){
            CryptoProSh
        }
        function whiptailChooseOffice(){
            OfficeSh
        }
        function whiptailChooseAssistant(){
            AssistantSh
        }
        function whiptailChooseYandexBrowser(){
            YandexBrowserSh
        }
        function whiptailChooseGoogleChrome(){
            GoogleChromeSh
        }
        function whiptailChooseGnomDisk(){
            GnomDiskSh
        }
        while read DATASEARCH
        do
            case $DATASEARCH in
            "Шрифты") tampltaesInstall;;
            "Шаблоны") fontsInstall;;
            "Р7 Офис") whiptailChooseOffice;;
            "Ассистент") whiptailChooseAssistant;;
            "Яндекс браузер") whiptailChooseYandexBrowser ;;
            "Google Chrome") whiptailChooseGoogleChrome ;;
            "Гном Диск") whiptailChooseGnomDisk;;
            "Випнет") whiptailChooseVipnetJustInstall;;
            "Випнет 2") whiptailChooseVipnet;;
            "Касперский") whiptailChooseKasperskyJustInstall </dev/tty;;
            "Касперский 2") whiptailChooseKapsersky </dev/tty;;
            "Агент") whiptailChooseAgentJustInstall </dev/tty;;
            "Агент 2") whiptailChooseAgent </dev/tty;;
            "CryptoPro 5.0") whiptailChooseCryptopro;;
            esac
        done < 3
    ;;
    esac
    rm 3
}

# MENU-4 IP-SCAN
function ScanScriptSh(){
    ENTRY=`zenity --forms --title="IP-scan" --text="Введите адреса в формате: 192.168.0.1" \
        --add-entry="Введите начальный адрес" \
        --add-entry="Введите конечный адрес"`

    case $? in
        0)
            dataFirstIp=`echo "$ENTRY" | cut -d'.' -f1`
            dataThirtIp=`echo "$ENTRY" | cut -d'.' -f2`
            dataLastIp=`echo "$ENTRY" | cut -d'.' -f3`
            dataOneIp=`echo "$ENTRY" | cut -d'.' -f4 > 1.txt
            cat 1.txt | cut -d'|' -f1`
            dataTwoIp=`echo "$ENTRY" | cut -d'.' -f7`

            function hi {
                while [ $dataOneIp -le $dataTwoIp ];
                do
                    echo "$dataFirstIp.$dataThirtIp.$dataLastIp.$dataOneIp"
                    ((dataOneIp++))
                done
            }
            hi | while read hi
            do
                ping -c 1 -W 0.01 "$hi" > /dev/null
                if [ $? -eq 0 ]; then
                echo "       -X- Адрес $hi уже используется -X-" 
                else
                echo "Адрес $hi свободен"
                fi
            done
            rm 1.txt
            ;;
    esac
}

function IpScanSh(){
    clear
    echo "Запущен скрипт по сканированию сети, 
    обычно обработка занимает от 1 до 10 сек."
    ScanScriptSh > 3.txt
    FILE=3.txt
    zenity --text-info --height=450 --width=450 --title="Список просканированных адресов"\
        --filename=$FILE
    rm 3.txt
}

# MENU-5 LOCK-FLASH
function menuFlashSh(){
    MENU=`zenity --list --width=570 --height=310\
        --text "Выберите какое действие хотите совершить для ограничения подключаемых
    устройств." \
        --column "действие"\
        --column "описание" \
        "Блокировка" "создается файл с правилом для всех подключаемых устройств,
 либо заново перезаписывается удаляя все зарегистрированные 
 устройства. (Блокировка остается!)"\
        "Регистрация" "записывается в конец файла информация о подключенном
 накопителе"\
        "Удаление" "удаляет файл с правилом для подключаемых устройств"\
        "Изменить" "открывается файл правила подключаемых носителей
 в редакторе nano"\ `

    case $MENU in 
        "Блокировка") blockFlashSh;;
        "Регистрация") regFlashSh;;
        "Удаление") delFileFlashSh;;
        "Изменить") 
        if [ -f /etc/udev/rules.d/99-usb.rules ]; then
        nano /etc/udev/rules.d/99-usb.rules
        menuFlashSh
        else
        zenity --error --width="390" height="100" \
        --title='Открытие файла 99-usb.rules' \
        --text='
Увы, но работа в <b>nano</b> в данном скрипте можно только с файлом правила! Необходимо <b>"Блокировать"</b> носители'
    menuFlashSh
    fi ;;
        *) InstallSh;;
    esac
}

function delFileFlashSh(){
    if [ ! -f /etc/udev/rules.d/99-usb.rules ]; then
        zenity --error --width="260" \
        --title='Удаление правила' \
        --text='
Нет смысла удалять то, чего и так нет.'
    else
        zenity --info --width="390" height="100" \
        --title='Удаление правила' \
        --text='
Файл успешно ликвидирован.'
        rm /etc/udev/rules.d/99-usb.rules
    fi
    menuFlashSh
}

function blockFlashSh(){
    if [ -f /etc/udev/rules.d/99-usb.rules ]; then
        zenity --error --width="330" \
        --title='Блокировка носителя' \
        --text='
Файл уже создан.'
    else
        zenity --info --width="250" height="100" \
        --title='Блокировка носителя' \
        --text='
Правило создано'
        echo "ENV{ID_USB_DRIVER}==\"usb-storage\",ENV{UDISKS_IGNORE}=\"1\"" > /etc/udev/rules.d/99-usb.rules
    fi
    menuFlashSh
}

function regFlashSh(){
    clear
    if [ -f /etc/udev/rules.d/99-usb.rules ]; then

    zenity --info --width="390" height="100" \
    --title='Регистрация носителя' \
    --text='
Вставьте USB носитель!'
            echo "
    ------- Информация о подключенных накопителях --------
ДАННОЕ ОКНО НЕ ОБНОВЛЯЕТСЯ, ИНФОРМАЦИЯ ВЫВОДИТСЯ ДО ЗАПУСКА СКРИПТА
___________________________________________________________________
"
            infoDEVsd=`ls -l /dev/sd* | wc -l` 
            a=$infoDEVsd
            while [ $a -gt 0 ];
            do
                if [[ $a =~ $a ]]; then
                    str=`ls -l /dev/sd* | tail -n $a | head -n 1 | awk '{print $10}' | cut -d'/' -f3 | cut -d'1' -f2 | cut -d'2' -f2 | cut -d'3' -f2 | cut -d'4' -f2 | cut -d'5' -f2 | cut -d'6' -f2 | cut -d'7' -f2 | cut -d'8' -f2`
                    cry=`udevadm info -a -p /sys/block/$str`
                    echo $cry | grep model | cut -d '"' -f 2 | head -1 | sed '/^[[:space:]]*$/d' >> nameModel
                    udevadm info -a -p /sys/block/$str | grep model | cut -d '"' -f 2 | head -1 | sed '/^[[:space:]]*$/d' >> demiGod
                    ((a--))
                fi
            done

            infoDEVsd=`cat nameModel | wc -l` 
            a=$infoDEVsd
            while [ $a -gt 0 ];
            do
                if [[ $a =~ $a ]]; then
                    Gover=`cat nameModel | tail -n $a | head -n 1`
                    Sober=`cat demiGod | tail -n $a | head -n 1`
                    echo "        | Смонтирован : $Gover | носитель: $Sober |"
                    ((a--))
                fi
            done 
            rm demiGod
            rm nameModel
echo "
___________________________________________________________________
"
    ls -l /dev/sd*
echo "
___________________________________________________________________
"
    case $? in
        0)
            a=30
            while [ $a -gt 0 ];
            do
                if [[ $a =~ $a ]]; then
                    str=`ls -l /dev/sd* | tail -n $a | head -n 1`
                    searchInfoYou=`echo "${str: -1}" | cut -d'_' -f 1 | rev`
                    ((a--))
                    echo $searchInfoYou >> 1
                fi
            done
            destroyNumber=`
    zenity --entry \
    --title="Регистрация устройства" \
    --text="Введите последнюю букву подключенного устройства:" \ `
            lastResultDestroyer=$destroyNumber
            resultAlph=`echo "${lastResultDestroyer: -1}"`
        echo -e "
Информация о буквенной части зарегистрированного накопителя: $resultAlph (sd$resultAlph)

\e[1m\e[31mЕсли время подключения не совпадает с буквенной частью последнего устройства повторите попытку повторно\e[0m\e[39m"
            powerInfo=`udevadm info -a -p /sys/block/sd$resultAlph | grep bMaxPower | cut -d '"' -f 2 | head -1`
            modelInfo=`udevadm info -a -p /sys/block/sd$resultAlph | grep model | cut -d '"' -f 2 | head -1`
            serialInfo=`udevadm info -a -p /sys/block/sd$resultAlph | grep serial | cut -d '"' -f 2 | head -1`
            echo "ATTRS{serial}==\"$serialInfo\",ENV{UDISKS_IGNORE}=\"0\"
# --- Разделитель регистрации носителей" --- >> /etc/udev/rules.d/99-usb.rules
            udevadm control --reload-rules
            rm 1
            clear
        echo "
    ------- Информация о последних подключенных накопителях --------
        "
            ls -l /dev/sd*
        echo "
    ----- Вывод файла с зарегистрированными носителямии ------
        "
            cat /etc/udev/rules.d/99-usb.rules
        ;;
        1)
            echo "Скрипт завершен посколку вы закрыли окно."
    esac
    else
        zenity --error --width="300" \
        --title='Регистрация накопителя' \
        --text='
Прежде чем зарегистрировать флешку необходимо \"Блокировать\" устройства!'
        menuFlashSh
    fi
}
# BASE-LINUX

function BaseLinux(){
ipcrm -M 12345 &>/dev/null
yad --plug=12345 \
    --tabnum=1 \
    --html \
    --uri="base-linux/page/redos.html" \ &> res1 &yad \
    --plug=12345 \
    --tabnum=2 \
    --html \
    --uri="base-linux/page/kernel-remove.html" \ &> res2 &yad  \
    --plug=12345 \
    --tabnum=3 \
    --html \
    --uri="base-linux/page/dnf.html" \ &> res3 &yad \
    --plug=12345 \
    --tabnum=4 \
    --html \
    --uri="base-linux/index.html" \ &> res4 &yad \
    --plug=12345 \
    --tabnum=5 \
    --html \
    --uri="base-linux/page/printers.html" \ &> res5 &yad \
    --plug=12345 \
    --tabnum=6 \
    --html \
    --uri="base-linux/page/thunderbird.html" \ &> res5 &yad \
    --title="base_linux" \
    --no-buttons \
    --notebook \
    --key=12345 \
    --tab="RedOS установка" \
    --tab="Ядро" \
    --tab="DNF" \
    --tab="СКЗИ/СЗИ" \
    --tab="Принтеры" \
    --tab="Перенос с Outlook в Thunder Bird" \
    --height=800 \
    --width=1300
case $? in
    0) 
    exit 
    ;;
esac 

ipcrm -M 12345 &>/dev/null
rm res1
rm res2
rm res3
rm res4
rm res5
}

# HARDWARE-INFO

function HardWareInfo(){
 YAD_OPTIONS="--window-icon='dialog-information' --name=IxSysinfo"
 
 KEY=$RANDOM
 
 function show_mod_info {
     TXT="\\n<span face='Monospace'>$(modinfo $1 | sed 's/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g')</span>"
        yad --title=$"Module information" --button="yad-close" --width=500 \
            --image="application-x-addon" --text="$TXT"
    }
    export -f show_mod_info
    
    # CPU tab
    lscpu | sed -r "s/:[ ]*/\n/" |\
        yad --plug=$KEY --tabnum=1 --image=cpu --text=$"CPU информация" \
            --list --no-selection --column=$"Наименование" --column=$"Информация" &
    
    # Memory tab
    sed -r "s/:[ ]*/\n/" /proc/meminfo |\
        yad --plug=$KEY --tabnum=5 --image=memory --text=$"Memory usage information" \
            --list --no-selection --column=$"Параметры" --column=$"Значение" &
    
    # Harddrive tab
    df -T | tail -n +2 | awk '{printf "%s\n%s\n%s\n%s\n%s\n%s\n", $1,$7, $2, $3, $4, $6}' |\
        yad --plug=$KEY --tabnum=2 --image=drive-harddisk --text=$"Занятое пространсто на диске" \
            --list --no-selection --column=$"Устройство" --column=$"Точка монтирования" --column=$"Тип подключения" \
            --column=$"Всего:sz" --column=$"Занято:sz" --column=$":bar" &
    
    # PCI tab
    lspci -vmm | sed 's/\&/\&amp;/g' | grep -E "^(Slot|Class|Vendor|Device|Rev):" | cut -f2 |\
        yad --plug=$KEY --tabnum=4 --text=$"PCI bus devices" \
            --list --no-selection --column=$"ID" --column=$"Class" \
            --column=$"Vendor" --column=$"Device" --column=$"Rev" &
    
    # Modules tab
    awk '{printf "%s\n%s\n%s\n", $1, $3, $4}' /proc/modules | sed "s/[,-]$//" |\
        yad --plug=$KEY --tabnum=3 --text=$"Загруженные модули ядра" \
            --image="application-x-addon" --image-on-top \
            --list --dclick-action='bash -c "show_mod_info %s"' \
            --column=$"Имя" --column=$"Использовано" --column=$"Depends" &

    
    # main dialog
    TXT=$"<b>Информация о системе</b>\\n\\n"
    TXT+=$"\\tОперационная система: $(lsb_release -ds)\\n"
    TXT+=$"\\tИмя машины: $(hostname)\\n\\n"
    TXT+=$"\\tKernel: $(uname -sr)\\n"
    
    yad --notebook --width=900 --height=650 --title=$"Информация о системе" --text="$TXT" --button="yad-close" \
        --key=$KEY --tab=$"CPU" --tab=$"Жесткие диски" --active-tab=${1:-1}
}

# CERT-INSTALLER

function CertInstaller(){
        zenity --warning --width="450" height="100" \
        --title='Установка сертификатов УЦ' \
        --text='
Загрузите все сертификаты формата crl, crt, cer в папку "crt-cer-crl" и нажмите "ОК", в ином случае закройте данное окно'    
case $? in
    1) true;;
    0) 
    listFolder=`ls crt-cer-crl`
    infoFolder=`ls crt-cer-crl | wc -l`
    a=$infoFolder
    while [ $a -gt 0 ];
    do 
        if [[ $a =~ $a ]]; then
            installCRT=`ls crt-cer-crl | tail -n $a | head -n 1 | grep crt`
            installCER=`ls crt-cer-crl | tail -n $a | head -n 1 | grep cer`
            installCRL=`ls crt-cer-crl | tail -n $a | head -n 1 | grep crl`
            if ! [[ $installCRT = "${param// }" ]]; then
                /opt/cprocsp/bin/amd64/certmgr -inst -cert -file crt-cer-crl/$installCRT -store uRoot
            else
                true 
            fi
            if ! [[ $installCER = "${param// }" ]]; then
                /opt/cprocsp/bin/amd64/certmgr -inst -cert -file crt-cer-crl/$installCER -store uRoot
            else
                true 
            fi
            if ! [[ $installCRL = "${param// }" ]]; then
                /opt/cprocsp/bin/amd64/certmgr -inst -crl -file crt-cer-crl/$installCRL
            else
                true 
            fi
            ((a--))
        fi
    done   
    ;;
    *) true ;;
esac 
}

# ALL-IN-ONE-MENU
function InstallSh(){
    chmod -R +x *
    OPTION=`zenity --list --title="CITADEL 6.6" --text="" --height=330 --width=520 \
        --column="категория" --column="описание" \
        "Обновление системы" "обновление с репозитория Цитадели/РедОс" \
        "Настройка ПО/ПК" "dnf, smb, kasper, agent, смена репозитория" \
        "Установка ПО" "шрифты, шаблоны, СКЗИ, СЗИ и прочее..." \
        "Установка сертификатов УЦ  " "crl-cer-crt" \
        "IP-Scan" "выводит свободные и занятые ip адреса" \
        "USB блокировка" "блокирует носители" \
        "Base-Linux" "база знаний" \
        "Информация о системе  " "Имя ПК, Ядро, CPU, Жесткие Диски"`
    case $OPTION in
        "Обновление системы") ZenityUpdater </dev/tty;;
        "Настройка ПО/ПК") ZenityDefSetSh </dev/tty;;
        "Установка ПО") zenityInstallerPoSh </dev/tty;;
        "IP-Scan") IpScanSh;;
        "USB блокировка") menuFlashSh;;
        "Base-Linux") BaseLinux;;
        "Информация о системе  ") HardWareInfo;;
        "Установка сертификатов УЦ  ") CertInstaller;;
        *) exit;;
    esac
}

while true
do
    InstallSh
done

pkill yad &>/dev/null
