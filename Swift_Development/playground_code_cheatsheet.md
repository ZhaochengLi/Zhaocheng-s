Learning Swift Programming using Playground
===
### Notes and Code Summary

---
Lesson 2: Naming and Identifier
===
1. Use the word ***let*** followed by a name to define a constant and the equal sign = to give a value to the constant:
			
       let num = 6 // This is also called declaration and then assignment.
       let num2 = 18
       let sum = num + num2
       
2. In swift, you can use ***Emoji*** as names, although it is NOT suggested.
3. *statement* is referred as one line of code.
4. Commenting with "//"

---
Lesson 3: Strings
===
1. Strings are made of characters, and each character can be NOT just a letter, but a symbol, a space, a punctuation mark, a number, etc,.
2. the declare a string,
		
       let mystr = "my first string in Swift!"
3. Language is not restricted to English only.
4. Of course, you can also use emoji in names.
5. String combination.

	   let mystr2 = "Hello, world!"
       comb = mystr + " " + mystr2
6. String interpolation: "fill in the blanks"

---
String Interpolation
===
Sometimes we want to declare a string in which part of it is still unassigned with string values. Without string interpolation, we can only do:

	let name = "Peter"
    let city = "Paris"
    
    let words = "Hello" + name + ", Welcome to" + city + "!"
    
    // but with string interpolaion, note that we use \(var) as place holder for variable "var"
    let words = "Hello \(name), welcome to \(city)."
    // see, it is better.

---
7. Quotation makrs inside strings , we will use backslash like $\"$. The pattern of an *escape character* followed by something thatÃ¢â‚¬â„¢s treated specially is called an *escape sequence*. \ is the *escape character*.

	   let words = "He said, \"Hi, there!\" as he passed by."
8. We have already seen two escape characters, the quotation one and placeholder one, there is another one called *newline* character, which will start a new line.

		let words = "this is a two \nline of string" // the newline starts where the \n appears.
        // it will look like
        // " this is a two
        // line of string"
        
---
Lesson 4: Hello, world!
===
1. The console. When you are running your code, the console will receive NO feedback unless the programmer gives the instruction to **print**.

	   print("Hello, world!") // then the console will have the message.
2. Logging. Like a captain's log, apps have logs too. When coder prints the messages to the console, it's usually to record, or to *log*, information about a program as it runs. Printing messages to the console is known as *logging* and the messages are sometimes called *log messages*. Programmer always uses *log messages* to indicate that something has gone wrong or something unexpected has happened.
3. the *print* statement is also widely used when ***debugging***

---
Lesson 5: First App
===

Apps are not just built from code. THere are designs for the look of the screens. There are images, counds and fonts. And there are instructions for putting all these parts together. Xcode can manage it all in a workplace.

Xcode includes several build-in app tamplates for developing common types of iOS apps, such as games, apps with tab-based navigation and table-view-based apps. Most of them have a preconfigured interface and source code files.

The main file you are going to edit in Xcode will be .swift files and .storyboard files, where
- *.swift files* tell your app what to do, and when and how to do it.
- *.storyboard files* tell your app where to diaplay information on the screen. It will be opened in a special environment called *interface builder*.

---
Of course, there are other types of files too, but you do not need to interact with them much.
- *.xcassets*, this item holds all the images for your app, including the app icon.
- *.plist*, these files manage you app's setup information. You will find it tough to decipher. Anyway, you won't interact with them basically.

---
Lesson 6: Functions
===
Function: a block where your code was built into, in order to be used multiple times. Otherwise, you have to type lines of codes over and over again to make them used multiple times.

- Remember, repeating yourself is one thing that a progrmmer should avoid.

Here is a very simple function:

	func oneFunBoat(){
    	print("This is your first Swift function!")
    }

The content in between the "{}" ia called the *body* of the function. After building the function, you need to call the function to make it useful.

---
After learning the basic structure of the functions, we can build the function, we can build a function nested into another function.

