# Fund-me-Brownie
Smart contract that lets anyone deposit ETH. Only the owner of the contract can withdraw the ETH. Python scripts to deploy the contract, fund the contract and withdraw the money. Python tests to test the contract.

## FundMe.sol
A smart contract to:
- Fund the contract
- Add an EntranceFee
- Withdraw the money if you are the owner
- Convert sent money to USD
- Get ETH current price

## MockV3Aggregator.sol
- Deploy mocks

## Deploy.py
A python script to: 
- Connect to a Blockchain `(Testnet, Mainnet)`
- Get an account safely
  - From a local or a forked local blockchain environment
  - A real one via the config & .env file
- Pass the price feed address to our contract
  - A real one if we are on a real network
  - A mock one if we are on a local blockchain environment
- Deploy our contract

## Essential_Scripts.py
- Get an account safely
  - From a local or a forked local blockchain environment
  - A real one via the config & .env file
- Deploy mocks

## Fund_And_Withdraw.py
- Fund our contract
- Withdraw the money from the contract

## Test_Fund_Me.py
-  Test if we can fund and withdraw money
-  Test if only the owner can withdraw money

## Help with the project
To run the code there are some requirements. You must install: 

### pipx 
Install _pipx_ by running the following on the command line: `python -m pip install --user pipx` then `python3 -m pipx ensurepath`

For more information check: <a href="https://pypa.github.io/pipx/">Install pipx</a>

### Brownie
Install _Brownie_ by running the following on the command line: `pip install eth-brownie`

For more information check: <a href="https://pypi.org/project/eth-brownie/">Install Brownie</a>

This is the Lesson 6 of the <a href="https://www.youtube.com/c/Freecodecamp">freeCodeCamp.org</a> tutorial: https://www.youtube.com/watch?v=M576WGiDBdQ with more comments.
