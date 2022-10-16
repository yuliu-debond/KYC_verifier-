
abstract contract KYCABST is IERC6595{
    mapping(uint256 => IERC6595.Requirement[]) private _requiredMetadata;
    mapping(address => mapping(uint256 => bool)) private SBTVerified;

    function standardRequirement(uint256 SBFID) external override view returns (Requirement[] memory){
        return(_requiredMetadata[SBFID]);
    }

    function changeStandardRequirement(uint256 SBFID, Requirement[] memory requirements) external override returns (bool){
        _requiredMetadata[SBFID] = requirements;    
        emit standardChanged(SBFID, requirements);
        return(true);     
    }

    function certify(address certifying, uint256 SBFID) external override returns (bool){
        SBTVerified[certifying][SBFID] = true;
        emit certified(certifying, SBFID);
        return(true);     
    }

    function revoke(address certifying, uint256 SBFID) external override returns (bool){
        SBTVerified[certifying][SBFID] = false;
        emit revoked(certifying, SBFID);
        return(true);     
    }

}
