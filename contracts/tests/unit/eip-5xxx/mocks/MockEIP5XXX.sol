// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.22;

/* Test Environment */
import "../utils/TestEnv.sol";
import "@berachain/vaults/EIP5XXX.sol";
import "../mocks/MockERC20.sol";

contract MockEIP5XXX is EIP5XXX {
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens
    ) ERC4626(_asset, _name, _symbol) {
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            _createNewRewardContainer(_rewardTokens[i], 0);
        }
    }

    /*//////////////////////////////////////////////////////////////
                               MOCK LOGIC
    //////////////////////////////////////////////////////////////*/

    function mint(address to, uint256 value) public {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public {
        _burn(from, value);
    }

    function currentEPW(address reward)
        public
        view
        returns (uint256, uint256)
    {
        return _currentEPW(
            keyToRewardsContainer[bytes32(abi.encodePacked(uint96(0), reward))]
        );
    }

    /*//////////////////////////////////////////////////////////////
                              VIRTUAL LOGIC
    //////////////////////////////////////////////////////////////*/

    function rewardKeysOf(address)
        public
        view
        virtual
        override
        returns (bytes32[] memory)
    {
        return rewardKeys;
    }

    function weightOf(address owner, uint96)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return balanceOf[owner];
    }

    function totalWeight(uint96 partition)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return totalSupply;
    }

    function totalAssets() public view virtual override returns (uint256) {
        return asset.balanceOf(address(this));
    }
}
