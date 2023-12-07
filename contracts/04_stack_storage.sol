// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract StackStorage {

    // 计划中的闭环结构，在主链上仅存储头尾的哈希
    // hash(endhash||nonce)|headhash的前面0的个数作为信任度
    // 尝试提升信任度时，以renonce为起始，逐个尝试，直到投入了指定工作量，记录期间获得最大信任度的nonce，更新nonce
    // 完成指定工作量后，在renonce中记录当前尝试的nonce，即使没有得到更高信任度的值也更新
    // 注：如果使用随机化算法，或许不需要renonce
    struct Closure {
        string  headhash;
        string  endhash;
        uint256 nonce;
        bool isValid;
    }

    // 存储数据的映射
    // 哈希表结构，本程序实现对栈数据结构的模拟
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
    function updateDataAtIndex(uint256 _index, string memory _data) public isNotOutBound(_index) isNotExist(_data) {
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
        require(curIndex > 1, "stack empty");
        _;
    }

    // 检查请求的下标是否越界
    modifier isNotOutBound(uint256 _index) {
        require(curIndex > 1, "stack empty");
        require(_index < curIndex && _index > 0, "index outbound");
        _;
    }

    // 数据不存在
    modifier isNotExist(string memory _data) {
        require(indexes[keccak256(abi.encode(_data))]==0, "data already exist");
        _;
    }

    // 数据已存在
    modifier isExist(string memory _data) {
        require(indexes[keccak256(abi.encode(_data))]!=0, "data not exist");
        _;
    }

    // 初始化，设置栈为空
    constructor() {
        // 约定栈的下标从1开始，0越界
        curIndex = 1;
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
    function getClosureByIndex(uint256 _closureIndex) public view returns(string memory) {
        return getDataAtIndex(_closureIndex);
    }

    // 3. 计算closure的信任度
    function getTrust(Closure memory _data) public pure returns (uint256) {
        // 计算 sha256(endhash+nonce)
        Closure memory data = _data;
        bytes32 calculatedHash = sha256(abi.encodePacked(data.endhash, data.nonce));

        // 将字符串转换为字节数组，以便进行按位比较
        bytes memory headBytes = bytes(data.headhash);
        bytes32 headHashBytes;

        // 确保 headBytes 的长度小于等于 32
        require(headBytes.length <= 32, "Headhash.len>32");

        // 使用零填充 headBytes，创建一个32字节的数组
        for (uint256 i = 0; i < headBytes.length; i++) {
            headHashBytes |= bytes32(uint256(uint8(headBytes[i])) << (8 * (headBytes.length - 1 - i)));
        }

        // 执行按位比较并计数连续匹配的位数
        uint256 matchingBits = 0;
        uint256 mask = 1;
        for (uint256 i = 0; i < 256; i++) {
            if ((uint256(calculatedHash) & (mask << i)) == (uint256(headHashBytes) & (mask << i))) {
                matchingBits++;
            } else {
                break;
            }
        }

        return matchingBits;
    }

    // 4. 更新Closure（加信任度）
    function updateClosure(string memory _oldData, string memory _newData) public isExist(_oldData) isNotExist(_newData) {
        uint256 index = getIndexOfData(_oldData);
        updateDataAtIndex(index, _newData);
    }

}