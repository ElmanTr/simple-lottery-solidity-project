pragma solidity >=0.6.0<0.7.1;

contract Lotterry{
    struct Ticket{
        uint256 id;
        uint256 createDateTime;
        address payable member;
        bool win;
    }

    address payable public owner;
    mapping(uint256=>Ticket) public tickets;
    uint256 ticketPrice=100 trx;
    uint256 ticketCode=0;
    uint256 invested=0;
    uint256 public startDate;
    uint16 public day;
    bool is_done;

    event BuyTicket(address indexed addr, uint256 amount, uint256 ticketCode);

    event Winner(address indexed addr, uint256 amount, uint256 ticketCode);

    constructor(uint16 _day) public{
        day=_day;
        owner=msg.sender;
        startDate=block.timestamp;
    }

    function buyTicket() public payable returns(uint256){
        require(msg.value==ticketPrice);
        require(block.timestamp<startDate+(day*84600));
        owner.transfer(msg.value/10);
        ticketCode++;
        invested+=(msg.value*90)/100;
        tickets[ticketCode]=Ticket(ticketCode,block.timestamp,msg.sender,false);
        emit BuyTicket(msg.sender,msg.value,ticketCode);
        return ticketCode;
    }

    function startLottery() public{
        require(msg.sender==owner);
        require(block.timestamp>startDate+(day*84600));
        require(is_done==false);
        uint256 winnerIndex=random(ticketCode);
        tickets[winnerIndex].win=true;
        tickets[winnerIndex].member.transfer(invested);
        is_done=true;
        emit Winner(tickets[winnerIndex].member,invested,winnerIndex);
    }

    function random(uint count) private view returns(uint){
        uint rand=uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty)))%count;
        return rand;
    }
}