we can also make an **infinite loop**, which means calling the function which also calls the function itself over and over again .... But normally, it wouldn't go infinitely. Because eventually it will run out of the memory and crash.

---
Lesson 7: BoogieBot
===
The set of functions that control BoogieBot is an example of an *Application Programming Interface*, or *API*. It is a specific set of functionality that can be used by a software developer to accomplish a task. In this case, the BoogieBot API is making a software robot dance.

---
### Algorithms
During this lesson you've been creating different dance routine for BoogieBot by combining moves into functions. Computer scientists would say that you've spent this lesson developing *algorithms*

When you develop an algorithm, you are defining a series of steps to be performed. They do not have be dance steps. of course; any self-contained step-by-step series of operations is an algorithm.

---
### iOS features
During the iOS app development, there are some iOS features we can use in our app.
- GPS
- Camera
- Touchscreen
- Accelerometer

---
Lesson 8: Variables
===
### Constants and Variables
- Constants stays the same, variables are able to change over time.

	  // declaring a constant, which is not available to change.
      let const = "I am a constant"
      // declaring a variable, can be changed over time
      var varbl = "I am a variable"
- You can also use += for the shortcut, it works on the strings as well.
- Be aware that in order to prevent the confusing changes, always set it as constant if you do not want to change it.

---
Lesson 9: Types
===
- Every value has a type
- and each type in Swift has its own set of properties and behaviours.

---
- String
- Int, value is a whole number with no fractional component.
- Double, value with a decimal point.

---
**This is important: the value of a variable can change, but the type of the variable/constant can not be changed**.

- Binary operator "+": the operator can not be applied on different types of values. Int and Double will do, Int/Double and String can not.

- *type annotation*, you can add an extra piece of information, to tell Swift exactly what type you want to use.

`// for example`
`let annotationDouble: Double = 20`
`// or simply declare the type`
`var some: Int`

---
#### Importing frameworks
to use a framework in your program, you have to *import* it:
`import Foundation`
- One of the types from the Foundation framework is *Date*, which represents a specific moment in time. To create a *Date* representing right now, you simply use *Date()*:

`let today = Date()` 
`// and more interesting, it works when`
`let somedate = Date() + 300`
`// the int you add is seconds`

---
Lesson 10: Prameters and Results
===

	func hello(name: String){
    	print("hello "+name)
    }
    
    // call the function
    hello(name: "Maria")
and of course, it has the possibility of passing more than one parameters.

---
#### Returning values
to declare a function that returns a value, you have to add two things to your code. You will understand it through an example.

	func example(p1:Int, p2:Int) -> String{
		return "p1 is \(p1), p2 is \(p2)"
	}

you can have multiple parameters, but you can only return one value.

---
Building functions is a way of grouping tasks together, each function is a building block for a larger program.

Functions can also:
- take information in
- do work
- return info
- hiding complexity is one of the key benefits that using functions brings to your code.

---
#### argument name and parameter name
when you build a function:
	
    func printHello(to name: String){
    	print("Hello " + name)
    }
    
    // and you call it:
    printHello(to: "Leo")
You will notice that the parameter has been named twice. You see the first name when you call it and use the second name inside the body of the function.

The name you see when calling a function (and passing in one or more arguments) are called **argument labels**.

The names used inside the function (the values that have been received) are **parameter names**.

---
If you do not care about the argument label, you can simply not to use it.

	func printHello(_ name: String){
    	print("Hello " + name)
    }
    
    //no argument label needed
    printHello("Maya")
    
---
Lesson 11: Making Decisions
===
In Swift, *true* and *false* are special values. They are known as *Boolean values*. The *Bool* type is used in Swift to represent Boolean values. The only possible Bool values are true and false.

---
- Equality using *==*: the double euqal sign checks if two values equal, for example

		1 == 2 // in this case, they are not, thus the value is false, true otherwise.
   
