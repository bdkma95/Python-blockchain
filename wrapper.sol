pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol";

contract IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Wrapper {
    IERC20 public dogcoin;
    address public owner1;
    IERC20 public catcoin;
    address public owner2;
    IERC20 public birdcoin;
    address public owner3;
}
    constructor(
        address _dogcoin,
        address _owner1,
        address _catcoin,
        address _owner2,
        address _birdcoin,
        address _owner3,
    ) public {
        dogcoin = IERC20(_dogcoin);
        owner1 = _owner1;
        catcoin = IERC20(_catcoin);
        owner2 = _owner2;
        birdcoin = IERC20(_birdcoin);
        owner3 = _owner3;
    }
    /**
     * Convert an amount of input token_ to an equivalent amount of the output token
     *
     * @param token_ address of token to swap
     * @param amount amount of token to swap/receive
     */
    function swap(address token_, uint _amount1, uint _amount2, uint _amount3) public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            dogcoin.allowance(owner1, address(this)) >= _amount1,
            "Dogcoin allowance is too low"
        );
        require(
            catcoin.allowance(owner2, address(this)) >= _amount2,
            "Catcoin allowance is too low"
        );
        require(
            birdcoin.allowance(owner3, address(this)) >= _amount3,
            "Birdcoin allowance is too low"
        );
    }
    /**
     * Convert an amount of the output token to an equivalent amount of input token_
     *
     * @param token_ address of token to receive
     * @param amount amount of token to swap/receive
     */
    function unswap(address token_, uint _amount1, uint _amount2, uint _amount3) public {
        require(msg.sender == owner1 || msg.sender == owner2, || msg.sender == owner3, "Not authorized");
        require(
            dogcoin.allowance(owner1, address(this)) >= _amount1,
            "Dogcoin allowance is too low"
        );
        require(
            catcoin.allowance(owner2, address(this)) >= _amount2,
            "Catcoin allowance is too low"
        );
        require(
            birdcoin.allowance(owner3, address(this)) >= _amount3,
            "Birdcoin allowance is too low"
        );
        
        // transfer tokens
        // dogcoin, owner1, amount1 -> owner2
        _safeTransferFrom(dogcoin, owner1, owner2, _amount1);
        // catcoin, owner2, amount2 -> owner1
        _safeTransferFrom(catcoin, owner2, owner1, _amount2),
        // birdcoin, owner3, amount3, -> owner 1, owner2
        _safeTransferFrom(birdcoin, owner3, owner1, owner2, _amount3);
    }
    
    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
    
    function mintToken(address target, uint256 mintedAmount) onlyOwner {
       balanceOf[target] += mintedAmount;
       totalSupply += mintedAmount;
    }
}
