// SPDX-License-Identifier: MIT
pragma solidity > 0.8.0 <0.9.0;

contract EditMyPage {
    
    // 帖子记录
    string myPage;

    // 帖子所有者的地址
    address private owner;

    // 事件记录，与智能合约交互时可以在日志栏中看到
    // 发出事件时使用emit OwnerChange(参数)
    event OwnerChange(address oldOwner, address newOwner);
    event PageUpdate(string oldPage, string newPage);


    // 检查调用者是否为版主
    // 通过继承modifier，可以给函数加入权限检查等功能
    modifier isOwner() {
        // 参考2_Owner.sol，此处如果检查失败，事务会撤销
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    function setMyPage(string memory newPage) public isOwner{
        emit PageUpdate(myPage,newPage);
        myPage = newPage;
    }






}