- In fact there are more:

		1 < 2
        1 > 2
        1 <= 2
        1 >= 2
        1 != 2

---
- Conditionals

		if <condition> {
        	<commands>
        }
        else if <condition>{
        	<commands>
        }
        else if <condition>{
        	<commands>
        }
        else {
        	<commands>
        }
        
---
Lesson 12: Instances, methods, properties
===
For every type in the real world, there are many actual phtsical instances. For example, for the type *car*, there are countless individual variations on the road.

---
**The type defines or describes the properties and behaviours of a particular kind of thing. But each concrete example of the type -- each car, each city -- is a separate, independent instance of the type.**

**In programming, you can create and use different instances of a given type. Each instances has its own set of property values, and each instance can perform bahaviour independent of other instances.**

---
#### Instances
	let hello = "hello"
    let he = "hello"
    // in this case, *String* is a type, and each individual String value, like "hello", is called an instance of that type.
    // hello and he are two instances although they happen to have the same value.
    
So far, you've created almost every instance by typing a literal value directly into code. But there are also other ways.

	let ab = Date()
    let str = String()
    let bo = Bool()
	let num = Int()
What you do right now is using an *initializer*. You use initializers to create a new instance of a particular type. **Only** a few type, like *String*, *Bool*, and *Int* can be create using literals, but every type has at least one initializer.

Of course, in cases, initializers allow parameters.

---
#### Methods
**Functions can be defined as part of a type.** These functions are called *instance methods* or just *methods*. String has many instance methods, which are used for common operations.

Let's use an example:

Suppose we want to know if a string begins with another string. We use function/method *hasPrefix()* to check prefix.

	func hasPrefix(_, prefix: String) -> Bool
    
    let intro = "It is a beautiful day."
    let bang = "bangbangbang"
    
    // then we use the method on intro
    // Be aware, we use parameter here!
    intro.hasPrefix("It is")
    bang.hasPrefix("bang")

---
Instance methods are called by using a period (.) after the instance, as above. This is known as calling a method on the instance. You've called *hasPrefix()* on *intro*.

You do not need to pass in the value of *intro*. The method is being performed by the instance assigned to *intro*, so the value is already available to it.

The logic is this: 

	String is a type;
    hasPrefix() is a method of String;
    now intro is an instance of String;
    hasPrefix() is performed on the instance
    
---
Of course, **you cannot use an instance method on an instance of the wrong type. You can only use methods that are part of, or members of a particular type.**

---
#### Properties
In Swift, each instance has one or more pieces of associated information. These values are known as properties.

If often useful to know if a string contains any characters at all. The property *isEmpty* answers this question.

The property is declared like this:

	var isEmpty: Bool { get }
The declaration looks similar to a variable declaration. Just as a method is a function built in to each instance of a type，a property is a constant or variable built in to each instance of a type.

---
In this case,
	
    let something = "haha"
    something.isEmpty
    
The property is named *isEmpty* and is of type *Bool*. It is marked *var* because the property value could change if the string contents change.

The { get } indicates you can only get the value of this property, but you cannot set it. This is also called a *read-only* property.

- You cannot use a property without an instance
- YOu can only use properties that are part of the type of the instance.

---
Properties vs. Methods
===
- What is the difference?
- When do you ise each one?

---
- Variable vs. Function: 
The difference between a method and a property os similar to the difference between a function and a variable/constant.

A variable is useful for referring to a value that you can access when required. Similarly, a property provides a way to get or set a value that's part of an instance. Each instance can hace a different value for that property.

A function is useful providing behaviour that can be repeated as needed. A method works in the same way, providing bahaviour specific to that instance.

---
- Arguments
If the work you want to perform needs extra information, then it must be a method, **since you cannot pass arguments to a property.**

This means *hasPrefix()* must be a method, because you need to pass in the prefix you are testing for.

---
- Side Effects
If the work has side effects, things that happen that aren't related to the return value, then it is a method. For example, String has a method, *removeAll()*, which empties the string:

	var magic = "Now you see it."
    magic.removeAll()
    magic

