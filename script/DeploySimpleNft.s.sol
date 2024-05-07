//SPDX License Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleNft} from "../src/SimpleNft.sol";

contract DeploySimpleNft is Script {
    function run() external returns (SimpleNft) {
        vm.startBroadcast();
        SimpleNft simpleNft = new SimpleNft();
        vm.stopBroadcast();
        return simpleNft;
    }
}
