procedure Module.Submodule.Some_Proc
   (Arg1 : in                         Positive;
    Arg2 : in out          access all Positive;
    Arg3 :                 access     Positive;
    Arg4 :        not null access all Positive)
is

   -- A comment
   -- Across multiple lines
   A : constant Integer := 2#0101_1001#; -- After a declaration
   B : CONSTANT         := 16#CaFe_F00d#E+10;
   C :          Integer := Some_Function_Call(0);
   D :          Integer := 500;
   E :          Float   := 1_2_3_4.5_6_7_8e-1_2_3_4;
   F :          Matrix3 := 0;
   G :          Type_5  := Value_4_3_2_1(0);
   H :          Rec     := Rec'(Val => "Some string");
   I :          String  := Integer'Image(1_2_3_4);
   J :          String  := "Integer'Image(1_2_3_4);";

   Var_With_Numbers_0000 : constant Integer := 0;

   function  Func(X : in Integer) return Boolean;
   function  Func_Without_Args return Boolean;
   procedure Proc_Without_Args;
   function  Func_With_Many_Args(X    : in     Integer;
                                 Y    :    out Integer;
                                 Z, W : in out Some_Module.Some_Type)
      return Some_Type;

   FuNcTiON Case_Insensitivity_Test ReTuRn BOOLEAN;

   type    TypeA is new Integer;
   subtype TypeB is     Integer range 1 .. 15;
   type    TypeC is     array (TypeB range <>) of aliased TypeA;
   type    TypeD is tagged null record;
   type    TypeE is new TypeD with null record;
   type    物    is new 事; -- Unicode test

begin
   null;
end Module.Submodule.Some_Proc;
