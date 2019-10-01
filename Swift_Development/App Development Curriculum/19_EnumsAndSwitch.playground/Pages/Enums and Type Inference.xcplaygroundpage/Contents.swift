/*:
 ## Enums and Type Inference
 
 Swift can save you some typing when it expects a particular type of enum.
 
 Here’s the `LunchChoice` enum from the previous page. It’s written a little differently. To save space, it includes multiple cases on a single line, separated by commas:
*/
enum LunchChoice {
    case pasta, burger, soup
}
/*:
 On the previous page you made an enum instance like this:
 
`let choice = LunchChoice.burger`
 
 This variable has a type annotation:
*/
var onel: LunchChoice
onel = .burger





let come: LunchChoice
come = .burger
// come = .pasta you cannot

//: - experiment: Practise assigning other values to `choice` using this shorter dot notation. Notice that the autocompletion menu pops up once you type the period.




/*:
 Next, learn when it makes sense to use an enum.\
[Previous](@previous)  |  page 4 of 21  |  [Next: When to Use Enums](@next)
*/
