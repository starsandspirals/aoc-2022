-- Advent of Code 2022 day 5, with Elm
-- try this at https://ellie-app.com/new

module Main exposing (..)

import Browser
import Html exposing (Html, Attribute, div, textarea, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)
import String exposing (split, words, lines, toInt, slice, join)
import List exposing (filterMap, reverse, drop, take, range, foldl, head, length, isEmpty)
import Maybe exposing (map3, withDefault)
import Array exposing (Array, empty, repeat, get, set, toList)

type alias Box = { c : String } 
type alias Instruction = { n : Int, a : Int, b : Int } -- move *n* from *a* to *b*

-- I tried to use the Parser library for a good while but it was like beating
-- my head against a brick wall, so I ended up having to roll my own!
parseInput : String -> Maybe (Array (List Box), List Instruction)
parseInput input = 
        case split "\n\n" input of
            [stacks, instructions] -> Just (parseStacks stacks, parseInstructions instructions) 
            _                      -> Nothing

-- aah this function is horrendous and imperative, don't even look at it
parseStacks : String -> Array (List Box)
parseStacks block =
    case lines block of
        (first :: rest) ->
            let
                columns = String.length first + 1 // 4

                buildOneStack line column arr =
                    let
                        tag = slice (column * 4 - 3) (column * 4 - 2) line
                        oldStack = withDefault [] (get column arr)
                        newStack = case tag of
                            " " -> oldStack
                            _   -> ({c = tag} :: oldStack)
                    in set column newStack arr

                parseOneLine line arr = foldl (buildOneStack line) arr (range 1 columns)

            in (first :: rest)
                |> reverse
                |> drop 1
                |> foldl parseOneLine (repeat columns [])

        [] -> empty

-- these ones are nice, you can look at them if you want to :)
parseInstructions : String -> List Instruction
parseInstructions block = filterMap parseInstruction (lines block)

parseInstruction : String -> Maybe Instruction
parseInstruction line =
    case words line of
        ["move", n, "from", a, "to", b] -> map3 Instruction (toInt n) (toInt a) (toInt b)
        _                               -> Nothing

extract : Array (List Box) -> String
extract stacks = drop 1 (toList stacks)
                    |> filterMap head
                    |> List.map .c
                    |> join ""

part1 : Array (List Box) -> Instruction -> Array (List Box)
part1 stacks inst = 
    let
        oldA = withDefault [] (get inst.a stacks)
        oldB = withDefault [] (get inst.b stacks)
        moveBox _ (a, b) = (drop 1 a, take 1 a ++ b)
        (newA, newB) = foldl moveBox (oldA, oldB) (range 1 inst.n)
    in stacks
        |> set inst.a newA
        |> set inst.b newB

part2 : Array (List Box) -> Instruction -> Array (List Box)
part2 stacks inst = 
    let
        oldA = withDefault [] (get inst.a stacks)
        oldB = withDefault [] (get inst.b stacks)
        (newA, newB) = (drop inst.n oldA, take inst.n oldA ++ oldB)
    in stacks
        |> set inst.a newA
        |> set inst.b newB

rearrange : (Array (List Box) -> Instruction -> Array (List Box))
            -> (Array (List Box), List Instruction) -> Array (List Box)
rearrange fn (stacks, instructions) =
    case instructions of
        [] -> stacks
        (first :: rest) -> rearrange fn (fn stacks first, rest)

-- the lack of type classes is really the most painful thing about Elm.
-- having separate map functions for every single monad makes you feel
-- like you're living in prehistoric times when coming from Haskell!
procedure : (Array (List Box) -> Instruction -> Array (List Box))
            -> String -> String
procedure fn input =
    case input
        |> parseInput
        |> Maybe.map (rearrange fn)
        |> Maybe.map extract
    of
        Nothing -> "error, check your input!"
        Just s -> s

-- Elm doesn't really... have IO... or interact with stdin... so this time
-- we do a tiny web app like it's 2016 and I'm an undergrad all over again
main = Browser.sandbox { init = init, update = update, view = view }

type alias Model = { input : String }

init : Model
init = { input = "" }

type Msg = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newInput ->
      { model | input = newInput }

view : Model -> Html Msg
view model =
  div []
    [ textarea [ placeholder "Paste your input here", value model.input, onInput Change ] []
    , div [] [ text <| "Boxes at top of stacks after rearrangement by CrateMover 9000: " ++ procedure part1 model.input ]
    , div [] [ text <| "Boxes at top of stacks after rearrangement by CrateMover 9001: " ++ procedure part2 model.input ]
    ]