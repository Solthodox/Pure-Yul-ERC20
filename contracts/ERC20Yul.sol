object "ERC20Yul"{
    //CONSTRUCTOR
    code {
        //store msg.sender in position 0
        sstore(0, caller())
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    //BODY
    object "runtime"{
        //function selector()
        code {

            // switch through all the functions using the function selector, functions are named by the first 8 characters of the function signature
            switch selector() 
            //keccack256(balanceOf(address))
            case 70a08231{}
            //keccak256(totalSupply())
            case 18160ddd{}
            //keccak256(transfer(address,uint256))
            case a9059cbb{}
            //keccak256(approve(address,uint256))
            case 095ea7b3{}
            //keccak256(transferFrom(address,address,uint256))
            case 23b872dd{}
            //keccak256(approval(address,address))  
            case e1270b6e{}
        //------------------------------------------------------------------------------------------------------------------          
            //fallback function
            default {
                revert(0,0)
            }
        //------------------------------------------------------------------------------------------------------------------
        //function selector 
            function selector() -> s {
                //divide the whole calldata by 0x100000000000000000000000000000000000000000000000000000000 and return
                s := div(calldataload(0),0x100000000000000000000000000000000000000000000000000000000)
            }
        
        //------------------------------------------------------------------------------------------------------------------
        //storage pointers
            function ownerPos() -> p {
                //owner is stored in position 0 in storage
                p := 0
            }

            function totalSupplyPos() -> p {
                // supply in position 1
                p := 1
            }
            function accountToStorageOffset(account) -> offset {
                // position  = 4096 + account
                offset := add(0x1000, account)
            }
            function allowanceStorageOffset(account, spender) -> offset {
                offset := accountToStorageOffset(account)
                mstore(0, offset)
                mstore(0x20, spender)
                offset := keccak256(0, 0x40)
            }
        
        //--------------------------------------------------------------------------------------------------------------------
        //storage access

            /* -------- storage access ---------- */
            //load from storage positon ownerPos()=0
            function owner() -> o {
                o := sload(ownerPos())
            }
            
            //load from storage positon totalSupplyPos()=1
            function totalSupply() -> supply {
                supply := sload(totalSupplyPos())
            }

            //increase totalSupply by storing the new total supply in the needed position in storage
            function mintTokens(amount) {
                //safeAdd to prevent overflow
                sstore(totalSupplyPos(), safeAdd(totalSupply(), amount))
            }

            //load users balance from storage pointer position
            function balanceOf(account) -> bal {
                bal := sload(accountToStorageOffset(account))
            }

            //increase balance => set balance to new balance by adding the new amount to the current balance on position accountToStorageOffset()
            function addToBalance(account, amount) {
                let offset := accountToStorageOffset(account)
                //safeAdd to prevent overflow
                sstore(offset, safeAdd(sload(offset), amount))
            }
            //same for decreasing balance
            function deductFromBalance(account, amount) {
                let offset := accountToStorageOffset(account)
                let bal := sload(offset)
                require(lte(amount, bal))
                sstore(offset, sub(bal, amount))
            }

            function allowance(account, spender) -> amount {
                amount := sload(allowanceStorageOffset(account, spender))
            }

            function setAllowance(account, spender, amount) {
                sstore(allowanceStorageOffset(account, spender), amount)
            }

            function decreaseAllowanceBy(account, spender, amount) {
                let offset := allowanceStorageOffset(account, spender)
                let currentAllowance := sload(offset)
                require(lte(amount, currentAllowance))
                sstore(offset, sub(currentAllowance, amount))
            }

        }

    }
}