.assembly extern mscorlib
{
  .ver 4:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly 'ReadWrite'
{
  .custom instance void class [mscorlib]System.Runtime.CompilerServices.RuntimeCompatibilityAttribute::'.ctor'() =  (
		01 00 01 00 54 02 16 57 72 61 70 4E 6F 6E 45 78   // ....T..WrapNonEx
		63 65 70 74 69 6F 6E 54 68 72 6F 77 73 01       ) // ceptionThrows.

  .hash algorithm 0x00008004
  .ver  0:0:0:0
}
.module ReadWrite.exe // GUID = {992229DD-F17B-4F74-B0B8-9CAECA912674}


  .class public auto ansi beforefieldinit ReadWrite
  	extends [mscorlib]System.Object
  {

    // method line 1
    .method public hidebysig specialname rtspecialname 
           instance default void '.ctor' ()  cil managed 
    {
        // Method begins at RVA 0x2050
	// Code size 7 (0x7)
	.maxstack 8
	IL_0000:  ldarg.0 
	IL_0001:  call instance void object::'.ctor'()
	IL_0006:  ret 
    } // end of method ReadWrite::.ctor

    // method line 2
    .method public static hidebysig 
           default void Main ()  cil managed 
    {
        // Method begins at RVA 0x2058
	.entrypoint
	// Code size 33 (0x21)
	.maxstack 2
	.locals init (
		string	V_0)
	IL_0000:  ldstr "Enter a string: "
	IL_0005:  call void class [mscorlib]System.Console::Write(string)
	IL_000a:  call string class [mscorlib]System.Console::ReadLine()
	IL_000f:  stloc.0 
	IL_0010:  ldstr "You entered: "
	IL_0015:  ldloc.0 
	IL_0016:  call string string::Concat(string, string)
	IL_001b:  call void class [mscorlib]System.Console::WriteLine(string)
	IL_0020:  ret 
    } // end of method ReadWrite::Main

  } // end of class ReadWrite

