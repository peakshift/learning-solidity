pragma solidity "0.4.21";

contract SimpleToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balances;
    mapping (address => uint256) public deposits;
    address owner;
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function SimpleToken(
        uint256 initialSupply
        ) public {
        balances[this] = initialSupply;              // Give the creator all initial tokens
        owner = msg.sender;
    }

    function transferContractOwnership(address _to) public {
        require(msg.sender == owner);
        owner = _to;
    }
    
    function get(address _to, uint256 _value) public payable {
        require(balances[this] >= _value);
        /*
            @TODO implement some calculation for distrubting
            tokens relative to the sent eth amount
        
            initialSupply   // total amount of tokens
            balances[this]  // contracts current token balance
            msg.value       // sent amount in wei 
        */
        balances[this] -= _value;
        balances[_to] += _value;
    }
    
    function buyOneForOne() public payable {
        require(balances[this] >= msg.value);
        balances[this] -= msg.value;
        balances[msg.sender] += msg.value;
    }
    
    function deposit() public payable {
        deposits[msg.sender] = msg.value;
    }
    
    function ethBalance() public view returns (uint) {
        return this.balance;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(balances[msg.sender] >= _value);           // Check if the sender has enough
        require(balances[_to] + _value >= balances[_to]);  // Check for overflows
        balances[msg.sender] -= _value;                    // Subtract from the sender
        balances[_to] += _value;                           // Add the same to the recipient
    }

    function kill() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }

}

