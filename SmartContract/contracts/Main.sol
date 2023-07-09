//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "./Session.sol";
import "./SessionDetail.sol";

contract Main {
    struct IParticipant {
        address account;
        string fullName;
        string email;
        uint256 numberOfJoinedSession;
        uint256 deviation;
    }

    event RegisterSuccess(address account, string fullName, string email);
    event UpdateUser(
        address account,
        string fullName_old,
        string email_old,
        string fullName_new,
        string email_new
    );
    event CreateSession(address sessionAddress);

    address public admin;
    address[] public addressParticipant;
    mapping(address => IParticipant) public participants;

    address[] public addressSessions;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Main: not is admin");
        _;
    }
    modifier onlySession() {
        bool check = false;
        for (uint i = 0; i < addressSessions.length; i++) {
            if (addressSessions[i] == msg.sender) {
                check = true;
            }
        }
        require(check == true, "Main: Only session contract");
        _;
    }

    function register(string memory _fullName, string memory _email) public {
        require(
            participants[msg.sender].account == address(0x0),
            "Main: user registered"
        );

        IParticipant memory newIParticipant = IParticipant({
            account: msg.sender,
            fullName: _fullName,
            email: _email,
            numberOfJoinedSession: 0,
            deviation: 0
        });
        participants[msg.sender] = newIParticipant;
        addressParticipant.push(msg.sender);

        emit RegisterSuccess(msg.sender, _fullName, _email);
    }

    function createNewSession(
        string memory _productName,
        string memory _productDescription,
        string[] memory _productImage
    ) external onlyAdmin {
        Session newSession = new Session(
            _productName,
            _productDescription,
            _productImage,
            address(this),
            msg.sender
        );
        addressSessions.push(address(newSession));
        emit CreateSession(address(newSession));
    }

    function updateInfomationByUser(
        string memory _fullName,
        string memory _email
    ) public {
        require(
            participants[msg.sender].account == msg.sender,
            "Main: unregisted user or wrong account"
        );
        string memory _nameOld = participants[msg.sender].fullName;
        string memory _emailOld = participants[msg.sender].email;
        participants[msg.sender].fullName = _fullName;
        participants[msg.sender].email = _email;
        emit UpdateUser(msg.sender, _nameOld, _emailOld, _fullName, _email);
    }

    function updateInfomationByAdmin(
        address _account,
        string memory _fullName,
        string memory _email,
        uint _numberOfJoinedSession,
        uint _deviation
    ) public onlySession {
        require(
            participants[_account].account == _account,
            "Main: unregisted user or wrong account"
        );
        participants[_account].fullName = _fullName;
        participants[_account].email = _email;
        participants[_account].numberOfJoinedSession = _numberOfJoinedSession;
        participants[_account].deviation = _deviation;
    }

    function getParticipantAccount(
        address _address
    ) external view returns (address) {
        return participants[_address].account;
    }

    function getDeviationParticipant(
        address _account
    ) external view returns (uint) {
        return participants[_account].deviation;
    }

    function getNumberOfJoinedSession(
        address _account
    ) external view returns (uint) {
        return participants[_account].numberOfJoinedSession;
    }

    function updateDeviationForParticipant(
        address _account,
        uint _deviation,
        uint _numberOfJoinedSession
    ) external onlySession {
        participants[_account].deviation = _deviation;
        participants[_account].numberOfJoinedSession = _numberOfJoinedSession;
    }

    function getInforParticipants()
        external
        view
        onlyAdmin
        returns (IParticipant[] memory)
    {
        IParticipant[] memory _paticipants = new IParticipant[](
            addressParticipant.length
        );

        for (uint i = 0; i < addressParticipant.length; i++) {
            IParticipant memory newPaticipant = participants[
                addressParticipant[i]
            ];
            _paticipants[i] = newPaticipant;
        }
        return _paticipants;
    }

    function getAddressSession() public view returns (address[] memory) {
        return addressSessions;
    }
}
