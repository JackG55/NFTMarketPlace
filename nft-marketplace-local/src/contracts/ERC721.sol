// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
    * @title Viết minting function 
    1. Địa chỉ nào tạo ra NFT 
    2. Theo dõi NFT ids coi được tạo ra mấy lần
    3. Ai là chủ sở hữu
    4. Xem ai sở hữu bao nhiêu NFT
    5. tạo 1 event emits a tranfer log - contract address, from, to, token id
 */


contract ERC721{

     //tạo 1 event emits a tranfer log - contract address, from, to, token id
    event Transfer(
        address indexed from, 
        address indexed to , 
        uint256 indexed tokenId);

    // Địa chỉ nào tạo ra NFT
    mapping (uint256 => address) private _tokenOwner;

    //Địa chỉ sở hữu bao nhiêu NFT
    mapping (address => uint256) private _OwnerTokensCount;

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view returns (uint256){
        require (_owner!= address(0), 'Owner is not exist');
        return _OwnerTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Owner is not exist');
        return owner;
    }


    function _exist (uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual{
        //yêu cầu địa chỉ khác 0
        require(to != address(0), 'ERC721: minting to the null address');
        
        //kiểm tra xem tokenid đã tồn tại hay chưa
        require(!_exist(tokenId), 'This token is already exist');

        //địa chỉ sở hữu token
        _tokenOwner[tokenId] = to;

        //số lượng token của 1 địa chỉ
        _OwnerTokensCount[to]++;

        //gọi event
        emit Transfer(address(0), to, tokenId);
        
    }

   
}