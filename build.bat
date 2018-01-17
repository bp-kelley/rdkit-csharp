set THISDIR=%~dp0
echo %THISDIR%
set PACKAGE=%THISDIR%Nuget.Local
set BOOST_INCLUDEDIR=%PACKAGE%/boost.1.62.0.0/lib/native/include
set BOOST_LIBRARYDIR=%PACKAGE%/lib
set EIGEN3_INCLUDE_DIR=%PACKAGE%/Eigen.3.3.3/build/native/include
set CAIRO_INCLUDE_DIRS=%PACKAGE%/cairo.1.12.18.0/build/native/include
set CAIRO_LIBRARIES=%PACKAGE%/lib

call get_nuget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe

REM **** ASSUMES rdkit is in the directory named rdkit in the same location as this directory ***

echo Running cmake...
REM mkdir  build
mkdir %PACKAGE%
mkdir %PACKAGE%\lib64
mkdir %PACKAGE%\lib32

cd %PACKAGE%

%THISDIR%\nuget.exe install boost-vc140 -Version 1.62.00
%THISDIR%\nuget.exe install Eigen -Version 3.3.3
%THISDIR%\nuget.exe install cairo -Version 1.12.18

@echo off
REM Copy the boost dependencies over the lib32 lib64 directory
call :find-files-64 %PACKAGE% "*regex*.dll" 
call :find-files-64 %PACKAGE% "*regex*.lib"

call :find-files-64 %PACKAGE% "*serialization*.dll"
call :find-files-64 %PACKAGE% "*serialization*.lib"

call :find-files-64 %PACKAGE% "*thread*.dll"
call :find-files-64 %PACKAGE% "*thread*.lib"

call :find-files-64 %PACKAGE% "*system*.dll"
call :find-files-64 %PACKAGE% "*system*.lib"

call :find-files-64 %PACKAGE% "*chrono*.dll"
call :find-files-64 %PACKAGE% "*chrono*.lib"

call :find-files-64 %PACKAGE% "*date_time*.dll"
call :find-files-64 %PACKAGE% "*date_time*.lib"

call :find-files-64 %PACKAGE% "*atomic*.dll"
call :find-files-64 %PACKAGE% "*atomic*.lib"

call :find-files-32 %PACKAGE% "*regex*.dll" 
call :find-files-32 %PACKAGE% "*regex*.lib"

call :find-files-32 %PACKAGE% "*serialization*.dll"
call :find-files-32 %PACKAGE% "*serialization*.lib"

call :find-files-32 %PACKAGE% "*thread*.dll"
call :find-files-32 %PACKAGE% "*thread*.lib"

call :find-files-32 %PACKAGE% "*system*.dll"
call :find-files-32 %PACKAGE% "*system*.lib"

call :find-files-32 %PACKAGE% "*chrono*.dll"
call :find-files-32 %PACKAGE% "*chrono*.lib"

call :find-files-32 %PACKAGE% "*date_time*.dll"
call :find-files-32 %PACKAGE% "*date_time*.lib"

call :find-files-32 %PACKAGE% "*atomic*.dll"
call :find-files-32 %PACKAGE% "*atomic*.lib"

REM Find cairo libs
call :find-files-64 %PACKAGE% "cairo.lib"
call :find-files-32 %PACKAGE% "cairo.lib"

@echo on

cd %THISDIR%
mkdir build64
cd build64

cmake -G "Visual Studio 14 Win64" -DCMAKE_INSTALL_PREFIX=%P% -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_SWIG_JAVA_WRAPPER=OFF -DRDK_BUILD_SWIG_CSHARP_WRAPPER=ON -DBOOST_INCLUDEDIR="%BOOST_INCLUDEDIR%" -DBOOST_LIBRARYDIR="%BOOST_LIBRARYDIR%64" -DEIGEN3_INCLUDE_DIR="%EIGEN3_INCLUDE_DIR%" -DRDK_INSTALL_INTREE=OFF -DCPACK_INSTALL_PREFIX=rdkit -DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_CAIRO_SUPPORT=ON -DCAIRO_INCLUDE_DIRS="%CAIRO_INCLUDE_DIRS%" -DCAIRO_LIBRARIES="%CAIRO_LIBRARIES%64" ..\..\rdkit

