// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;


interface IERC6595 {
    // STRUCTURE 
    /**
     * @dev Values structure of the Metadata, cited from ERC-3475
     */

    struct Values { 
        string stringValue;
        uint uintValue;
        address addressValue;
        bool boolValue;
    }

    /**
     * @dev structure that defines the parameters for specific issuance of bonds and amount which are to be transferred/issued/given allowance, etc.
     * @notice this structure is used for the verification process, it chontains the metadataID, logic, expectation
     * @metadataID is the ID of the metadatas need to be verified
     * @logics given here MUST be either ("<", "<=", "=", ">=", ">")
     * @expectation is the value that is expected to be ("<", "<=", "=", ">=", ">") than (to) the metadata value of the verifying
     */

    struct Verification {
        uint256 metadataID;
        string logic;
        Values expectation;
    }
    
    function verifiy(address verifying, Verification memory proofNeeded) external view returns (bool);
}

abstract contract ERC6595 is IERC6595 {
    address private _authenticator;
    Verification private _KYCRequirement;
    uint public test;

    constructor(address authenticatorAddress, Verification memory KYCStandard) {
        _KYCRequirement = KYCStandard;
        _authenticator = authenticatorAddress;
    }

    modifier KYCApproved(address verifying) {
        IERC6595(_authenticator).verifiy(verifying, _KYCRequirement);
        _;
    }
}

abstract contract Token is ERC6595 {

    function mint(address to, uint256 amount) public KYCApproved(to){
        _mint(to, amount);
    }

    function _mint(address account, uint256 amount) internal  {
        require(account != address(0), "ERC20: mint to the zero address");
        test = amount;
    }


}
