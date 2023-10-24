// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Testing Libraries.
import {DSTestFull} from '../DSTestFull.sol';

// External Contracts.
import {ERC20} from '@berachain/EIP5XXX.sol';
import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';
import {Cosmos} from '@polaris/CosmosTypes.sol';

// Infrared Contracts.
import {Infrared} from '@core/Infrared.sol';
import {VLIRED} from '@core/VLIRED.sol';
import {WrappedIBGT} from '@core/WIBGT.sol';
import {InfraredVault} from '@core/InfraredVault.sol';
import {IBGT} from '@core/IBGT.sol';
import {IREDVestingFactory} from '@vesting/IREDVestingFactory.sol';
import {VestingWalletWithCliff} from '@vesting/VestingWalletWithCliff.sol';
import {IInfraredVault} from '@interfaces/IInfraredVault.sol';
import {IERC20Mintable} from '@interfaces/IERC20Mintable.sol';

// Mocked Contracts.
import {MockDistributionModule} from './mocks/MockDistributionModule.sol';
import {MockStakingModule} from './mocks/MockStakingModule.sol';
import {MockERC20Module} from './mocks/MockERC20Module.sol';
import {MockRewardsModule} from './mocks/MockRewardsModule.sol';

contract Helper is DSTestFull {
    // Test Accounts.
    address public constant DEFAULT_ADMIN = address(1);
    address public constant GOVERNANCE = address(2);
    address public constant KEEPER = address(3);
    address public constant ALICE = address(4);
    address public constant BOB = address(5);
    address public constant POOL_ADDRESS = address(6);

    // Some constants.
    string public constant BGT_DENOM = 'abgt';

    // Account Helpers.
    modifier prank(address who) {
        vm.startPrank(who);
        _;
        vm.stopPrank();
    }

    // Reward Tokens.
    ERC20 internal _dai;
    ERC20 internal _usdc;
    IBGT internal _ibgt;

    ERC20 internal _ired;

    // Precompiled Contracts. (Mocked)
    MockStakingModule internal _stakingPrecompile;
    MockDistributionModule internal _distributionPrecompile;
    MockERC20Module internal _erc20Precompile;
    MockRewardsModule internal _rewardsPrecompile;

    // Core contracts.
    Infrared internal _infrared;
    WrappedIBGT internal _wrappedIBGT;
    InfraredVault internal _wibgtVault;
    InfraredVault internal _daiVault;
    VLIRED internal _vliRed;

    // Validators.
    address internal _val0;
    address internal _val1;

    IREDVestingFactory internal _vestingFactory;
    VestingWalletWithCliff internal _treasuryVestingWallet;
    VestingWalletWithCliff internal _teamVestingWallet;
    VestingWalletWithCliff internal _investorVestingWallet;

    function setUp() public {
        _deployTokens();

        _deployMocks();

        _deployInfrared();

        _deployVLIRED();

        _grantRoles();

        _deployWrappedIBGTVault();

        _deployDaiVault();

        _registerValidator();

        _setUpVesting();
    }

    function _setUpVesting() internal {
        _vestingFactory = new IREDVestingFactory(address(1), address(2), address(3));

        address treasuryWalletAddress = _vestingFactory.vestingWallets(address(1));
        _treasuryVestingWallet = VestingWalletWithCliff(payable(treasuryWalletAddress));

        address teamWalletAddress = _vestingFactory.vestingWallets(address(2));
        _teamVestingWallet = VestingWalletWithCliff(payable(teamWalletAddress));

        address investorWalletAddress = _vestingFactory.vestingWallets(address(3));
        _investorVestingWallet = VestingWalletWithCliff(payable(investorWalletAddress));
    }

    function _deployTokens() internal prank(DEFAULT_ADMIN) {
        _dai = ERC20(address(new IBGT()));
        _usdc = ERC20(address(new IBGT()));
        _ibgt = new IBGT();
        _ired = ERC20(address(new IBGT()));
    }

    function _deployMocks() internal {
        _stakingPrecompile = new MockStakingModule();
        _distributionPrecompile = new MockDistributionModule();
        _erc20Precompile = new MockERC20Module();
        _rewardsPrecompile = new MockRewardsModule();
    }

    function _deployVLIRED() internal prank(DEFAULT_ADMIN) {
        _vliRed = new VLIRED(address(_ired));
    }

    function _deployInfrared() internal prank(DEFAULT_ADMIN) {
        _infrared = new Infrared(
            address(_rewardsPrecompile),
            address(_distributionPrecompile),
            address(_erc20Precompile),
            address(_stakingPrecompile),
            BGT_DENOM,
            DEFAULT_ADMIN,
            IERC20Mintable(address(_ibgt))
        );

        // Allow infrared to be a minter of ibgt.

        _ibgt.grantRole(_ibgt.MINTER_ROLE(), address(_infrared));
    }

    function _grantRoles() internal prank(DEFAULT_ADMIN) {
        // Infrared Roles.
        _infrared.grantRole(_infrared.GOVERNANCE_ROLE(), DEFAULT_ADMIN);
        _infrared.grantRole(_infrared.KEEPER_ROLE(), DEFAULT_ADMIN);
        _infrared.grantRole(_infrared.KEEPER_ROLE(), KEEPER);
        _infrared.grantRole(_infrared.GOVERNANCE_ROLE(), GOVERNANCE);

        // Grant the governance role to mint dai.
        IBGT(address(_dai)).grantRole(IBGT(address(_dai)).MINTER_ROLE(), GOVERNANCE);

        // Grant the governance role to mint usdc.
        IBGT(address(_usdc)).grantRole(IBGT(address(_usdc)).MINTER_ROLE(), GOVERNANCE);

        // Grant the admin role to mint ired.
        IBGT(address(_ired)).grantRole(IBGT(address(_ired)).MINTER_ROLE(), DEFAULT_ADMIN);

        // Grant the infrared contract the ability to mint ibgt.
        _ibgt.grantRole(_ibgt.MINTER_ROLE(), address(_infrared));

        // Grant the GOVERNANCE role to mint some IBGT.
        _ibgt.grantRole(_ibgt.MINTER_ROLE(), GOVERNANCE);
    }

    function _deployWrappedIBGTVault() internal prank(DEFAULT_ADMIN) {
        // Deploy the wrapped ibgt token.
        _wrappedIBGT = new WrappedIBGT(IERC20(address(_ibgt)));

        // Setup the rewards.
        address[] memory _rewardTokens = new address[](2);
        _rewardTokens[0] = address(_ibgt); // From block inflation rewards.
        _rewardTokens[1] = address(_dai); // Example from native perps exchange.

        // Set the mocks for this vault.
        _setupWithdrawAddressMocks();

        // Deploy the vault.
        _wibgtVault = new InfraredVault(
            address(_wrappedIBGT),
            'Wrapped IBGT Vault',
            'WIBGTV',
            _rewardTokens,
            address(_infrared),
            POOL_ADDRESS,
            address(_rewardsPrecompile),
            address(_distributionPrecompile),
            DEFAULT_ADMIN
        );

        // Update the vault in the infrared contract.
        _infrared.updateWIBGTVault(IInfraredVault(address(_wibgtVault)), _rewardTokens);

        // Set the vault in the wrapped token.
        _wrappedIBGT.setVault(_wibgtVault);

        // Approve the vault to transfer the WIBGT and vault share tokens.
        _wrappedIBGT.approveVault();
    }

    function _deployDaiVault() internal prank(DEFAULT_ADMIN) {
        address[] memory _rewardTokens = new address[](2);
        _rewardTokens[0] = address(_ibgt);
        // From block inflation rewards and POL.
        _rewardTokens[1] = address(_usdc);
        // Example from native perps exchange.

        // Set the mocks for this vault.
        _setupWithdrawAddressMocks();

        // Register the vault in the infrared contract.
        _daiVault = InfraredVault(
            address(_infrared.registerVault(address(_dai), 'Dai Vault', 'DAIV', _rewardTokens, POOL_ADDRESS))
        );
    }

    function _registerValidator() internal prank(GOVERNANCE) {
        // Register validators.
        address[] memory _validators = new address[](2);
        _val0 = address(2002);
        // Set in state.
        _val1 = address(2003);
        // Set in state.
        _validators[0] = _val0;
        _validators[1] = _val1;
        _infrared.addValidators(_validators);
    }

    /*//////////////////////////////////////////////////////////////
                            Mocks
  //////////////////////////////////////////////////////////////*/

    function _setupWithdrawAddressMocks() internal {
        vm.mockCall(
            address(_distributionPrecompile),
            abi.encodeWithSelector(_distributionPrecompile.setWithdrawAddress.selector, address(_infrared)),
            abi.encode(true)
        );

        vm.mockCall(
            address(_rewardsPrecompile),
            abi.encodeWithSelector(_rewardsPrecompile.setDepositorWithdrawAddress.selector, address(_infrared)),
            abi.encode(true)
        );
    }

    function _mockDistributionModuleWithdraw(address _validator, Cosmos.Coin[] memory _rewards) internal {
        vm.mockCall(
            address(_distributionPrecompile),
            abi.encodeWithSelector(
                _distributionPrecompile.withdrawDelegatorReward.selector,
                address(_infrared),
                address(_validator)
            ),
            abi.encode(_rewards)
        );
    }

    function _mockRewardsPrecompileWithdraw(
        address _vaultAddress,
        address _poolAddress,
        Cosmos.Coin[] memory _coins
    ) internal {
        vm.mockCall(
            address(_rewardsPrecompile),
            abi.encodeWithSelector(_rewardsPrecompile.withdrawDepositorRewards.selector, _vaultAddress, _poolAddress),
            abi.encode(_coins)
        );
    }

    function _mockERC20ModuleMapping(string memory _denom, address _token) internal {
        vm.mockCall(
            address(_erc20Precompile),
            abi.encodeWithSelector(_erc20Precompile.erc20AddressForCoinDenom.selector, _denom),
            abi.encode(_token)
        );
    }

    function _mockDelegate(address _validator, uint256 _amount, bool _succeed) internal {
        vm.mockCall(
            address(_stakingPrecompile),
            abi.encodeWithSelector(_stakingPrecompile.delegate.selector, _validator, _amount),
            abi.encode(_succeed)
        );
    }

    function _mockUndelegate(address _validator, uint256 _amount, bool _succeed) internal {
        vm.mockCall(
            address(_stakingPrecompile),
            abi.encodeWithSelector(_stakingPrecompile.undelegate.selector, _validator, _amount),
            abi.encode(_succeed)
        );
    }

    function _mockBeginRedelegations(
        address _validator,
        address _newValidator,
        uint256 _amount,
        bool _succeed
    ) internal {
        vm.mockCall(
            address(_stakingPrecompile),
            abi.encodeWithSelector(_stakingPrecompile.beginRedelegate.selector, _validator, _newValidator, _amount),
            abi.encode(_succeed)
        );
    }

    function _mockCancelUnbondingDelegation(
        address _validator,
        uint256 _amount,
        int64 _creationHeight,
        bool _succeed
    ) internal {
        vm.mockCall(
            address(_stakingPrecompile),
            abi.encodeWithSelector(
                _stakingPrecompile.cancelUnbondingDelegation.selector,
                _validator,
                _amount,
                _creationHeight
            ),
            abi.encode(_succeed)
        );
    }
}
