pragma solidity >=0.4.21 <0.6.0;

contract Election {

  bool isStateElection;
  bool isSingleMemberBallots;

  event NewVote(uint candidateId, uint voices);

  struct Candidate {
    address   citizenId;
    Citizen   citizen;
    string    slogan;
    string    description;
  }

  mapping(address => uint)  candidatesVoices;
  mapping(address => Citizen) candidatePoolMembers;

  function createElection(bool _isStateElection, bool _isSingleMemberBallots) {

  }

  function createCandidate(Citizen _citizen) {

  }

  function vote(Candidate _candidate, Citizen _citizen) {
    NewVote(,);
  }
}