---
- Values
Poperties are for getting values from an instances and, as you will see later, for setting values on an instance. Properties do not do any additional work.

- They are all used often

---
#### Sruct
When we look over the documentation for *String*, we see:
> Declaration **struct String**

and also:
> **class UIColor**

As you build app in Swift, you'll work with instances of both structs (short fot structures) and classes. **Both provides a way to define types in Swift**.

---
For now, it is enough to know that structs and classes have many similarities.
- Both have instances
- Instances are created with an initializer
- Both can have methods
- Both can have properties.

**When you create and use instances, you will write the same Swift code whether a type is a struct or class.**

---
Lesson 13: QuestionBot
===
- We are gping to design the "brain" of an app that can answer clients' simple questions.

---
Apperently, when we use the function ***hasPrefix()***, the function will not automatically consider the lowercases and the uppercases of the same words as identical letters. Simply,

	"hello" == "HELLO" // it is false
    "hello" == "Hello" // it is false
    
But we want them to be the same right? We can use,

	let words = "HAHaha"
    let test = words.lowercased()
    
    test.hasPrefic("hah") // it would be TRUE!

---
When you have a string, you can also use function *count* to get the number of letters out of it.

	"haha".count // returns 4
    "ha ha".count // returns 5 instead, after adding the space

---
Lesson 14: Arrays and loops
===
- Lists;

		let alist = ["hello", "hi", "iMac"]
		// same, indices start at 0
		// use .count to count the number of elements
        alist.count // it would be 3
In Swift, a list is called an array.
- Loops, could be ran for each item in an array. You can use *for* loop. Same syntax as it in Python.

---
- Mutable arrays; Same asa defining constants/variables, you can use either *let* or *var* to define your arrays. If you use *let*, then it is immutable, otherwise, it is mutable.

Therefore, the the operations we are going to mention below, they only work on mutable arrays. Aka, the arrays defined by *var*.

---
Also, remember that an array of *String* values has the type *[String]*, and a type followed by parentheses is how you create an instance of that type. So you can define an array like this:

	var list = [list]()
    // and since it is a variable, you can modify it.

---
- Adding items

		list.append("Banana") // adding a single item
        
        list.insert("Banana", at:0) // adding an item at specific place. But it has to be within the array or the program will crash.
        
        list += ["rain", "sunny", "windy"]
        // you can add a whole array like this.
        
---
- Removing items

		var num = [1,2,3,4,5]
        
        num.remove(at:2)
        // it removes item by the index, and returns the removed item.
        // now num = [1,2,4,5]
		
        num.removeFirst()
        // it removes and returns the first item in the list
        
        num.removeLast()
        // remove and return the last one.
        // the last two methods must work on nonempty lists, otherwise it will cause error.
        
        num.removeAll() 
        // remove everything, return empty list. num is empty as well.
        
---
- Replace items

		// you can change it directly
        list = [1,2,3,4,5]
		
       	list[3] = 10
        // replaced!

---
Lesson 15: Structures
===
When building an app, one of the most important things to think about is how your app is going to represent the information that it needs.

Some apps are software models of the real world. For example, a shopping app has products, shopping carts, customers and orders similar to a physical store.

In general, the types of data that an app deals with are known collectively as its model, or sometimes more verbosely, its data model.

---
A *model* is specific to a particular app:
- A music player app might work with tracks, artists, albums and playlists.
- A drawing app might work with pens, brushes, a canvas and shapes the user has drawn.

You know about some types: *String*, *Int*, *Double*, *Bool*. But how can you use them to represent a song? Or a list of songs? You gonna use multiple list with each list representing each one of them.

It is better to have a *Song* instead of a *String*, a *String* and an *Int*.

Let's define a type *Song*.

