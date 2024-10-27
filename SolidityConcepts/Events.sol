pragma solidity 0.8.7;
/*
Events are used to return data to the exterior such as a front-end instance
Check transaction information => logs section to read the output data
*/
contract Events{
    uint[] numbers;
    event stiout(address _from, uint _content);//declare required data

    function addNumber(uint _number) external{
        numbers.push(_number);
        emit stiout(msg.sender, _number);//set event
    }
}