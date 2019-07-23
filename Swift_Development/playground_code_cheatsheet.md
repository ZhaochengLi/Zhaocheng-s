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