using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Reflection;

namespace GraphMolWrap {

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
}    
