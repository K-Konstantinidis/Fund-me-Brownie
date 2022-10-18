// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;
//AggregatorV3Interface.sol to get a price feed for ETH => USD
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
//Check & avoid overflow (a uint256 to not have a number with more than 256 bits)
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256; //Avoid overflow for all uint256

    mapping(address => uint256) public addressToAmount;
    address[] public funders; //Add the address of a funder in an array
    address owner; //Address of the owner of the contract
    AggregatorV3Interface public priceFeed;

    constructor(address price_Feed) public {
        priceFeed = AggregatorV3Interface(price_Feed);
        owner = msg.sender; //The deployer of the contract will be the owner.
    }

    // payable: Function to pay for things
    // Function to send money
    function fund() public payable {
        //Set a minimum value to send
        uint256 minUSD = 50 * 10**18; //50$ * 10^18 to get the value in wei
        // If the sended value is less than the minUSD stop excecution.
        // 'require' reverts the transaction & gives back the money & the unspended gas to the sender
        require(getConversion(msg.value) >= minUSD, "You must spend more ETH!");
        addressToAmount[msg.sender] += msg.value; //Add value to sender address
        funders.push(msg.sender); //Add sender to array
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    // Get ETH price
    function getPrice() public view returns (uint256) {
        //This is a tuple (A list with objects of different type)
        //',' means something will be returned there but ignore it
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        //The 'answer' is returned in gwei(8 decimals). We want
        //wei: 18 decimals so we have to do (answer * (10^10))
        return uint256(answer * (10 ^ 10));
    }

    //Convert whatever value they send e.g. 15gwei to USD
    function getConversion(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = ((ethPrice * ethAmount) / (10**18)); //Have to divide with 10^18 -> 1 ETH in WEI
        //The answer is also in 18 decimals even though we divided with 10^18
        //So if we get something with <18 numbers we add 0 at the front
        //E.G. answer = 2533896352720. So the real answer is 0.000002533896352720. This is 1 GWEI in USD
        //If we multiply this with 10^10 we get ETH -> USD. ETH was 2,533.896352720 at the time of this program
        return ethAmountInUSD;
    }

    function getEntranceFee() public view returns (uint256) {
        // min USD
        uint256 minUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return ((minUSD * precision) / price) + 1;
    }

    //Modifier so that only the owner of the contract can withdraw money
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //After finding the '_', leave the modifier & run the rest of the code
    }

    //Withdraw all the money this contract holds from funding
    //Add the modifier to be checked
    function withdraw() public payable onlyOwner {
        //transfer(): Send ETH from 1 address to another.
        //e.g. Send to msg.sender
        //Inside the () we choose how much money will be transferred
        //e.g. All the money that've been funded
        //this: Refers to the contract we are currently in
        //address(this): The address of the contract we are currently in
        //e.g. give all the balance(money) of this contract address to the msg.sender
        msg.sender.transfer(address(this).balance);
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmount[funder] = 0; //Empty the balance of each address
        }
        funders = new address[](0); //Reset our funder array
    }
}
