pragma solidity ^0.4.0;

contract SemiAutonomousContracts0 {
    uint cId = 0;
    struct Order {
        uint id;
        address owner;
        address contractToExecute;
        uint totalAmount;
        uint costPerBlock;
        uint[] executionCheckpoints;
        mapping(uint=>bool) executedAt;
    }
    mapping(uint=>bool) mapnil;
    uint[] uintarrnil;
    
    Order[] orders;
    
    function findOrderById(uint id) private constant returns (Order storage) {
        for(uint i = 0; i < orders.length; i++) {
            if (orders[i].id == id) {
                return orders[i];
            } else {
                revert();
            }
        }
    }
    
    function addNewOrder(address contractToExecute, uint costPerBlock) payable {
        require(
            msg.value != 0 &&
            costPerBlock <= msg.value &&
            costPerBlock > 0
        );
        orders.push(Order(cId, msg.sender, contractToExecute, msg.value, costPerBlock, uintarrnil));
        cId++;
    }
    function executeContract(uint orderId) {
        Order storage ord = findOrderById(orderId);
        require(
            ord.totalAmount > ord.costPerBlock &&
            ord.executedAt[block.timestamp] == false
        );
        AutonomousContractI c = AutonomousContractI(ord.contractToExecute);
        
        ord.totalAmount -= ord.costPerBlock;
        ord.executionCheckpoints.push(block.timestamp);
        ord.executedAt[block.timestamp] = true;
        c.execute();
        msg.sender.transfer(ord.costPerBlock);
    }
}

contract AutonomousContractI {
    // it doesn't take any arguments and doesn't return values because
    // the idea is that Autonomous Smart Contracts will have some
    // initialy predifiend state on deployment phase in constructor
    // and the next state will be a pure function of the current one.
    function execute();
}
