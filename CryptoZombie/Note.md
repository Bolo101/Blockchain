When using an external contract do not only create an interface and hard forcing its address. If the address changes you will lose the use of your contract. Instead create a function taking a variable parameter and being external.
Allocate the address to the interface you previously declared without initializing it.
