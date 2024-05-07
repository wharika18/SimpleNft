//SPDX License Identifier: MIT
pragma solidity ^0.8.19;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;
    uint256 private constant s_mintPrice = 1 ether; // Fixed price for minting the NFT
    address payable public owner;

    constructor() ERC721("Birdie", "BIRD") {
        owner = payable(msg.sender);
        s_tokenCounter = 1;
    }

    function mintNft() public payable {
        require(msg.value >= s_mintPrice, "Insufficient funds");

        string memory uri = tokenURI(s_tokenCounter);

        _safeMint(msg.sender, s_tokenCounter);

        s_tokenIdToUri[s_tokenCounter] = uri;

        s_tokenCounter++;
    }

    function getTokenId() public view returns (uint256) {
        return s_tokenCounter;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }

    function withdraw() public {
        require(msg.sender == owner, "Caller is not the owner");
        (bool success, ) = owner.call{value: address(this).balance}(""); // this is call method to transfer the amount
        require(success);
    }
}
