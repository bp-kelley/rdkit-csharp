# rdkit-csharp
Build scripts for csharp release of the RDKit

Requirements:

  1. cmake 3.0+
  2. MSVC build environment 2014+ (32 and 64 bits)
  3. nuget.exe

Simply run build.bat and the C# version of the RDKit should be built.

Notes
=====

The patched files mainly allow both the 32 and 64 bit c# versions to
co-exist in the same nuget package.  This should probably be a
non-manual patch at some point, as only the Initialize function needs
to be added to the source code.  Until then, these files need to
be inspected for every new RDKit release.

```
  public static class RDKit
  {
    public static void  Initialize()
    {
      var path = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
      path = Path.Combine(path, IntPtr.Size == 8 ? "x64" : "x86");
      bool ok = SetDllDirectory(path);
      if (!ok) throw new System.ComponentModel.Win32Exception();
    }
    
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern bool SetDllDirectory(string path);
  }
```