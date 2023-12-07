// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract StackStorage {

    // 计划中的闭环结构，在主链上仅存储头尾的哈希
    // hash(endhash||nonce)|headhash的前面0的个数作为信任度
    // 尝试提升信任度时，以renonce为起始，逐个尝试，直到投入了指定工作量，记录期间获得最大信任度的nonce，更新nonce
    // 完成指定工作量后，在renonce中记录当前尝试的nonce，即使没有得到更高信任度的值也更新
    // 注：如果使用随机化算法，或许不需要renonce wwww
    // struct Closure {
    //     string  headhash;
    //     string  endhash;
    //     uint256 nonce;
    //     uint256 renonce;
    // }

    // 存储数据的映射
    // 实际上时哈希表结构，本程序实现对栈数据结构的模拟
    mapping(uint256 => string) private closures;

    // closure头尾的keccak256到下标的映射，用于查找指定记录是否存在，确定下标以renonce
    mapping(bytes32 => uint256) private indexes;


    // 栈顶位置，约定总指向最后一个元素+1
    uint256 curIndex;

    // 栈更新时发出事件
    event StackPush(uint256 indexed index, string data);
    event StackPop(uint256 indexed index, string data);
    event StackEdit(uint256 indexed index, string data);


    // 压栈
    function pushStack(string memory _data) public isNotExist(_data){
        emit StackPush(curIndex, _data);

        closures[curIndex] = _data;
        indexes[keccak256(abi.encode(_data))] = curIndex;

        curIndex = curIndex + 1;
    }

    // 弹栈
    function popStack() public isNotEmpty returns (string memory) {
        curIndex = curIndex - 1;
        string memory data = closures[curIndex];

        emit StackPop(curIndex, data);

        delete closures[curIndex];
        delete indexes[keccak256(abi.encode(data))];

        return data;
    }

    // 修改对应下标处的数据
    function updateDataAtIndex(uint256 _index, string memory _data) public isNotOutBound(_index) {
        string memory oldData = closures[_index];
        delete indexes[keccak256(abi.encode(oldData))];

        emit StackEdit(_index, _data);

        closures[_index] = _data;
        indexes[keccak256(abi.encode(_data))] = _index;
    }

    // 按下标获取数据(0 .. curIndex-1)
    function getDataAtIndex(uint256 _index) public isNotOutBound(_index) view returns (string memory) {
        return closures[_index];
    }

    // 按数据查找下标
    function getIndexOfData(string memory _data) public view returns (uint256) {
        return indexes[keccak256(abi.encode(_data))];
    }

    // 获取当前栈顶
    function getCurIndex() public view returns (uint256) {
        return curIndex;
    }

    // 检查栈是否为空
    modifier isNotEmpty() {
        require(curIndex >= 1, "stack empty");
        _;
    }

    // 检查请求的下标是否越界
    modifier isNotOutBound(uint256 _index) {
        require(curIndex >= 1, "stack empty");
        require(_index < curIndex && _index >= 0, "index outbound");
        _;
    }

    // 数据是否重复
    modifier isNotExist(string memory _data) {
        require(indexes[keccak256(abi.encode(_data))]==0, "data already exist");
        _;
    }

    modifier isExist(string memory _data) {
        uint256 index = indexes[keccak256(abi.encode(_data))];
        bool isDataEmpty = closures[index].length == 0;
        require(index !=0 || isDataEmpty, "data not exist");
        _;
    }

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
    function saveClosure(string memory _closure) public {
        pushStack(_closure);
    }

    // 2. 获取closure数据
    function getClosure(uint256 _closureIndex) public view returns(string memory) {
        return getDataAtIndex(_closureIndex);
    }

    // 3. 计算closure的信任度
    function getTrust(string memory closureData, uint256 nonce) public {

    }

    // 4. 更新Closure（加信任度）
    function updateClosure(string memory oldData, string memory newData) public {
        uint256 index = getIndexOfData(oldData);
        updateDataAtIndex(index, newData);
    }

}