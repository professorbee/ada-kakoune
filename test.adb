procedure Module.Submodule.Some_Proc
   (Arg1 : in                         Positive;
    Arg2 : in out          access all Positive;
    Arg3 :                 access     Positive;
    Arg4 :        not null access all Positive)
is

   A : constant Integer := 2#0101_1001;
   B : constant         := 16#CaFe_F00d#E+10;
   C :          Integer := Some_Function_Call(0);
   D :          Integer := 500;
   E :          Float   := 1_2_3_4.5_6_7_8e-1_2_3_4;
   F :          Matrix3 := 0;
   G :          Type_5  := Value_4_3_2_1(0);

   function Some_Func(X : in Integer) return Boolean;
   function Func_Without_Args return Boolean;

begin

   null;

end Something;
