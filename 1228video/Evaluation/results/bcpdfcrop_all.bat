for "usebackq delims==" %%i IN (`dir /B *.pdf`) 
do (bcpdfcrop.bat %%i %%i)