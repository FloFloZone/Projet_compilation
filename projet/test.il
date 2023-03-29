.assembly test {}
.assembly extern mscorlib {}
// method line 1
.method static void Main ()
{
	.entrypoint
	.maxstack 10
	.locals init (int32, int32, int32, int32, int32, int32, int32)
	ldc.i4	0
	stloc	0
	ldc.i4	1
	ldc.i4	1
dd
	stloc	1
	call string class [mscorlib]System.Console::ReadLine()
	call int32 int32::Parse(string)
	stloc	0
	call string class [mscorlib]System.Console::ReadLine()
	call int32 int32::Parse(string)
	stloc	1
	ldloc	0
	ldloc	1
	bge IL_2
IL_1:	ldc.i4	1
	call void class [mscorlib] System.Console::WriteLine(int32)
	ldloc	1
	ldloc	0
	ble IL_4
IL_3:	ldc.i4	1
	call void class [mscorlib] System.Console::WriteLine(int32)
	br IL_a
IL_4:	ldloc	0
	ldc.i4	2
	ble IL_6
IL_5:	ldc.i4	2
	call void class [mscorlib] System.Console::WriteLine(int32)
	br IL_a
IL_6:	ldc.i4	3
	call void class [mscorlib] System.Console::WriteLine(int32)
IL_2:IL_a:	ldloc	1
	ldloc	2
	ble IL_c
IL_b:	ldc.i4	1
	ldc.i4	2
dd
	call void class [mscorlib] System.Console::WriteLine(int32)
	ldloc	2
	ldc.i4	4
	bge IL_e
IL_d:IL_13:	ldloc	2
	ldc.i4	4
	bge IL_10
IL_f:	br IL_13
IL_10:	ldc.i4	44
	call void class [mscorlib] System.Console::WriteLine(int32)
IL_f:IL_14:IL_e:IL_15:	stloc	3
IL_1a:	ldloc	3
	bne.un IL_17
IL_16:	br IL_1a
IL_17:IL_1f:	ldloc	3
	ldc.i4	1
	bne.un IL_1c
IL_1b:	br IL_1f
IL_1c:	call string class [mscorlib]System.Console::ReadLine()
	call int32 int32::Parse(string)
	stloc	4
	call string class [mscorlib]System.Console::ReadLine()
	call int32 int32::Parse(string)
	stloc	5
IL_24:	ldloc	5
	ldc.i4	0
	bne.un IL_21
IL_20:	br IL_24
IL_21:	ldloc	6
	call void class [mscorlib] System.Console::WriteLine(int32)
IL_20:IL_1d:	ret
} // end of method test::Main
