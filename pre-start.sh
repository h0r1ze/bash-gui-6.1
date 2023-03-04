#!/bin/bash
echo "Подождите идет установка пепврнр пакета..."
dnf groupinstall 'Development Tools' -y > /dev/null 2>&1 &
echo "Подождите идет установка второго пакета..."
dnf install yad -y > /dev/null 2>&1 &
cd dist/uscript/
./configure
make
echo "Выполняется инсталяция, пожалуйста подождите."
make install
clear
echo "Инсталяция выполнена"
rm -rf *
cd ..
rmdir uscript
cd ..
echo "Запуск скрипта осуществляется командой:
./allinone

При возникновении ошибки: Permission Denied
chmod +x *
" > readme
rm pre-start.sh