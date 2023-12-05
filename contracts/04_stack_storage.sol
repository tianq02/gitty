// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract StackStorage {

    // struct Closure {
    //     uint256 nonce;
    //     uint256 trustScore;
    // }

    mapping(uint256 => string) private strings;

    uint256 curIndex;

    event StackPush(uint256 index, string data);

    function pushStack(string memory newData) public {
        strings[curIndex] = newData;
        emit StackPush(curIndex, newData);
        curIndex = curIndex + 1;
    }

    function popStack() public returns (string memory) {
        require(curIndex>0, "empty stack");
        curIndex = curIndex - 1;
        return strings[curIndex];
    }

    function getDataAtIndex(uint256 index) public view returns (string memory) {
        require(index < curIndex && index >= 0, "index outbound");
        return strings[index];
    }

    function getCurIndex() public view returns (uint256) {
        return curIndex;
    }



    // function setIndex(uint256 index, string memory newData) public {

    // }

    constructor() {
        curIndex = 0;
    }

}