// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBirdz is ERC721Connector {

    //mảng để lưu NFT
    string [] public kryptoBirdz;

    //mapping những nft đã tồn tại hay chưa
    mapping (string => bool) public KryptoBirdzExist;

    function mint(string memory _kryptoBirdz) public {
        //require xem đã tạo hay chưa
        require(!KryptoBirdzExist[_kryptoBirdz], "KryptoBirdz already exist");

        //đưa vào mảng vừa tạo _kryptoBirdz

        kryptoBirdz.push(_kryptoBirdz);
        uint _id = kryptoBirdz.length - 1;

        //gọi đến hàm _mint trong ERC721.sol để tạo nft
        _mint(msg.sender, _id);


        KryptoBirdzExist[_kryptoBirdz] = true;  //set cho cái vừa tạo thành tồn tại
    }


    constructor() ERC721Connector('KryptoBirdz', 'KBIRDZ') {
         
    }
    
}