msbuild "ALL_BUILD.vcxproj" /m /p:PlatformTarget=x64 /p:Configuration=Release /maxcpucount:4 /t:Build

copy Code\JavaWrappers\csharp_wrapper\Release\RDKFuncs.dll Code\JavaWrappers\csharp_wrapper
copy ..\..\rdkit\Code\JavaWrappers\csharp_wrapper\RDKit2DotNet.csproj Code\JavaWrappers\csharp_wrapper
robocopy ..\..\rdkit\Code\JavaWrappers\csharp_wrapper\swig_csharp Code\JavaWrappers\csharp_wrapper\swig_csharp /E
del Code\JavaWrappers\csharp_wrapper\swig_csharp\FilterCatalogParams.cs
copy %THISDIR%\FilterCatalogParams.cs.fixed  Code\JavaWrappers\csharp_wrapper\swig_csharp\FilterCatalogParams.cs
copy %THISDIR%\RDKit.cs  Code\JavaWrappers\csharp_wrapper\swig_csharp\RDKit.cs
msbuild "Code\JavaWrappers\csharp_wrapper\RDKit2DotNet.csproj" /m /p:Configuration=Release /maxcpucount:4 /t:Build /p:Platform=AnyCPU


REM build x86

cd %THISDIR%
mkdir build32
cd build32

cmake -G "Visual Studio 14" -DCMAKE_INSTALL_PREFIX=%P% -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_SWIG_JAVA_WRAPPER=OFF -DRDK_BUILD_SWIG_CSHARP_WRAPPER=ON -DBOOST_INCLUDEDIR="%BOOST_INCLUDEDIR%" -DBOOST_LIBRARYDIR="%BOOST_LIBRARYDIR%32" -DEIGEN3_INCLUDE_DIR="%EIGEN3_INCLUDE_DIR%" -DRDK_INSTALL_INTREE=OFF -DCPACK_INSTALL_PREFIX=rdkit -DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_CAIRO_SUPPORT=ON -DCAIRO_INCLUDE_DIRS="%CAIRO_INCLUDE_DIRS%" -DCAIRO_LIBRARIES="%CAIRO_LIBRARIES%32" ..\..\rdkit

msbuild "ALL_BUILD.vcxproj" /m /p:PlatformTarget=x86 /p:Configuration=Release /maxcpucount:4 /t:Build

copy Code\JavaWrappers\csharp_wrapper\Release\RDKFuncs.dll Code\JavaWrappers\csharp_wrapper
copy ..\..\rdkit\Code\JavaWrappers\csharp_wrapper\RDKit2DotNet.csproj Code\JavaWrappers\csharp_wrapper
robocopy ..\..\rdkit\Code\JavaWrappers\csharp_wrapper\swig_csharp Code\JavaWrappers\csharp_wrapper\swig_csharp /E
del Code\JavaWrappers\csharp_wrapper\swig_csharp\FilterCatalogParams.cs
copy %THISDIR%\FilterCatalogParams.cs.fixed  Code\JavaWrappers\csharp_wrapper\swig_csharp\FilterCatalogParams.cs
copy %THISDIR%\RDKit.cs  Code\JavaWrappers\csharp_wrapper\swig_csharp\RDKit.cs
msbuild "Code\JavaWrappers\csharp_wrapper\RDKit2DotNet.csproj" /m /p:Configuration=Release /maxcpucount:4 /t:Build /p:Platform=AnyCPU

goto :eof

:find-files
    for /r "%~1" %%P in ("%~2") do (
        copy "%%~fP" "%~1"\lib
    )
goto :eof

REM Copies files to the lib64 directory
:find-files-64
    for /r "%~1" %%P in ("%~2") do (
        echo %%~fP|find "address-model-64" >nul
        if errorlevel 1 (echo notfound) else (copy  "%%~fP" "%~1"\lib64)          
    )
goto :eof

REM Copies files to the lib32 directory
:find-files-32
    for /r "%~1" %%P in ("%~2") do (
        echo %%~fP|find "address-model-32" >nul
        if errorlevel 1 (echo notfound) else (copy  "%%~fP" "%~1"\lib32)
    )
goto :eof