---
Custom Types with *struct*
===
You are not limited to the types that come built-in with Swift. You can use existing types as building blocks to define your own types. One way to create a new type in Swift is to define a *structure*. A *struct* is a simple way of grouping values of other types together.

---
You can declare a *Song* struct like this:
	
    struct Song{
    	let title: String
        let artist: String
        let duration: Int
        var rating: Int
    }
    
    // once you created an instance like this
    let song = Song(title: "No no no", artist: "Fizz", duration: 150)
    
    // once you've created your own custom type and an instance of it. You can work with its properties the same way
    song.title
    song.artist
    song.duration

---
- *let* and *var*; immutability and mutability

		// such as song you defined, you can change rating since it is a variable.
        song.rating=5
        // but the instance "song" is goona be a variable, not constant.

---
- You can also have a *calculated property* to the struct like this

		struct Song{
    		let title: String
        	let artist: String
        	let duration: Int
        	var rating: Int
            
            var formattedDuration: String {
        		let minutes = duration / 60
        		// The modulus (%) operator gives the remainder
        		let seconds = duration % 60
        		return "\(minutes)m \(seconds)s"
    		}
    	}
        
      let song = Song(title: "No, no, no", artist: "Fizz", duration: 150)
	  song.formattedDuration // it would be 2 min 30 seconds
      
---
For this and next section. *functions* and *Instance Method*, we will talk altogether with an example.

	struct Rectangle {
    	let width: Int
    	let height: Int
    
    	func biggerThan(_ rectangle: Rectangle) -> Bool {
        	let areaOne = width * height
        	let areaTwo = rectangle.width * rectangle.height
        	return areaOne > areaTwo
    	}
	}
    
    let rectangle = Rectangle(width: 10, height: 10)
	let otherRectangle = Rectangle(width: 10, height: 20)

	rectangle.biggerThan(otherRectangle)
	otherRectangle.biggerThan(rectangle)

---
- Notice that within the body of the method definition, you can access the values of height and width of the struct without using a dot. The instance method is written as part of the struct definition, and so it can directly access the properties within the instance.

---
Lesson 19: Enumerations and Switch
===
Recall when making decisions, we often use *if* statements，in this section, we will try type *enumeration* to represent a group of related choices. Each choice is called a *case*. You can define your own enumeration types, just as you can define your own *structs*

	enum Lunchchoice{
   	    case pasta
        case burger
        case soup
        // or to save space: case pasta, burger, soup
    }
    
    let choice = Lunchchoice.burger
    
this declaration above creates a new type, *Lunchchoice*, and instances of it can **only** be one of the three defined cases.

---
One thing worth noticing is that the variable has a type annotation:

	var choice: Lunchchoice
    // at this stage, the variable choice has not be initialized yet.
    
    choice = .burger // you can change
    choice = .pasta
    
    //of course
    let meal: Lunchchoice
    meal = .pasta // but you cannot change

---
- So when to use Enums?

Whenever you have a restricted group of related values in your code, it might be good to think about using an *neum*.

If there are no restrictions on the value, or you have a large number of possible values, enums probably aren't a good fit.

---
Imagine you are wrting a fun little sports game, and you are using a *struct* to represent each player on the field. Each player has the following properties:
- name, a String, you wouldn't use an enum here because there are so many possibilities;
- skilllevel, an Int;
- team, it could be an enum, there are only two teams on the field: .red and .blue;
- position, could be an enum, .quarterback, .seeker, .pitcher, and so on, depending how you design the game.

---
- Comparing Enums

		let mylunch = Lunchchoice.pasta
        let yourlunch = Lunchchoice.soup
        
        if mylunch == yourlunch {
        	blahblahblah
        }

---
- Enums and Funtions

		func cookLunch(_ choice: LunchChoice) -> String {
    
    		if choice == .pasta {
        	    return "🍝"
    		} else if choice == .burger {
        	    return "🍔"
    		} else {
        	    return "🍲" // it is actually not anything, it is soup
                // but if you use else if choice == .soup, you still gonna need one more return
                // value outside the if-statements, but you will never get there.
    		}
		}

		cookLunch(.burger)

