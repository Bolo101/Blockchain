pragma solidity 0.8.7;

contract OrderTracker{

    uint counter=1;// manual counter to access mapping data
    enum etape{order_preparation, sending, delivered}//set the state of the order
    struct order{// order related informations
        string product;
        uint quantity;
        address recipient;
        OrderTracker.etape _etape;
        uint orderNumber;
    }
    mapping(uint => order) Order;

    function submitOrder(string memory _product,uint _quantity,address _recipient) public{
        order memory template = order(_product,_quantity,_recipient,etape.order_preparation,counter);//order's informations are filled with the arguments given
        Order[counter] = template;//order is assigned to a specific inex in the mapping
        counter++;//increment for next order index

    }

    function getStatus(uint _id) public view returns(OrderTracker.etape){
        return Order[_id]._etape;//return status of an order depending of the given order umber
    }

    function updateOrderSending(uint _orderId) public{
        Order[_orderId]._etape = etape.sending;//change order status to "sending"
        
    }
    function updateOrderDelivered(uint _orderId) public{
        Order[_orderId]._etape = etape.delivered;//change order status to final state "delivered"
    }

}