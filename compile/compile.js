const path = require('path');
const fs = require('fs');


const { compileERC20YulContract } = require("./helper_compile_erc20Yul");

const erc20Path = path.resolve(__dirname, '../', 'contracts', 'ERC20Yul.sol');
const source = fs.readFileSync(erc20Path, 'utf-8');

var input = {
    language: 'Yul',
    sources: {
        'ERC20Yul.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ "evm.bytecode" ]
            }
        }
    }
};

compileERC20YulContract(input);

