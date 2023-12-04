// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

contract EditMyPage {
    
    // 帖子记录
    string myPage;

    // 帖子所有者的地址
    address private owner;

    // 事件记录，与智能合约交互时可以在日志栏中看到
    // 发出事件时使用emit OwnerChange(参数)
    // indexed: 记录事件时用作索引，额外存储以加速查找（占空间）
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    event PageUpdate(address indexed owner, string newPage);


    // 检查调用者是否为版主
    // 通过继承modifier，可以给函数加入权限检查等功能
    modifier isOwner() {
        // 参考2_Owner.sol，此处如果检查失败，事务会撤销
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    // 修改帖子内容
    function setMyPage(string memory newPage) public isOwner {
        emit PageUpdate(owner,newPage);
        myPage = newPage;
    }

    // 移交版主权限
    function passOwner(address newOwner) public isOwner {
        emit OwnerSet(owner,newOwner);
        owner = newOwner;
    }

    // 获取版主地址
    function getOwner() public view returns (address) {
        return owner;
    }

    // 获取帖子内容
    function getPage() public view returns (string memory) {
        return myPage;
    }

    // 创建帖子合约
    constructor(string memory newPage) {
        console.log("Owner contract deployed by:", msg.sender);
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        myPage = newPage;
        emit OwnerSet(address(0), owner);
        emit PageUpdate(owner, newPage);
    }

}