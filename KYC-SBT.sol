
// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;
import "./interfaces/IERC6595.sol";

abstract contract KYCABST is IERC6595{
    mapping(uint256 => IERC6595.Requirement[]) private _requiredMetadata;
    mapping(address => mapping(uint256 => bool)) private _SBTVerified;
    address public admin;
    
    constructor() {
        admin = msg.sender;

    }
    
    function ifVerified(address verifying, uint256 SBFID) public override view returns (bool){
        return(_SBTVerified[verifying][SBFID]);
    }
    
    function standardRequirement(uint256 SBFID) public override view returns (Requirement[] memory){
        return(_requiredMetadata[SBFID]);
    }

    function changeStandardRequirement(uint256 SBFID, Requirement[] memory requirements) public override returns (bool){
        require(msg.sender == admin);
        _requiredMetadata[SBFID] = requirements;    
        emit standardChanged(SBFID, requirements);
        return(true);     
    }

    function certify(address certifying, uint256 SBFID) public override returns (bool){
        require(msg.sender == admin);
        _SBTVerified[certifying][SBFID] = true;
        emit certified(certifying, SBFID);
        return(true);     
    }

    function revoke(address certifying, uint256 SBFID) external override returns (bool){
        require(msg.sender == admin);
        _SBTVerified[certifying][SBFID] = false;
        emit revoked(certifying, SBFID);
        return(true);     
    }

}
