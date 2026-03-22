# Building Custom R on Windows (Behind a Proxy)

Follow these steps to compile your custom R version (`4.6.0 (Sermet Custom Build)`) natively on Windows using `cmd.exe`.

## 1. Prerequisites
- Ensure [Rtools45](https://cran.r-project.org/bin/windows/Rtools/rtools45/rtools.html) is installed (it normally defaults to `C:\rtools45`).
- Clone or download your `r-source` repository to your Windows machine.

## 2. Set Up Environment Variables
Open a standard **Command Prompt (`cmd.exe`)** in the root of your `r-source` directory and configure your proxy and paths:

```cmd
:: 1. Set your Proxy (Replace with your actual proxy IP and port)
set HTTP_PROXY=http://your_proxy_address:port
set HTTPS_PROXY=http://your_proxy_address:port

:: 2. Set Rtools paths natively
set RTOOLS_HOME=C:\rtools45
set PATH=%RTOOLS_HOME%\x86_64-w64-mingw32.static.posix\bin;%RTOOLS_HOME%\usr\bin;%PATH%
```

## 3. Prepare the Build Environment
Run the following commands in the same Command Prompt to prepare SVN revisions, fix headers, and download mandatory dependencies:

```cmd
:: Create required SVN information so the build doesn't fail checking git/svn
echo Revision: 00000> SVN-REVISION
echo Last Changed Date: 2026-03-22 00:00:00 +0000>> SVN-REVISION

:: Copy fixed config.h appropriate for Windows 
copy src\gnuwin32\fixed\h\config.h src\include\config.h

:: Download and extract the required Tcl/Tk bundle
curl -O "https://cran.r-project.org/bin/windows/Rtools/rtools45/files/tcltk-5412-5408.zip"
unzip -q -o tcltk-5412-5408.zip
```
*(Note: If `curl` fails due to strict SSL proxy inspection, simply download [this tcltk zip link](https://cran.r-project.org/bin/windows/Rtools/rtools45/files/tcltk-5412-5408.zip) via your web browser, place the zip file in the `r-source` root folder, and run the `unzip` command manually).*

## 4. Bypass Documentation Build Bugs
To prevent `texi2any` from crashing during the HTML documentation generation, inject these dummy stub files:

```cmd
echo R FAQ > doc\FAQ
echo R RESOURCES > doc\RESOURCES
mkdir doc\html 2>nul
echo ^<html^>^</html^> > doc\html\resources.html
```

## 5. Build Custom R
Navigate to the `gnuwin32` source folder and trigger the build. Using `-j%NUMBER_OF_PROCESSORS%` will dramatically speed up the compilation by using all available CPU threads:

```cmd
cd src\gnuwin32
make -j%NUMBER_OF_PROCESSORS%
```

## 6. Verify and Test Your Build
Once the build script finishes, verify that your new custom version tag is active!

```cmd
:: Go back to the root directory
cd ..\..

:: Verify the custom version string
bin\x64\Rscript.exe --version
```

**Expected Output:** 
> `Rscript (R) version 4.6.0 (Sermet Custom Build) (2026-03-22 ...`

### Running the Test Suite
If you want to run the base testing suite (just like we did in GitHub Actions), run:
```cmd
cd src\gnuwin32
make check
```
*(Note: Since we disabled test requirements depending on missing "Recommended" packages like `Matrix` in the `Makefile.win`, the checks should safely validate the core base-R implementation).*
