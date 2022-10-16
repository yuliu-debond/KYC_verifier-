// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;


interface IERC6595 {
    // STRUCTURE 
    /**
     * @dev metadata and Values structure of the Metadata, cited from ERC-3475
     */
    struct Metadata {
        string title;
        string _type;
        string description;
    }
    struct Values { 
        string stringValue;
        uint uintValue;
        address addressValue;
        bool boolValue;
    }

    /**
     * @dev structure that defines the parameters for specific issuance of bonds and amount which are to be transferred/issued/given allowance, etc.
     * @notice this structure is used for the verification process, it chontains the SBFID and logic
     * @logic given here MUST be either ("and", "or")
     */
    struct Verification {
        uint256 SBFID;
        string logic;
    }

    struct Requirement {
        uint256 metadataID;
        string logic;
        string expectation;
    }

    function verifiy(address verifying, Verification[] memory proofNeeded) external view returns (bool);
    function standardRequirement(uint256 SBFID) external view returns (Requirement[] memory);
    function changeStandardRequirement(uint256 SBFID, Requirement[] memory) external view returns (bool);
    function certify(address certifying, uint256 SBFID) external returns (bool);
    function revoke(address certifying, uint256 SBFID) external returns (bool);

    event standardChanged(uint256 SBFID, Requirement[]);   
    event certified(address certifying, uint256 SBFID);
    event revoked(address certifying, uint256 SBFID);

}

abstract contract ERC6595 is IERC6595 {
    address private _authenticator;
    Verification[] private _KYCRequirement;

    constructor(address authenticatorAddress, Verification[] memory KYCStandards) {
        _KYCRequirement = KYCStandards;
        _authenticator = authenticatorAddress;
    }

    modifier KYCApproved(address verifying) {
        IERC6595(_authenticator).verifiy(verifying, _KYCRequirement);
        _;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

abstract contract Token is ERC6595 {
    uint public test;
    function mint(address to, uint256 amount) public KYCApproved(to){
        _mint(to, amount);
    }

    function _mint(address account, uint256 amount) internal  {
        require(account != address(0), "ERC20: mint to the zero address");
        test = amount;
    }


}
