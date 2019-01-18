pragma solidity >=0.4.21 <0.6.0;

import "./Election.sol";

contract ElectionProcess is Election {

  modifier onlyOwner () {
    require(msg.sender == owner);
    _;
  }

  modifier onlyAuthorized () {
    require(voters[msg.sender].isAuthorized);
    _;
  }

  modifier onlyElectionOpen () {
    require(!isPending);
    require(!isClosed);
    _;
  }

  modifier onlyElectionPending () {
    require(isPending);
    _;
  }

  function authorizeVoter (address _voterAddress) public onlyOwner {

    if (voters[_voterAddress].present == 0) {

      voters[_voterAddress] = Voter(false, true, 1);
      emit NewVoter(_voterAddress);
      votersCount += 1;
    }
  }

  function unauthorizeVoter (address _voterAddress) public onlyOwner {

    require(voters[_voterAddress].isAuthorized == true);
    voters[_voterAddress].isAuthorized = false;
    votersCount -= 1;
  }

  function addCandidate ( address _candidateAddress,
                          bool   _isListHead ) public onlyOwner onlyElectionPending {

    if (candidateIndex[_candidateAddress] == 0) {

      Candidate memory c = Candidate( false,
                                               0,
                                               _isListHead,
                                               false );
      if(c.isListHead){
        c.isListMember = true;
      }

      uint index = candidates.push(c);
      candidateIndex[_candidateAddress] = index;
      emit NewCandidate(index);
    }
  }

  function attachCandidateToList (address _headCandidateAddress, address _memberCandidateAddress) public onlyOwner onlyElectionPending {

    Candidate storage head = candidates[ candidateIndex[_headCandidateAddress]];
    Candidate storage member = candidates[ candidateIndex[_memberCandidateAddress]];

    require( head.isListHead      );
    require( !member.isListHead   );
    require( !member.isListMember );

    candidateListMembers[_headCandidateAddress] = _memberCandidateAddress;
    member.isListMember = true;

    emit CandidateStateChange(candidateIndex[_memberCandidateAddress]);
  }

  function pushCandidateToHeadList (uint _candidateId) public onlyOwner onlyElectionPending {
    require( !candidates[_candidateId].isListMember );

    candidates[_candidateId].isListHead   = true;
    candidates[_candidateId].isListMember = true;
  }

  function disqualifyCandidate (uint _candidateId) external onlyOwner onlyElectionPending {

    candidates[ _candidateId].disqualified = true;
    emit CandidateStateChange(_candidateId);
  }

  function isElector (address _voterAddress) public view returns (bool) {
    require(voters[_voterAddress].present == 1);

    if(voters[_voterAddress].isAuthorized) return true;
    return false;
  }

  function vote (address _candidateAddress) external onlyAuthorized onlyElectionOpen {

    Candidate storage c = candidates[ candidateIndex[_candidateAddress]];

    require( !c.isListMember );
    require( !c.disqualified );

    uint index = candidateIndex[_candidateAddress];
    candidates[index].voices += 1;
    Voter storage v = voters[msg.sender];
    v.hasVoted = true;
  }

  function closeElection () public onlyOwner onlyElectionOpen {

    isClosed = true;
    sortAsResults();
    emit ElectionStateChange(false,false);
  }

  function openElection () public onlyElectionPending {

    isPending = false;
    emit ElectionStateChange(true,false);
  }

  function sortAsResults () internal {

    for (uint i = 0; i < candidates.length -2; i++) {

      if (candidates[i].voices < candidates[i+1].voices) {

        Candidate storage temp    = candidates[i];
                  candidates[i]   = candidates[i+1];
                  candidates[i+1] = temp;
      }
    }
  }

  function abstainers () external view returns (uint) {

    return votersCount - totalVotes;
  }
}
