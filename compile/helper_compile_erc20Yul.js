const path = require('path');
const fs = require('fs');
const solc = require('solc');

/// @notice compile the ERC20Yul contract
async function compileERC20YulContract(input) {

    console.log("--------------------------------");

    let thepath = path.resolve(__dirname, '../', 'build', 'ERC20Yul.bytecode.json')
    try {
        
        fs.unlinkSync(thepath);
    } catch (err) {
        // console.error(err);
    }
    console.log("File removed (if exists): ", thepath);

    const output = JSON.parse(solc.compile(JSON.stringify(input)));
    const bytecode = output.contracts['ERC1155Yul.sol'].ERC1155Yul.evm.bytecode;

    fs.writeFile(thepath, JSON.stringify(bytecode), (err) => {
        if (err) throw err;
        else{
           console.log("ERC20 Yul code successfully compiled!");
           console.log("--------------------------------");
           console.log("Bytecode at: ", thepath);
           console.log("--------------------------------");
           console.log("🛠 ✨ Building done ✨");
           console.log("");
        }
     })

     return bytecode;
}

module.exports = {
    compileERC20YulContract
}