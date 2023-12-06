// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract StackStorage {

    // struct Closure {
    //     uint256 nonce;
    //     uint256 trustScore;
    // }

    // 存储数据的栈
    // 实际上时哈希表结构，本程序实现对栈数据结构的模拟
    mapping(uint256 => string) private strings;

    // 栈顶位置，约定总指向最后一个元素+1
    uint256 curIndex;

    // 压栈时发出事件
    event StackPush(uint256 index, string data);

    // 压栈
    function pushStack(string memory newData) public {
        strings[curIndex] = newData;
        emit StackPush(curIndex, newData);
        curIndex = curIndex + 1;
    }

    // 弹栈
    function popStack() public isEmpty returns (string memory) {
        curIndex = curIndex - 1;
        return strings[curIndex];
    }

    // 按下标获取数据
    function getDataAtIndex(uint256 index) public isOutBound(index) view returns (string memory) {
        return strings[index];
    }

    // 获取当前栈顶
    function getCurIndex() public view returns (uint256) {
        return curIndex;
    }

    // 检查栈是否为空
    modifier isEmpty() {
        require(curIndex >= 1, "stack empty");
        _;
    }

    // 检查请求的下标是否越界
    modifier isOutBound(uint256 index) {
        require(curIndex >= 1, "stack empty");
        require(index < curIndex && index >= 0, "index outbound");
        _;
    }

    // function setIndex(uint256 index, string memory newData) public {

    // }

    // 初始化，设置栈为空
    constructor() {
        curIndex = 0;
    }

}