-- Advent of Code 2022 day 1, with Ada
-- try this at https://tio.run/#ada-gnat

pragma Ada_2020;

with Ada.Text_IO; use Ada.Text_IO;

-- let's use vectors, it's more elegant than just making a huge array
with Ada.Containers.Vectors;

procedure Main is

  -- but it does mean we need a bunch of boilerplate...
  package Int_Vec is new Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Integer);
  use Int_Vec;

  -- and we'll need to be able to sort them later on, too
  package Int_Sort is new Int_Vec.Generic_Sorting;
  use Int_Sort;
  
  Calories : Integer := 0;
  Elves : Vector := Empty_Vector;

  -- doing things generically so we can deal with parts 1 and 2 in one go!
  function Sum_Elves (Vec : Vector; Num : Integer) return Integer is

  -- we can't just use the vector from the parameters, because we're not allowed
  -- to mutate it from in here, so we make a copy instead. feels a bit Rust-ish
  Rank : Vector := Vec;
  Sum : Integer := 0;

  begin
    Sort (Rank);
    Reverse_Elements (Rank);

    -- vectors aren't zero-indexed?! oh, because I said so earlier,
    -- when I made the index type "Positive" rather than "Natural" ;) 
    for Index in 1..Num loop
        Sum := @ + Rank (Index);
    end loop;

    return Sum;
  end Sum_Elves;

begin
  while not End_Of_File (Current_Input) loop
    declare
        Line : String := Get_Line (Current_Input);
    begin
        if Line'Length = 0 then
            Append (Elves, Calories);
            Calories := 0;
        else
            -- the @ syntax for "this thing right here" is a new feature, apparently,
            -- so I had to turn on the Ada 2020 language pragma... but it looks neat
            Calories := @ + Integer'Value (Line);
        end if;
    end;
  end loop;

  -- Integer'Image is a very hipster way to say "cast integer to string"
  Put_Line("Maximum calories carried by one elf =" & Integer'Image (Sum_Elves (Elves, 1)));
  Put_Line("Maximum calories carried by three elves =" & Integer'Image (Sum_Elves (Elves, 3)));

end Main;