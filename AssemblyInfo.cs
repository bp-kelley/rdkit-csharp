using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

[assembly:PreApplicationStartMethod(typeof(GraphMolWrap.RDKit), "Initialize")]