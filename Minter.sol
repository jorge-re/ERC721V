// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;

import "./721V.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MegaMint is Ownable, ERC721V {

    using Strings for uint256;

    string private baseTokenURI = "https:///";


    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721V(_name, _symbol) Ownable(msg.sender){
        setBaseURI(_initBaseURI);
        uint256 maxVal = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;//type(uint256).max;
        uint256[] memory vals = new uint256[](4);

        vals[0] = maxVal;
        vals[1] = maxVal;
        vals[2] = maxVal;
        vals[3] = maxVal;

        mintWithMask(vals);
        mint(777777);

        setDefault(msg.sender);
    }
    function sendEvnetsFor(uint256[] calldata _ids) public onlyOwner{
        for(uint256 i = 0; i < _ids.length; i++){
            emit Transfer(address(0), getDefaultOwner(), _ids[i]);
        }
        setBalanceOfDefault(_ids.length);
    }

    // public
    function mint(uint256 _mintNumber) public onlyOwner {
        setAtID(_mintNumber);
        emit Transfer(address(0), getDefaultOwner(), _mintNumber);
    } 
    function mintWithMask(uint256[] memory activationMasks) public onlyOwner{
        setBitsForValues(activationMasks);
    }
    function mintWithMask(uint256[] memory activationMasks, uint256 startIndex)public onlyOwner{
        setBitsForValues(activationMasks, startIndex);
    }
    function mintWithMaskEventful(uint256[] memory activationMasks, uint256 startIndex)public onlyOwner{
        setBitsForValues(activationMasks, startIndex);
        uint256 counter = 0;
        for(uint256 i = 0; i < activationMasks.length; i++){
            for(uint256 j = 0; j < 256; j++){
                if((activationMasks[i] & (1 << j)) > 0){
                    emit Transfer(address(0), getDefaultOwner(), startIndex+(i*256)+j);
                    counter++;
                }
            }
        }
        setBalanceOfDefault(this.balanceOf(getDefaultOwner())+counter); //add count
    }
    function _baseURI() internal view virtual override returns (string memory) {
      return baseTokenURI;
    }
    function setBaseURI(string memory _value) public onlyOwner{
      baseTokenURI = _value;
    }
    function setBalanceOfDefault(uint256 _balance) public onlyOwner{
        setDefaultOwnerBalance(_balance);
    }
    function setDefault(address _owner) public onlyOwner{
        setDefaultOwner(_owner);
    }
    
}
