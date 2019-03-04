pragma solidity ^0.4.16;

contract ABACSC {
    bool public status;
    address public owner;
	uint public numberOfUsers;
    mapping (address => uint) public userId;
    User[] public users;

    event UserAdd(address UserAddress, string UserAttributes, string UserNotes, string UserDigest);
    event UserRemoved(address UserAddress);
    event StatusChanged(string Status);

    struct User {
        address user;
        string attributes;
        string notes;
	string digest;
        uint userSince;
    }

    modifier onlyUsers {
        require(userId[msg.sender] != 0);
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor (string enterOrganizationName) public {
        owner = msg.sender;
        status = true;
        addUser(0, "", "","");
        addUser(owner, 'Creator and Owner of Smart Contract', "","");
        numberOfUsers = 0;
    }

    function changeStatus (bool deactivate) onlyOwner public {
        if (deactivate)
        {status = false;}
        emit StatusChanged("Smart Contract Deactivated");
    }

    function addUser(address userAddress, string userAttributes, string userNotes, string userDigest) onlyOwner public {
        require(status = true);
        uint id = userId[userAddress];
        if (id == 0) {
            userId[userAddress] = users.length;
            id = users.length++;
        }
        users[id] = User({user: userAddress, userSince: now, attributes:userAttributes, notes: userNotes, digest: userDigest});
        emit UserAdd(userAddress, userAttributes, userNotes, userDigest);
        numberOfUsers++;
    }

    function removeUser(address userAddress) onlyOwner public {
        require(userId[userAddress] != 0);
        for (uint i = userId[userAddress]; i<users.length-1; i++){
            users[i] = users[i+1];
        }
        delete users[users.length-1];
		userId[userAddress] = 0;
        users.length--;
        emit UserRemoved(userAddress);
        numberOfUsers--;
    }

 
}
