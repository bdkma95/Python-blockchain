// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Crowdfunding {
    
    address public Manager;
    uint256 totalFunds; //total funds funded in contract
    uint256 start; //to set current time
    uint256 end; //to set duration
    uint256 public counter; //to create project ids
    

    struct Project {
        uint256 id;
        address payable owner;
        string projectName;
        string description;
        uint256 expectedCost;
        uint256 isRegistered;
        uint256 isVerified;
        uint256 fundedamt;
        uint256 fundwithdraw;
    }
        
    constructor(uint256 _duration) {
        Manager = msg.sender;
        start = block.timestamp;
        end = (_duration * 1 days) + start;
    }
    
    mapping(address => uint256)public ProjectId;
    mapping(uint256 => Project) public Projects;
    mapping(uint256 => uint256) public ProjectFunds;
    
    event ProjectRegistered(uint256 _id,uint256 _rtime,string _name,address _owner);
    event ProjectIsVerified(uint256 _pid,uint256 _time);
    event FundsTransferred(uint256 _pid,uint256 _time,address _from,uint256 _fund);
    event FundsWithdrawn(uint256 _pid,uint256 _time,address _to,uint256 _fund);
    
    modifier onlyManager() {
        require(msg.sender==Manager,"You are not Manager");
        _;
    }
    
    function regProject(string memory _pname,string memory _desc,uint256 _cost) public {
        require(block.timestamp < end, "Duration is over");
        require(msg.sender != Manager && ProjectId[msg.sender]== 0,"Manager and existing owners of projects not able to register again");
        counter++;
        Project memory pro = Project(counter,payable (msg.sender),_pname,_desc,_cost,1,0,0,0);
        ProjectId[msg.sender] = counter;
        Projects[counter]  = pro;
        emit ProjectRegistered(counter, block.timestamp, _pname, msg.sender);
    }
    
    function verifyProject(uint256 _id) public onlyManager() {
        Projects[_id].isVerified = 1;
        emit ProjectIsVerified(_id,block.timestamp);
    }
    
    function viewProject(uint256 _id) public view returns(uint256,address,string memory,string memory,uint256,uint256,uint256) {
        require(Projects[_id].isVerified == 1,"Project is not verified");
        return (
        Projects[_id].id,
        Projects[_id].owner,
        Projects[_id].projectName,
        Projects[_id].description,
        Projects[_id].expectedCost,
        Projects[_id].isRegistered,
        Projects[_id].fundedamt
        );
    }
    
    function timeLeft() public view returns(uint256) {
        require(block.timestamp <= end, "The funding duration is over");
        return end - block.timestamp;
    }
    
    function sendFunds(uint256 _id) payable public {
        require(block.timestamp < end, "The funding duration is over");
        require(Projects[_id].isVerified == 1 && msg.sender != Projects[_id].owner && Projects[_id].fundwithdraw == 0,"you are owner or project is unverified");
        Projects[_id].fundedamt += msg.value;
        totalFunds++;
        ProjectFunds[_id] = msg.value;
        emit FundsTransferred(_id,block.timestamp,msg.sender,msg.value);
    }
    
    function contractBal() public view returns(uint256) {
        return address(this).balance;
    }
    
    function withdrawFunds(uint256 _id) public payable {
        require(block.timestamp > end, "The funding duration is not over yet");
        require(msg.sender == Projects[_id].owner,"You are not owner of this project");
        address payable add = Projects[_id].owner;
        Projects[_id].fundedamt-=ProjectFunds[_id];
        add.transfer(ProjectFunds[_id]);
        Projects[_id].fundwithdraw +=ProjectFunds[_id];
        emit FundsWithdrawn(_id,block.timestamp,add,ProjectFunds[_id]);
    }
}
