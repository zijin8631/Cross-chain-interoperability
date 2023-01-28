// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <=0.8.17;

contract MyContract{
    receive() external payable {}
    fallback() external payable {}
    uint public price;
    address public owner;
    constructor(){
        price = 0;
        owner = msg.sender;
    }
    //Function Modifier
    modifier onlyowner(){
        require(msg.sender == owner);
        _;
    }

    //The doctor and other kinds of managers of the system
    struct user{
        string username;
        string password;
        bool is_Register;
    }
    mapping(address => user) public users;
    string public username;
    string public password;
    bool is_valid; //To verify the users

    //Deploy the users/doctors/managers
    function register(string memory usr, string memory pwd) external{
        require(users[msg.sender].is_Register == false, "The username has already existed!");
        users[msg.sender].username = usr;
        users[msg.sender].password = pwd;
        users[msg.sender].is_Register = true;
    }

    function login(string memory usr, string memory pwd) public payable returns(bool){
        require(users[msg.sender].is_Register == true, "No such account, please register first!");

        //Get the real user info
        address addr = msg.sender;
        string memory cur_username = users[addr].username;
        string memory cur_password = users[addr].password;
        //Hash the usr,pwd and user info
        bytes32 usr1Hash = keccak256(abi.encode(cur_username));
        bytes32 usr2Hash = keccak256(abi.encode(usr));
        bytes32 pwd1Hash = keccak256(abi.encode(cur_password));
        bytes32 pwd2Hash = keccak256(abi.encode(pwd));      
        //Verify whether the inputs and userinfo is right.
        if (usr1Hash == usr2Hash && pwd1Hash == pwd2Hash)
        {
            is_valid = true;
        }
        else 
        {
            is_valid = false;
        }

        return is_valid;
    } 

////////////////////////////////////////////////////////////////////

    struct patient{
        string id;//Patient's ID
        string name;//Patient's name
        string description;//The health info
        address createdby;//The doctor responsible for the patient
        bool is_Used;//Whether the patient has been uploaded.
    }
    mapping(string => patient) public patients;
    //Add a new patient, must upload the patient's info, the patient is created by the msg.sender.
    function Addnewpatient(string memory input_id, string memory ne, string memory dp) public payable returns(bool){
        require(users[msg.sender].is_Register == true, "No such account, please register first!");
        require(is_valid == true, "Please login!");
        require(patients[input_id].is_Used == false, "Patient already exists!");

        patients[input_id].id = input_id;
        patients[input_id].name = ne;
        patients[input_id].description = dp;
        patients[input_id].createdby = msg.sender;
        patients[input_id].is_Used = true;

        return patients[input_id].is_Used;
    }
    //Input the ID to delete the patient.
    function Deletepatient(string memory input_id) public payable returns(bool){
        require(users[msg.sender].is_Register == true, "No such account, please register first!");
        require(is_valid == true, "Please login!");
        require(patients[input_id].is_Used == true, "Patient doesn't exist!");
        require(patients[input_id].createdby == msg.sender, "The patient is not under your management, so the information cannot be modified!");

        delete patients[input_id]; 
        bool is_finished = true;

        return is_finished;
    }
    //Input the id to select the patient info you want to update, just can update the description and createdby.
    function Updatepatient(string memory input_id, string memory dp, address newowner) public payable returns(bool){
        require(users[msg.sender].is_Register == true, "No such account, please register first!");
        require(is_valid == true, "Please login!");
        require(patients[input_id].is_Used == true, "Patient doesn't exist!");
        require(patients[input_id].createdby == msg.sender, "The patient is not under your management, so the information cannot be modified!");

        patients[input_id].description = dp;
        patients[input_id].createdby = newowner;
        patients[input_id].is_Used = true;

        return patients[input_id].is_Used;
    }
    //Input the id to search the info of this patient.
    function Searchpatient(string memory input_id) public payable returns(patient memory){
        require(users[msg.sender].is_Register == true, "No such account, please register first!");
        require(is_valid == true, "Please login!");
        require(patients[input_id].is_Used == true, "Patient doesn't exist!");
        require(patients[input_id].createdby == msg.sender, "The patient is not under your management, so the information cannot be modified!");

        patient memory cur_patient = patients[input_id];
        return cur_patient;
    }
}