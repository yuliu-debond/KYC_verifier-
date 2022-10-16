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
     * @notice this structure is used for the verification process, it chontains the metadata, logic and expectation
     * @logic given here MUST be either ("and", "or")
     */
    struct Requirement {
        Metadata metadata;
        string logic;
        Values expectation;
    }

    function ifVerified(address verifying, uint256 SBFID) external view returns (bool);
    function standardRequirement(uint256 SBFID) external view returns (Requirement[] memory);
    function changeStandardRequirement(uint256 SBFID, Requirement[] memory requirements) external returns (bool);
    function certify(address certifying, uint256 SBFID) external returns (bool);
    function revoke(address certifying, uint256 SBFID) external returns (bool);

    event standardChanged(uint256 SBFID, Requirement[]);   
    event certified(address certifying, uint256 SBFID);
    event revoked(address certifying, uint256 SBFID);
}
