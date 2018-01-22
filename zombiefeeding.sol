// Lesson 2.6 : Introduces the import keyword, which allows you to import one file into another. We split the contracts up, and at this point the original CryptoZombies.sol file is obsoleted.

// Lesson 2.7 : Introduces the "storage" and "memory" keywords. Usually won't have to use them. State variables (those variables declared outside of functions) are by default storage and written
// permanently on the blockchain, while variables inside functions are memory and will disappear when the function call ends. Sometimes we have to use these keywords when dealing with structs and arrays
// within functions.


pragma solidity ^0.4.19;  // Declaring the version of solidity we are using

import "./zombiefactory.sol";  // Imports the zombiefactory contract

contract ZombieFeeding is ZombieFactory {

	function feedAndMultiply(uint _zombieId, uint _targetDna) public {
		require(msg.sender == zombieToOwner[_zombieId]);
		Zombie storage myZombie = zombies[_zombieId];
	}


}