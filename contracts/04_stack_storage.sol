// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract StackStorage {

    // 计划中的闭环结构，在主链上仅存储头尾的哈希
    // hash(endhash||nonce)|headhash的前面0的个数作为信任度
    // 尝试提升信任度时，以renonce为起始，逐个尝试，直到投入了指定工作量，记录期间获得最大信任度的nonce，更新nonce
    // 完成指定工作量后，在renonce中记录当前尝试的nonce，即使没有得到更高信任度的值也更新
    // 注：如果使用随机化算法，或许不需要renonce
    // struct Closure {
    //     string  headhash;
    //     string  endhash;
    //     uint256 nonce;
    //     uint256 renonce;
    // }

    // 存储数据的映射
    // 实际上时哈希表结构，本程序实现对栈数据结构的模拟
    mapping(uint256 => string) private closures;

    // closure头尾的sha-256到下标的映射，用于查找指定记录是否存在，确定下标以renonce
    mapping(bytes32 => uint256) private indexes;


    // 栈顶位置，约定总指向最后一个元素+1
    uint256 curIndex;

    // 压栈时发出事件
    event StackPush(uint256 index, string data);
    event StackPop(uint256 index, string data);


    // 压栈
    function pushStack(string memory _data) public {
        emit StackPush(curIndex, _data);
        closures[curIndex] = _data;
        curIndex = curIndex + 1;
    }

    // 弹栈
    function popStack() public isEmpty returns (string memory) {
        curIndex = curIndex - 1;
        string memory data = closures[curIndex];
        emit StackPop(curIndex, data);
        return data;
    }

    // 按下标(0 .. curIndex-1)获取数据
    function getDataAtIndex(uint256 _index) public isOutBound(_index) view returns (string memory) {
        return closures[_index];
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
    modifier isOutBound(uint256 _index) {
        require(curIndex >= 1, "stack empty");
        require(_index < curIndex && _index >= 0, "index outbound");
        _;
    }

    // function setIndex(uint256 index, string memory newData) public {

    // }

    // 初始化，设置栈为空
    constructor() {
        curIndex = 0;
    }



    // // 1. 存储closure数据
    // function saveClosure(Closure memory closure) public {
        
    // }

    // // 2. 获取closure数据
    // function getClosure(uint256 closureIndex) public view returns(Closure memory) {

    // }


    // // 3. 计算closure的信任度
    // function getTrust(Closure memory closure) public {

    // }

    // // 4. 更新Closure（加信任度）
    // function updateClosure(Closure memory closure) public {

    // }

    // 1. 存储closure数据
    function saveClosure(string memory closure) public {
        
    }

    // 2. 获取closure数据
    function getClosure(uint256 closureIndex) public view returns(string memory) {

    }

    // 3. 计算closure的信任度
    function getTrust(string memory closureData, uint256 nonce) public {

    }

    // 4. 更新Closure（加信任度）
    function updateClosure(string memory closureData, uint256 nonce) public {

    }


}