//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;

// We import this library to be able to use console.log
import "hardhat/console.sol";
import "@opengsn/contracts/src/BaseRelayRecipient.sol";


// This is the main building block for smart contracts.
contract Token is BaseRelayRecipient{
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    uint256 public counter = 0;
    // A mapping is a key/value map. Here we store each account balance.
    mapping(address => uint256) balances;

    address[] userAddress;
    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     * The `public` modifier makes a function callable from outside the contract.
     */
    constructor() public {
        address mtrustedForwarder = 0xF82986F574803dfFd9609BE8b9c7B92f63a1410E;
        _setTrustedForwarder(mtrustedForwarder);
        // The totalSupply is assigned to transaction sender, which is the account
        // that is deploying the contract.
        balances[_msgSender()] = totalSupply;
        owner = _msgSender();
    }

    function incrementCounter() external {
        userAddress.push(_msgSender());
        counter = counter + 1;
    }

    function versionRecipient() external view override returns (string memory) {
        return "1";
    }
    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from outside
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[_msgSender()] >= amount, "Not enough tokens");

        // We can print messages and values using console.log
        console.log(
            "Transferring from %s to %s %s tokens",
            _msgSender(),
            to,
            amount
        );

        // Transfer the amount.
        balances[_msgSender()] -= amount;
        balances[to] += amount;
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
