// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './ERC721.sol';

//contract này có nhiệm vụ thống kê
contract ERC721Enumerable is ERC721 {
    uint256[] private _allTokens;   //mảng chưa toàn bộ token

    //mapping from tokenId to position in array _allTokens
    mapping(uint256 => uint256) private _allTokensIndex;  

    //mapping of owner to list of all owner's tokens
    mapping(address => uint256[]) private _ownerTokens;

    //mapping from the tokenId of the owner token list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    

    //override _mint funtction from ERC721
    function _mint(address to,uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        
        //thêm tokens tới owner
       
        _addFunctionToAllEnumaration(tokenId);
        _addTokenToOwnerEnumaration(to, tokenId);
        
    }

    //add token to the _alltokens array and set the position of the token index
    function _addFunctionToAllEnumaration (uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }


    function _addTokenToOwnerEnumaration (address to, uint256 tokenId) private {
        //add adress and tokenid to the _ownerTokens 
        //ownedTokenIndex tokenId set to the address of the ownerTokens position
        _ownedTokensIndex[tokenId] = _ownerTokens[to].length;
        
        _ownerTokens[to].push(tokenId);

    }

    //two functions - one that returns tokenBytheIndex and 
    //-one that returns tokenofOwnerByIndex 

    function tokenByIndex(uint256 index) public view returns(uint256)
    {
        //cần bé hơn total supply
        require(index < totalSupply(), 'out of bounds');
        return _allTokensIndex[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public view returns(uint256){
        require(index<balanceOf(owner), 'out of bounds');
        return _ownerTokens[owner][index];
    }

     /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view returns (uint256){
        return _allTokens.length;
    }
}
