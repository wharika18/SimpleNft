//SPDX License Identifier:MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeploySimpleNft} from "../../script/DeploySimpleNft.s.sol";
import {SimpleNft} from "../../src/SimpleNft.sol";

contract NftTest is Test {
    DeploySimpleNft public deployer;
    SimpleNft public simpleNft;
    // here one link is to the json file, which i ajave created using the vsc, new file with json extn and later importing that too the ipfs and later press sgare to obtain the link
    string public constant BIRD =
        "https://ipfs.io/ipfs/QmZ2UQkSnFawckKrZxAAhVWioYXtyYJrS2bSfRAwqwy74S?filename=QmZ2UQkSnFawckKrZxAAhVWioYXtyYJrS2bSfRAwqwy74S";
    address public constant USER = address(1);
    address owner;
    uint256 initialContractBalance;
    uint256 initialOwnerBalance;
    event GasCost(uint256 gasCost);

    function setUp() public {
        deployer = new DeploySimpleNft();
        simpleNft = deployer.run();

        owner = simpleNft.owner();
        initialContractBalance = address(simpleNft).balance;
        initialOwnerBalance = payable(owner).balance;
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Birdie";
        string memory actualName = simpleNft.name();

        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testMint() public payable {
        vm.prank(USER);
        vm.deal(USER, 10 ether);
        simpleNft.mintNft{value: 1 ether}();
        assert(simpleNft.balanceOf(USER) == 1);
    }

    function testMintIncreasesTokenCounter() public {
        // Call the mintNft function
        vm.prank(USER);
        vm.deal(USER, 10 ether);
        simpleNft.mintNft{value: 1 ether}();

        assert(simpleNft.getTokenId() == 2);
    }

    function testWithdraw() public {
        vm.prank(owner);
        vm.deal(address(simpleNft), 10 ether);
        assert(address(simpleNft).balance == 10 ether);

        simpleNft.withdraw();

        assert(address(simpleNft).balance == 0);
    }
}
