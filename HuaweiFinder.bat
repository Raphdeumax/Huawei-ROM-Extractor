@ECHO OFF

setlocal ENABLEDELAYEDEXPANSION
CD /D "%CD%\output" 2>NUL
IF %ERRORLEVEL%==1 ECHO Ouput folder is not found&ECHO.Please execute split_updata.pl before this script.&ECHO.&PAUSE&EXIT

SET /A NB=0
SET /A NB_Files=0
SET /A NB_Files_S=0


FOR /F "TOKENS=*" %%A IN ('DIR /B /OS "*.*"') DO (
	SET /A NB_Files+=1
	REN %%A %%~A.img)

ECHO.
ECHO            [Huawei finder by Lycris11]
ECHO.
ECHO.
ECHO * Searching for system file
ECHO   -------------------------
FOR /F "TOKENS=*" %%A IN ('DIR /B /OS "*.img"') DO (
	SET /A NB_Files_S+=1
	IF !NB_Files!==!NB_Files_S! (
	ECHO.&ECHO %%A : %%~zA = system.img&ECHO.&ECHO.
	REN %%A system.img 2>NUL))

ECHO * Searching for boot/recovery files
ECHO   ---------------------------------
FOR /F "TOKENS=*" %%A IN ('DIR /B /OS "*.img"') DO (
	IF %%~zA LEQ 2000000 DEL /Q %%A
	IF EXIST %%~A (
	FOR /F "TOKENS=*" %%B IN ('FINDSTR /IM "console=" "%%~A"') DO (
	FINDSTR /I "lost+found" %%B>NUL
	IF %ERRORLEVEL%==0 (
		IF %%~zB GEQ 2000000 IF %%~zB LEQ 9000000 (
			IF !NB!==0 (
				ren %%B boot.img
				ECHO.&ECHO %%B : %%~zB = boot.img)
			IF !NB!==1 (
				ren %%B recovery.img
				ECHO %%B : %%~zB = recovery.img)
			SET /A NB=+1)))))

ECHO.&ECHO.&PAUSE