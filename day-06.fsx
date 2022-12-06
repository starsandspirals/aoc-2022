// Advent of Code day 6, with F#
// try this at https://tio.run/#fs-core

open System

// predicate testing if every character in a sequence is distinct
let unique(s) = s |> Seq.length = (s |> Seq.distinct |> Seq.length)

// slices a sequence for a given window (it's a bit dangerous...)
let subseq(s,f,l) = s |> Seq.take l |> Seq.skip f

// not too complicated recursive function to find the right index!
let rec helper(s,n,i) = if subseq(s, i-n, i) |> unique then i else helper(s, n, i+1)
let extract(s,n) = helper(s, n, n)

let input = System.Console.In.ReadLine() :> seq<char>

printfn "First start-of-packet marker: %d" (extract(input, 4))
printfn "First start-of-message marker: %d" (extract(input, 14))