---
You will soon realize the if-statements are not a good fit when dealing with *enums*. 

They add a lot of visual noise, and they cannot tell that you've covered all of the cases, even though the point of enums is to provide a limited list of cases.

The *switch* statement is a better way.

---
	
    enum LunchChoice {
        case pasta
        case burger
        case soup
	}

    let choice = LunchChoice.burger
    
    switch choice {
    case .pasta: "🍝"
    case .burger: "🍔"
    case .soup: "🍲"
    }
    
    // switch is designed to work very well with enums
If the value being checked matches the case statement, the code between the matched case and the next case is run. Then the switch statement, just like the if-statement, is done.

---
- Exhausting the possibilities. *Switch-statements* have a special feature: they must be exhaustive. This means a switch statement must exhaust every possibility of the value being checked. With an enum, you can use a different case to handle every possible value. (i.e., it must cover all the cases that enum has.)

- The default case, see the example next page, the *switch-statements* does not have a case for every possible value of the enum. Instead, there is a *default* keywaord which will be used if no other matches are found. This is similar to the *else* clause in an if-statements

---

	enum Quality {
    	case bad, poor, acceptable, good, great
	}

	let quality = Quality.good
    
    switch quality {
	case .bad:
    print("That really won't do")
    case .poor:
    print("That's not good enough")
    default:
    print("OK, I'll take it")
    }

---
- Multiple cases

A default case might cause you problems later on if you add new cases to enum. The switch statement will use the default case for your new value, which may not be what you want. **Instead, you can match several values in the same case.**

	switch quality {
	case .bad:
    print("That really won't do")
	case .poor:
    print("That's not good enough")
	case .acceptable, .good, .great:
    print("OK, I'll take it")
	}

---
Other than using with enums, you can also use *switch-statements* with other values. For example, it can work with strings and numbers, since **it is impossible to have an exhaustive list of all string and number values, switch-statements using these types require a default case.**

	let animal = "cat"

	func soundFor(animal: String) -> String {
    	switch animal {
        	case "cat":
            	return "Meow!"
        	case "dog":
            	return "Woof!"
        	case "cow":
            	return "Moo!"
        	case "chicken":
            	return "Cluck!"
        	default:
            	return "I don't know that animal!"
    	}
	}

	soundFor(animal: animal)
    
---
- Back to the cafe

		enum LunchChoice {
   	        case pasta, burger, soup
		}

		func cookLunch(_ choice: LunchChoice) -> String {
    	    switch choice {
                case .pasta:
                    return "🍝"
                case .burger:
                    return "🍔"
                case .soup:
                    return "🍲"
            }
        }

        cookLunch(.burger)
        
---
- Enum Methods and Properties

In the Structures lesson you saw how to define properties and methods in a struct, you can also define them in an enum. This can be very useful in providing extra behaviour. Foe example:

	enum LunchChoice {
    	case pasta, burger, soup
    
    	var emoji: String {
        	switch self {
        		case .pasta:
            		return "🍝"
        		case .burger:
            		return "🍔"
        		case .soup:
            		return "🍲"
        	}
    	}
	}

	let lunch = LunchChoice.pasta // pasta
	lunch.emoji // "(pasta emoji)"
    
---
- Another example:

		enum Suit {
    		case spades, hearts, diamonds, clubs
    
    		var rank: Int {
        		switch self {
        			case .spades: return 4
        			case .hearts: return 3
        			case .diamonds: return 2
        			case .clubs: return 1
        		}
    		}
    
    		func beats(_ otherSuit: Suit) -> Bool {
        		return self.rank > otherSuit.rank
    		}
		}

		let oneSuit = Suit.spades   //spades
		let otherSuit = Suit.clubs  // clubs
		oneSuit.beats(otherSuit)    // True
		oneSuit.beats(oneSuit)      // False