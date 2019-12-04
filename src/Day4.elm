module Day4 exposing (..)

import Html exposing (Html, text)


lowNumber : Int
lowNumber =
    254032


highNumber : Int
highNumber =
    789860


type alias Number =
    { one : Int, two : Int, three : Int, four : Int, five : Int, six : Int }


type alias NumberGetter =
    Number -> Int


type alias NumberSetter =
    Number -> Int -> Number


iterate : ( NumberGetter, NumberSetter ) -> List ( NumberGetter, NumberSetter ) -> Int -> Number -> List Number
iterate ( nextNumberGetter, nextNumberSetter ) remainingNumbers previousUnit currentNumber =
    List.range previousUnit 9
        |> List.map (nextNumberSetter currentNumber)
        |> List.filter (\number -> isInRange number remainingNumbers)
        |> (\numbersToExplore ->
                case remainingNumbers of
                    [] ->
                        List.filter hasTwoConsecutiveNumbersStep2 numbersToExplore

                    next :: remaining ->
                        List.map (\number -> iterate next remaining (nextNumberGetter number) number) numbersToExplore
                            |> List.concat
           )


isInRange : Number -> List ( NumberGetter, NumberSetter ) -> Bool
isInRange numberLow accessors =
    let
        numberHigh =
            List.foldl (\( _, setter ) high -> setter high 9) numberLow accessors

        lowBound =
            numberLow.one * 100000 + numberLow.two * 10000 + numberLow.three * 1000 + numberLow.four * 100 + numberLow.five * 10 + numberLow.six

        highBound =
            numberHigh.one * 100000 + numberHigh.two * 10000 + numberHigh.three * 1000 + numberHigh.four * 100 + numberHigh.five * 10 + numberHigh.six
    in
    highBound >= lowNumber && lowBound <= highNumber


hasTwoConsecutiveNumbersStep1 : Number -> Bool
hasTwoConsecutiveNumbersStep1 number =
    number.one
        == number.two
        || number.two
        == number.three
        || number.three
        == number.four
        || number.four
        == number.five
        || number.five
        == number.six


hasTwoConsecutiveNumbersStep2 : Number -> Bool
hasTwoConsecutiveNumbersStep2 number =
    (number.one == number.two && number.two /= number.three)
        || (number.two == number.three && number.three /= number.four && number.one /= number.two)
        || (number.three == number.four && number.four /= number.five && number.two /= number.three)
        || (number.four == number.five && number.five /= number.six && number.three /= number.four)
        || (number.five == number.six && number.four /= number.five)


main =
    iterate oneAccessors [ twoAccessors, threeAccessors, fourAccessors, fiveAccessors, sixAccessors ] 0 (Number 0 0 0 0 0 0)
        |> List.length
        |> String.fromInt
        |> text


oneAccessors : ( NumberGetter, NumberSetter )
oneAccessors =
    ( .one, \number one -> { number | one = one } )


twoAccessors : ( NumberGetter, NumberSetter )
twoAccessors =
    ( .two, \number two -> { number | two = two } )


threeAccessors : ( NumberGetter, NumberSetter )
threeAccessors =
    ( .three, \number three -> { number | three = three } )


fourAccessors : ( NumberGetter, NumberSetter )
fourAccessors =
    ( .four, \number four -> { number | four = four } )


fiveAccessors : ( NumberGetter, NumberSetter )
fiveAccessors =
    ( .five, \number five -> { number | five = five } )


sixAccessors : ( NumberGetter, NumberSetter )
sixAccessors =
    ( .six, \number six -> { number | six = six } )
