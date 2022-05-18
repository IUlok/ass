@echo off
tasm /zi %1,%1,%1
if errorlevel 1 goto err
tlink /v %1,%1
td %1
goto end
:err
echo Ошибка трансляции!
:end
exit
