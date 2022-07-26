// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';
import './ERC165.sol';
import './interfaces/IERC721.sol';

/**
    * @title Viết minting function 
    1. Địa chỉ nào tạo ra NFT 
    2. Theo dõi NFT ids coi được tạo ra mấy lần
    3. Ai là chủ sở hữu
    4. Xem ai sở hữu bao nhiêu NFT
    5. tạo 1 event emits a tranfer log - contract address, from, to, token id
 */


contract ERC721 is ERC165, IERC721 {

     //tạo 1 event emits a tranfer log - contract address, from, to, token id
    // event Transfer(
    //     address indexed from, 
    //     address indexed to , 
    //     uint256 indexed tokenId);

    // event Approval (
    //     address indexed owner,
    //     address indexed approved,
    //     uint256 indexed tokenId);
    

    // Địa chỉ nào tạo ra NFT
    mapping (uint256 => address) private _tokenOwner;

    //Địa chỉ sở hữu bao nhiêu NFT
    mapping (address => uint256) private _OwnerTokensCount;

    //Mapping from token id to approved address
    mapping (uint256 => address) private _tokenApprovals;

   
    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    } 

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public override view returns (uint256){
        require (_owner!= address(0), 'Owner is not exist');
        return _OwnerTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public override view returns (address){
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

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    

    function _transferFrom (address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error = ERC721 Transfer to the zero address' );
        require( ownerOf(_tokenId) == _from, 'Trying to trasfer a token the same token address');
        
        _OwnerTokensCount[_from]--;
        _OwnerTokensCount[_to]++;
        
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }


    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        _transferFrom(_from, _to, _tokenId);
    }

    //1. require that the person approving is the owner
    //2. we are approving an address to a token (tokenId)
    //3. require that we can't approve sending tokens of the owner to the owner
    //4. update the map of the approval address
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Curent caller is not the owner ');
        _tokenApprovals[tokenId] = _to;


        emit Approval(owner, _to, tokenId);
    }

}