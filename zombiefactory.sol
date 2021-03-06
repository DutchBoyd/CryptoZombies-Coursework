pragma solidity ^0.4.19; // Entering Solidity Version

// Lesson 1.3, going over variable assignments, and the difference between signed and unsigned integers

// Lesson 1.4, going over all the different mathematical solidity operations (+, -, *, /, %, **)

// Lesson 1.5, going over how to create a data type for an OOP paradigm... using the struct operator defines a class.

// Lesson 1.6, going over creating arrays, with fixed and dynamic array types, stringArrays, and arrays of objects (structs). Also talks about declaring an array as public
// so that solidity will automatically create a getter method for it. Example was "Person[] public people;" which is going to create an array of people objects and I assume
// allow you to create people directly by assigning values to the Person[] array. I guess we'll see. Other Ethereum contracts can read (but not write) to this array.
// Remember to format your struct arrays with the object name first, the length of the array in the brackets, public if it's a public array, and the name of the array last. E.g. "Zombie[] public zombies;"

// Lesson 1.7, going over functions in solidity. This looks very much like Javascript... "function <name>(param1, type, param2, type, etc.) {}" and calling it with "<name>(param1,param2,etc);"
// Trying to remember when they are passing paramaters in functions why they put an underscore before the paramater name as a best practice.

// Lesson 1.8, going over creating objects, or "structs", and also pushing them into arrays. Showing that you can create a person struct using the format 'Person satoshi = Person(172, "Satoshi");' and 
// use the ".push" method after an array name. E.g. "people.push(satoshi);" and can combine the two 'people.push(Person(16, "Vitalik"));' as an example. The push method will add to the END of the array.
// One thing I don't really love about this exercise is I think the name of the new Zombie that they are having us create in the createZombie function is going to just be "Zombie", which is kind of confusing
// since the struct class is also named Zombie. I think if I were creating the class, I'd name the Zombie object in our function newZombie instead. They also say do it in one line of code to keep things clean, but
// probably doing it in two lines of code and refactoring in the next step is probably clearer. Whatevs... this is for hardcore coders I suppose.

// Lesson 1.9, going over public vs private functions. Reminds us that the naming convention of putting an underscore in front of the name of a function or variable indicates it is private instead of public. In solidity,
// public functions can be accessed by any other smart contract. This can potentially open up vulnerabilities in your smart contract. So we're going to declare functions as private most of the time unless there is a good reason. In our
// example, anybody could create a zombie and push it onto our stack from outside our smart contract. So we put the word "private" after the name of our createZombie function and we also rename our function to have the _ in frotn of the 
// function name to indicate that it is private.

// Lesson 1.10, going over Function return values. In solidity, you have to define your return values in the function declaration; e.g. 'function sayHello() public returns (string) { return greeting; }'. Also touches on function modifiers,
// for example in the sayHello(); function, it doesn't modify any values so we can define it as a "view" function by adding the word "view" after "public". An example of a "pure" function is one that doesn't access any data in the dapp.

// Lesson 1.11, going over what a hash function is. Solidity has a version of the SHA3 hash function called keccak256(). Has the little side note that "SECURE random-number generation is a very difficult problem, and that our method is insecure
// but security isn't a top priority for our Zombie DNA." This is worth noting if we are actually trying to create dna for ERC721 non-fungible tokens that have value based on rarity. Also delves into typecasting. We can use 
// typecast functions to turn certain types into others types.

// Lesson 1.12, nothing really new here. Just asking us to create a public function called createRandmoZombie.

// Lesson 1.13, Covers "events" in solidity, which is a way for our contract to communicate that something happened on the blockchain to a dApp front-end, which can be 'listening' for certain events and take action when they happen. Events are declared
// similar to how a data type is declared. E.g. "event IntegersAdded(uint x, uint y, uint result);" Gives an example of an "add" function you might build in solidity which would then call that event, and then in your front-end Javascript, you
// might have a 'listener' which would do something when the event is broadcast. So something like "YourContract.IngegersAdded(function(error,result) { // do something with result }. Also, interesting note that when you use the 
// .push method, it will return a uint of the new length of the array. We are using this return value as our zombieId variable. One thing I don't really like about this lesson is how much heavy lifting is done int hat first line in the _createZombie
// contract. I think it's going to be confusing for novice coders. Assigning the id in the same line the push array operation is a little complicated. But whatevs... I did it the first try, so maybe I'm not giving enough credit to
// solidity students.

// Lesson 1.14, Doesn't have much here... just introduces the student to the Web3.js Ethereum Javascript library that we'll be using for our front end. I'm just copying and pasting the code into another file for my github repo. 

// =================================

// Lesson 2.2 : Going over some solidity types. Addresses are a user type and a mapping seems to be another word for a hash, i.e. a key-value store. The format for making a mapping in solidity is a little odd. "mapping (key type => value type) <public> varName;" 

// Lesson 2.3 : Introduces the msg.sender global variable, which is just the address which called the current function. Also makes an important note that in Solidity, a function execution always needs to start with an external caller. A contract
// will just sit on the blockchain doing nothing until someone calls one of its functions. So there will always be a msg.sender variable which refers to that external calling address.

// Lesson 2.4 : Introduces the require function, which checks to see if a condition is met before proceeding with the rest of the function. Also notes that Solidity doesn't have native string comparisons, so in order to do string comparisons
// we have to convert them into a number using a hashing function like keccak256();. 

// Lesson 2.5 : Inheritence. Turns out that contracts can inherit from other contracts using the "is" operator when naming the contract, e.g. contract BabyDoge is Doge {}. This means that if you name a contract that inherits from another
// contract, it will have access to any of the public functions in the contract it inherits from. 


contract ZombieFactory { //Naming the contract 

	event NewZombie(uint zombieId, string name, uint dna);

	uint dnaDigits = 16;  // Zombie DNA is a 16-digit number
	uint dnaModulus = 10 ** dnaDigits;  // dnaModulus is going to make sure our Zombie DNA is only 16 digits long in Base-10

	struct Zombie {  // Creating the class "Zombie", which in solidity is called a struct
		string name;	// An instance of a Zombie struct will have a name and a dna integer 
		uint dna;
	}

	Zombie[] public zombies;  // Creating a public array, which in this case "public" just means solidity creates a getter for it, not that it can be accessed outside of the contract

	mapping (uint => address) public zombieToOwner;  // Creating mappings to store zombie ownership
	mapping (address => uint) ownerZombieCount;


	function _createZombie(string _name, uint _dna) private {  // Creating a function to create a new zombie, which pushes the instance of the Zombie struct/object into the zombies[] array.
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender; // assigning the msg.sender address to the ID of the zombie just created in the zombieToOwner mapping
        ownerZombieCount[msg.sender]++; // increment the zombie count # for the external caller address in the ownerZombieCount mapping 
        NewZombie(id, _name, _dna);
	}

	function _generateRandomDna(string _str) private view returns (uint) {  // Creating a function to generate the Zombie dna integer.
		uint rand = uint(keccak256(_str));  // Using the keccak256 hash function to generate a 256-bit hexidecimal number, typecast it into an unsigned integer, and assign it to the rand variable
		return rand % dnaModulus;  // shortens our random number to 16-digits by using a modulus operator and returns that value.
	}

	function createRandomZombie(string _name) public {  // Creating a public function which can be called from any contract which generates a zombie and pushes it into our zombies array via the _createZombie function.
		require(ownerZombieCount[msg.sender] == 0);
		uint randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}



}
