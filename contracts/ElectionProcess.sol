pragma solidity >=0.4.21 <0.6.0;

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

  function authorizeVoter (address _voterAddress) onlyOwner {

    // add an event
    if(voters[_voterAddress] == 0) {
      voters[_voterAddress] = Voter(false, true);
    }
  }

  function unauthorizeVoter (address _voterAddress) onlyOwner {

    require(voters[_voterAddress].isAuthorized == true);
    voters[_voterAddress].isAuthorized = false;
  }

  function addCandidate (address _candidateAddress,
                         string _name,
                         string _first,
                         string slogan,
                         string description,
                         string picture) onlyOwner onlyElectionPending {

    Candidate candidate = Candidate(false,
                                    0,
                                    _name,
                                    _first,
                                    _slogan,
                                    _description,
                                    _picture);

    uint index = candidates.push(candidate);
    candidateIndex[_candidateAddress] = index;
  }

  function disqualifyCandidate (address _candidateAddress) onlyOwner onlyElectionPending {

    // add an event
    uint index = candidateIndex[_candidateAddress];
    candidates[index].disqualified = true;
  }

  function getCandidates () external view returns(Candidate[]) {
    return candidates;
  }

  function vote (address _candidateAddress) external onlyAuthorized onlyElectionOpen {

    // add an event
    uint index = candidateIndex[_candidateAddress];
    candidates[index].voices += 1;
    voter.hasVoted = true;
  }

  function closeElection () onlyOwner onlyElectionOpen {

    //add an event
    isClosed = true;
    sortAsResults();
  }

  function openElection () onlyElectionPending {

    //add an event
    isPending = false;
  }

  function sortAsResults () internal {

    for (uint i = 0; i < candidates.length -2; i++) {

      if (candidates[i].voices < candidates[i+1].voices) {

        Candidate temp            = candidates[i];
                  candidates[i]   = candidates[i+1];
                  candidates[i+1] = temp;
      }
    }
  }

  function abstainers () external view returns(uint) {
    return voters - votes;
  }

  function results () external view returns (Candidate[]) { //view only read w/out modifying state
    return candidates;
  }
}
