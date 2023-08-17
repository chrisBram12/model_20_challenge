pragma solidity ^0.5.0;

contract JointSavings {

    address payable public accountOne;
    address payable public accountTwo;

    address public lastToWithdraw;
    uint public lastWithdrawAmount;
    uint public contractBalance;

    function withdraw(uint amount, address payable recipient) public {
        // Check if recipient is one of the joint account holders
        require(
            recipient == accountOne || recipient == accountTwo,
            "You don't own this account!"
        );
        
        // Check if there are sufficient funds
        require(
            address(this).balance >= amount,
            "Insufficient funds!"
        );
        
        // Check and update the last person to withdraw
        if (lastToWithdraw != recipient) {
            lastToWithdraw = recipient;
        }
        
        // Transfer funds
        recipient.transfer(amount);

        // Update withdrawal amount and contract balance
        lastWithdrawAmount = amount;
        contractBalance = address(this).balance;
    }

    function deposit() public payable {
        // Update contract balance
        contractBalance = address(this).balance;
    }

    function setAccounts(address payable account1, address payable account2) public {
        accountOne = account1;
        accountTwo = account2;
    }

    // Adjusted fallback function
    function() external payable {
        // Update the contract balance when receiving ether directly
        contractBalance = address(this).balance;
    }
}
