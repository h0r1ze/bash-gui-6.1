#!/bin/bash
echo "Подождите идет установка пепврнр пакета..."
rpm -i downloaddeveloper-kit/DevelopmentTools/*.rpm
echo "Подождите идет установка второго пакета..."
rpm -i downloaddeveloper-kit/yad/*.rpm
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