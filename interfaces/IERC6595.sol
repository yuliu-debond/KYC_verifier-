// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

interface IERC5851{
    // getter functions

    /// @notice getter function to validate if the address `verifying` is the holder of the claim Defined by the tokenId `SBTID`
    /// @dev it MUST be Defining the logic to fetch the result of the ZK verification (either from).
    /// @dev logic given here MUST be one of ("⊄", "⊂", "<", "<=", "==", "!=", ">=", ">")
    /// @param verifying is the  EOA address that wants to validate the SBT issued to it by the KYC. 
    /// @param SBTID is the Id of the SBT that user is the claimer.
    /// @return true if the assertion is valid, else false
    /**
    example ifVerified(0xfoo, 1) => true will mean that 0xfoo is the holder of the SBT identity token DeFined by tokenId of the given collection. 
    */
    function ifVerified(address verifying, uint256 SBTID) external view returns (bool);


    /// @notice getter function to fetch the on-chain identification logic for the given identity holder.
    /// @dev it MUST not be defined for address(0). 
    /// @param SBTID is the Id of the SBT that the user is the claimer.
    /// @return the struct array of all the descriptions of condition metadata that is defined by the administrator for the given KYC provider.
    /**
    ex: standardClaim(1) --> {
    { "title":"DepositClaim",
        "type": "number",
        "description": "defines the minimum deposit in USDC for the investor along with the credit score",
        },
       "logic": "and",
    "values":{"30000", "5"}
} 
This defines the condition encoded for the identity index 1, defining the identity condition that the holder must have 30000 USDC along with a credit score of at least 5. 
**/

function standardClaim(uint256 SBTID) external view returns (Claim[] memory);
   
// setter functions

    /// @notice function for setting the claim requirement logic (defined by Claims metadata) details for the given identity token defined by SBTID.
    /// @dev it should only be called by the admin address.
    /// @param SBTID is the Id of the SBT-based identity certificate for which the admin wants to define the Claims.
    /// @param `claims` is the struct array of all the descriptions of condition metadata that is defined by the administrator. check metadata section for more information.
/**
example: changeStandardClaim(1, { "title":"DepositClaim",
    "type": "number",
    "description": "defines the minimum deposit in USDC for the investor along with the credit score",
    },
    "logic": "and",
    "values":{"30000", "5"}
}); 
will correspond to the functionality that admin needs to adjust the standard requirement for the identification SBT with tokenId = 1, based on the conditions described in the Requirements array struct details.
**/
    function changeStandardClaim(uint256 SBTID, Claim[] memory claims) external returns (bool);

    /// @notice function which uses the ZKProof protocol to validate the identity based on the given 
    /// @dev it should only be called by the admin address.
    /// @param SBTID is the Id of the SBT-based identity certificate for which admin wants to define the Claims.
    /// @param certifying is the address that needs to be proven as the owner of the SBT defined by the tokenID.
    /**
example: certify(0xA....., 10) means that admin assigns the DID badge with id 10 to the address defined by the `0xA....` wallet.
    */
    function certify(address certifying, uint256 SBTID) external returns (bool);


    /// @notice function which uses the ZKProof protocol to validate the identity based on the given 
    /// @dev it should only be called by the admin address.
    /// @param SBTID is the Id of the SBT-based identity certificate for which the admin wants to define the Claims.
    /// @param certifying is the address that needs to be proven as the owner of the SBT defined by the tokenID.
    // eg: revoke(0xfoo,1): means that KYC admin revokes the SBT certificate number 1 for the address '0xfoo'.

    function revoke(address certifying, uint256 SBTID) external returns (bool);


// Events
    /** 
    * standardChanged
    * @notice standardChanged MUST be triggered when claims are changed by the admin. 
    * @dev standardChanged MUST also be triggered for the creation of a new SBTID.
    e.g : emit StandardChanged(1, Claims(Metadata('depositClaim','number', 'defines the max deposited that user can have in the denomination of USDC' ), "<=", "30000");
    is emitted when the Claim condition is changed which allows the certificate holder to call the functions with the modifier, only after the deposit in the address is not greater than 30000 USDC.
    */
    event StandardChanged(uint256 SBTID, Claim[] _claim);
    
    /** 
    * certified
    * @notice certified MUST be triggered when the SBT certificate is given to the certifying address. 
    * eg: Certified(0xfoo,2); means that wallet holder address 0xfoo is certified to hold a certificate issued with id 2, and thus can satisfy all the conditions defined by the required interface.
    */
    event Certified(address certifying, uint256 SBTID);
    
    /** 
    * revoked
    * @notice revoked MUST be triggered when the SBT certificate is revoked. 
    * eg: Revoked( 0xfoo,1); means that entity user 0xfoo has been revoked to all the function access defined by the SBT ID 1.
    */
    event Revoked(address certifying, uint256 SBTID);
}
