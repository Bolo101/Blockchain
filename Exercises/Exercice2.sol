//students management system with owner privilege
pragma solidity 0.8.7;
contract Exercice2{
    
    address owner;

    struct Grade{
        string subject;
        uint grades;
    }
    struct Student{
        string firstName;
        string lastName;
        uint numberOfGrades;
        mapping(uint => Grade) Grades;
    }
    mapping(address => Student) Students;

    constructor(){
        owner = msg.sender;
    }

    function addStudent(address _student, string memory _firstName, string memory _lastName) public {
        require(owner ==msg.sender,"Not the owner");
        bytes memory firstNameAddress = bytes(Students[_student].firstName); //check if student exist, use bytes to use less gas
        require(firstNameAddress.length == 0, "Student already exists");//if  the student already exist the field will for the refered address will be filled. Otherwise it returns that the student exists
        Students[_student].firstName = _firstName;
        Students[_student].lastName = _lastName;
    }
    function addGrade(address _student,uint _grade,string memory _subject) public{
        require(owner ==msg.sender,"Not the owner");
        bytes memory firstNameAddress = bytes(Students[_student].firstName);
        require(firstNameAddress.length > 0, "Student does not exists");
        Students[_student].Grades[Students[_student].numberOfGrades].grades = _grade;
        Students[_student].Grades[Students[_student].numberOfGrades].subject = _subject;
        Students[_student].numberOfGrades ++;
    }
    function getGrades(address _student) public view returns(uint[] memory){
        require(msg.sender==owner, "Not the owner");
        uint numberOfGradesForTheStudent = Students[_student].numberOfGrades;
        uint[] memory results = new uint[](numberOfGradesForTheStudent);
        for(uint i = 0 ; i < numberOfGradesForTheStudent; i++){
            results[i] = Students[_student].Grades[i].grades;
        }
        return results;
    }
}