// SPDX-License-Identifier: MIT
pragma solidity > 0.8.0 <0.9.0;

contract EditMyPage {
    
    // 帖子记录
    string myPage;

    // 帖子所有者的地址
    address private owner;

    // 事件记录，与智能合约交互时可以在日志栏中看到
    // 发出事件时使用emit changeOwner(参数)
    event changeOwner(address oldOwner, address newOwner);






}